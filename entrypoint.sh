#!/bin/bash

# Check if ANSIBLE_INVENTORY_JSON is set and create inventory.json if it is
if [[ -n "${ANSIBLE_INVENTORY_JSON}" ]]; then
  echo "Creating inventory.json with the content of ANSIBLE_INVENTORY_JSON"
  echo "${ANSIBLE_INVENTORY_JSON}" > /postgresql_cluster/inventory.json
  # Set ANSIBLE_INVENTORY environment variable
  export ANSIBLE_INVENTORY=/postgresql_cluster/inventory.json
  # Set ANSIBLE_SSH_ARGS environment variable
  export ANSIBLE_SSH_ARGS="-o StrictHostKeyChecking=no"
fi

# Check if SSH_PRIVATE_KEY_CONTENT is set and create the SSH private key file if it is
if [[ -n "${SSH_PRIVATE_KEY_CONTENT}" ]]; then
  echo "Creating SSH private key file with the content of SSH_PRIVATE_KEY_CONTENT"
  mkdir -p /root/.ssh
  echo "${SSH_PRIVATE_KEY_CONTENT}" > /root/.ssh/id_rsa
  chmod 600 /root/.ssh/id_rsa
  # Set ANSIBLE_PRIVATE_KEY_FILE environment variable
  export ANSIBLE_PRIVATE_KEY_FILE=/root/.ssh/id_rsa
fi

# Execute the passed command
exec "$@"
