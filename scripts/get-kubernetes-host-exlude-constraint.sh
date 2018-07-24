#!/bin/bash
#
# SCRIPT: get-kubernetes-host-exlude-constraint.sh
#
# DESCR: Create a Marathon constraint that excludes host ip addresses that
#        already have  Kubernetes tasks running on them.
#
#        [["@hostname", "unlike", "<IP_ADDRESS_1>|<IP_ADDRESS_2>|<IP_ADDRESS_3>|<IP_ADDRESS_4>|<IP_ADDRESS_5>"]]
#

ip_list=`dcos task | grep -e kube -e etcd | awk '{print $2}' | sort -u`

if [ "$ip_list" == "" ]
then
    echo
    echo " There are no kubernetes tasks running. Exiting."
    echo
    exit 1
fi

constraint=""

for ip in $ip_list
do
    echo " Adding $ip to the constraint"

    constraint="$constraint${ip}|"
done

# Remove the trailing pipe char
constraint=`echo $constraint | sed 's/.$//'`

# Complete the constraint string
constraint="[[\"@hostname\", \"unlike\", \"${constraint}\"]]"

echo
echo " Use this constraint: "
echo
echo " $constraint "
echo

# end of script
