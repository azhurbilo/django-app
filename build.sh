#!/bin/sh

# Run the role/playbook with ansible-playbook.
ansible-playbook -i tests/inventory tests/test.yml --syntax-check