# Serverless Applications

Para testar estrutura via Postman, importe a collection **postman/terraform-serverless-app.postman_collection.json** para seu Postman, vá na *collection > edit > variables*, e preencha as seguintes variáveis:
- **cognito_user**: Client Id do Cognito. Equivalente ao output *cg_client_id* da stack do Terraform.
- **cognito_pass**: Client Secret do Cognito. Equivalente ao output *cg_client_secret* da stack do Terraform.

Para testar via S3, execute o seguinte commando de dentro da pasta *04-serverless-application*:

```bash
aws s3 cp ./files/todo.json s3://<bucket-name>
```

Onde **bucket_name** é o nome do bucket, equivalente ao output *bucket_name* da stack do Terraform.