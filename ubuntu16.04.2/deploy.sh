#!/bin/sh
if [ "$#" -ne 2 ]; then
    echo "Usage: deploy.sh <FE_NAME> <FE_USER>"
    exit
fi
command -v cm >/dev/null 2>&1 || { echo "'cm comet' not available. Please make sure cloudmesh_client is installed or the virtualenv is activated" >&2; exit 1; }
hosts=hosts.ini
echo "[vc_fe]" > $hosts
echo "$1.sdsc.edu ansible_user=$2" >> $hosts
ssh $2@$1.sdsc.edu "mkdir -p ~/.ssh; echo \"`cat ~/.ssh/id_rsa.pub`\" >> .ssh/authorized_keys"
python cmutil.py nodesfile $1
ansible-playbook -i $hosts fe_deploy.yml
