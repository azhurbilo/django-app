#!/bin/sh

# Step 1:
echo ">>> Step 1: check role/playbook syntax"
ansible-playbook -i tests/inventory tests/test.yml --syntax-check

# Step 2:
echo ">>> Step 2: run the role/playbook with ansible-playbook"
ansible-playbook -i tests/inventory tests/test.yml

# Step 3:
echo ">>> Step 2: run the role/playbook again, checking to make sure it's idempotent."
ansible-playbook -i tests/inventory tests/test.yml  | grep -q 'changed=0.*failed=0'\
&& (echo 'Idempotence test: Success' && exit 0) || (echo 'Idempotence test: Fail' && exit 1)