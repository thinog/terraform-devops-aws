#!/bin/bash

ENV="dev"

if [ "$1" = "prod" ]; then
    ENV="prod"
fi

cd ../..

echo "ENV: ${ENV}"

echo "Destroying..."
terraform destroy -var-file="${ENV}/terraform.tfvars" -auto-approve

rm -rf .terraform

echo "Done!"