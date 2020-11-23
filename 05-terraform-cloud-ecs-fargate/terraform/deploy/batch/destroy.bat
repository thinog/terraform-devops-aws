@echo off

set ENV=dev

if "%1%"=="prod" set ENV=prod

cd ../..

echo "ENV: %ENV%"

echo "Destroying..."
terraform destroy -var-file="%ENV%/terraform.tfvars" -auto-approve

rd /s /q .terraform

echo "Done!"