#!/bin/bash

ENV="dev"

if [ "$1" = "prod" ]; then
    ENV="prod"
fi

cd ../..

echo "ENV: ${ENV}"

echo "-----------------------------------"
echo "Init terraform..."
terraform init -backend=true -backend-config="${ENV}/backend.hcl"
echo "-----------------------------------"

echo "-----------------------------------"
echo "Validating terraform files..."
terraform validate
echo "-----------------------------------"

echo "-----------------------------------"
echo "Planning..."
terraform plan -var-file="${ENV}/terraform.tfvars" -out="plan.tfout"
echo "-----------------------------------"

echo "-----------------------------------"
echo "Applying..."
terraform apply -auto-approve plan.tfout 
echo "-----------------------------------"

echo "-----------------------------------"
rm -f plan.tfout
echo "-----------------------------------"

echo "Done!"