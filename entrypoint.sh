#!/bin/bash

# Create an inventory.json file if the ANSIBLE_INVENTORY_JSON variable is defined
if [[ -n "${ANSIBLE_INVENTORY_JSON}" ]]; then
  echo "${ANSIBLE_INVENTORY_JSON}" > /postgresql_cluster/inventory.json
fi

# Execute the passed command
exec "$@"
