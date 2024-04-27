cd ./terraform
printf "
## Supplementary addresses that can be added in kubernetes ssl keys.
## That can be useful for example to setup a keepalived virtual IP
supplementary_addresses_in_ssl_keys: ["
for (( num=1; num<=$MASTERS; num++ ))
do
    printf "$(terraform output -json master_external_ip_address | jq --arg i $(($num-1)) '.[$i]'),"
done
printf "]\n"