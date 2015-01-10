#!/bin/sh

set -e

if [ "$1" = "vagrant" ]
  then
    echo "Vagrant..."
    INVENTORY_FILE=vagrant-inventory
    vagrant up

elif [ "$1" = "local" ]
  then
    echo "Local..."
    INVENTORY_FILE=local-inventory

else
  echo "First argument is not defined properly. Choose [ vagrant | local ] ..."
  exit
fi

# Step 1:
echo ">>> Step 1: Install required dependencies roles."
ansible-galaxy install -r ansible_requirements.txt --force

# Step 2:
echo ">>> Step 2: check role/playbook syntax"
ansible-playbook -i ${INVENTORY_FILE} playbook.yml --syntax-check

# Step 3:
echo ">>> Step 3: run the role/playbook with ansible-playbook"
ansible-playbook -i ${INVENTORY_FILE} playbook.yml

if [ "$2" = "skip" ]
  then
    exit 0
fi

# Step 4:
echo ">>> Step 4: run the role/playbook again, checking to make sure it's idempotent."
echo ">>> Ansible..."
ansible-playbook -i ${INVENTORY_FILE} playbook.yml > out.txt 2>&1

cat out.txt

cat out.txt | grep -q 'changed=0.*failed=0'\
&& (echo 'Idempotence test: Success' && rm out.txt && exit 0) || (echo 'Idempotence test: Fail' && rm out.txt && exit 1)

if [ "$1" = "vagrant" ]
then

# Step 5:
echo ">>> Step 5: run the role/playbook again, after machine reboot to make sure it's idempotent as well =)"
vagrant reload
echo ">>> Ansible..."
ansible-playbook -i ${INVENTORY_FILE} playbook.yml > out.txt 2>&1

cat out.txt

cat out.txt | grep -q 'changed=0.*failed=0'\
&& (echo 'Idempotence test after reboot: Success' && rm out.txt && exit 0) || (echo 'Idempotence test after reboot: Fail' && rm out.txt && exit 1)

fi


echo "=================="
echo "SUCCESS"
echo "=================="