#!/usr/bin/env bash
# enable fail detection...
set -e
source /initialize.sh
initialize

echo "StrictHostKeyChecking no" >> /etc/ssh/ssh_config
HOSTIP=$(vagrant ssh-config | awk '/HostName/ {print $2}')

echo -e "\nSETTING up Dokku SSH key.\n"

cat /.ssh/id_rsa.pub | vagrant ssh -c "docker exec -i dokku sshcommand acl-add dokku root"

echo -e "\nCREATING repo\n"

mkdir dockertest
cd dockertest/
git init
git config user.email "engineering@protonet.info"
git config user.name "Protonet Integration Test node.js"

echo -e "FROM experimentalplatform/ubuntu:latest\nRUN apt-get -y update && apt-get -y install nmap\nCMD /usr/bin/ncat -c 'echo $(date)' -l -k 5000" > Dockerfile
# http://progrium.viewdocs.io/dokku/checks-examples.md
echo -e "WAIT=10\nATTEMPTS=20\n/ Hello" > CHECKS
git add .
git commit -a -m "Initial Commit"

echo -e "\nRUNNING git push to ${HOSTIP}\n"

git remote add dokku ssh://dokku@${HOSTIP}:8022/dockerfile-app
# destroy in case it's already deployed
ssh -t -p 8022 dokku@${HOSTIP} apps:destroy dockerfile-app force || true
# ssh -t -p 8022 dokku@${HOSTIP} trace on
git push dokku master

wget -O - http://${HOSTIP}/dockerfile-app
