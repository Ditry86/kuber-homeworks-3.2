#!/bin/bash

set -e

cd ./terraform

printf "[all]\n"
for (( num=1; num<=$MASTERS; num++ ))
do
    printf "master-$num   ansible_host=$(terraform output -json master_external_ip_address | jq --arg i $(($num-1)) '.[$i]')"
    printf "   ip=$(terraform output -json master_local_ip_address | jq --arg i $(($num-1)) '.[$i]')"
    printf "   ansible_user=ubuntu"
    printf "   etcd_member_name=etcd-$num\n"
done

for (( num=1; num<=$WORKERS; num++ ))
do
    printf "worker-$num   ansible_host=$(terraform output -json worker_external_ip_address | jq --arg i $(($num-1)) '.[$i]')"
    printf "   ip=$(terraform output -json worker_local_ip_address | jq --arg i $(($num-1)) '.[$i]')"
    printf "   ansible_user=ubuntu"
    printf "\n"
done

for (( num=1; num<=$INGRESS; num++ ))
do
    printf "ingress-$num   ansible_host=$(terraform output -json ingress_external_ip_address | jq --arg i $(($num-1)) '.[$i]')"
    printf "   ip=$(terraform output -json ingress_local_ip_address | jq --arg i $(($num-1)) '.[$i]')"
    printf "   ansible_user=ubuntu"
    printf "\n"
done

printf "\n[kube-master]\n"
for (( num=1; num<=$MASTERS; num++ ))
do
    printf "master-$num\n"
done

printf "\n[etcd]\n"
for (( num=1; num<=$MASTERS; num++ ))
do
    printf "master-$num\n"
done

printf "\n[kube-node]\n"
for (( num=1; num<=$WORKERS; num++ ))
do
    printf "worker-$num\n"
done
for (( num=1; num<=$INGRESS; num++ ))
do
    printf "ingress-$num\n"
done

printf "\n[kube-ingress]\n"
for (( num=1; num<=$INGRESS; num++ ))
do
    printf "ingress-$num\n"
done

printf "\n[kube-worker]\n"
for (( num=1; num<=$WORKERS; num++ ))
do
    printf "worker-$num\n"
done

printf "\n[k8s-cluster:children]
kube-master
kube-node
"

cd ..