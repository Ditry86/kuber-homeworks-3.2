SHELL:=/usr/bin/env bash

export YC_OA_TOKEN := $(shell cat init.conf | grep oa_token | sed 's/oa_token = //')
export YC_CLOUD_ID := $(shell cat init.conf | grep cloud_id | sed 's/cloud_id = //')
export YC_FOLDER_ID := $(shell cat init.conf | grep folder_id | sed 's/folder_id = //')
export YC_ACCOUNT := $(shell cat init.conf | grep service_account | sed 's/service_account = //')
export TF_VAR_zone := $(shell cat init.conf | grep zone | sed 's/zone = //')
export MASTERS := $(shell cat init.conf | grep masters | sed 's/masters = //')
export WORKERS := $(shell cat init.conf | grep workers | sed 's/workers = //')
export INGRESS := $(shell cat init.conf | grep ingress | sed 's/ingress = //')
export ANSIBLE_HOST_KEY_CHECKING=False

prepare: cloud tf_init
deploy: tf_plan tf_apply
#apps: get_ip play info
kubespray: prep_ks ks_start

install:
	@source auto/install_env_app.sh

tester:
	@source auto/test.sh

cloud:
	@source $(HOME)/.bashrc && auto/init_cloud.sh

tf_init:
	@source auto/tf_provider_mirror.sh	
	@source auto/init_tf_vars.sh > terraform/vars.tf
	@cd terraform && terraform init 

tf_plan: 
	@export YC_TOKEN=$(shell cat ./token) && cd terraform && terraform plan -out=terraform.tfplan

tf_apply: 
	@export YC_TOKEN=$(shell cat ./token) && cd terraform && terraform apply -auto-approve terraform.tfplan 

destroy: 
	@source $(HOME)/.bashrc && export YC_TOKEN=$(shell cat ./token) && source auto/destroy.sh

prep_ks:
	@source auto/generate_inventory.sh > kubspray/inventory/mycluster/inventory.ini
	@source auto/generate_k8s.sh >> kubspray/inventory/mycluster/group_vars/k8s_cluster/k8s_cluster.yml

ks_start:
	cd ./kubspray &&  ./venv/bin/ansible-playbook cluster.yml -b -i inventory/mycluster/inventory.ini

get_ip:
	@source auto/get_ip.sh

play:
	@source auto/prepare_ansible.sh
	cd ./kubespray && ./venv/bin/ansible-galaxy install -r requirements.yml -p roles && ansible-playbook site.yml -i inventory/prod.yml

info:
	@echo Your VM IP adresses:
	@echo ""
	@cd terraform && terraform output
