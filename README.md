# DevOps: AWS com Terraform
Infraestrutura AWS criada com Terraform, a partir do curso [DevOps: AWS com Terraform Automatizando sua infraestrutura][udemy-course]

Curso realizado utilizando a versão 0.13.5 do Terraform CLI.

## Comandos utilizados via CLI

```terraform init [-backend=true] [-backend-config='key=value]```

```terraform show```

```terraform plan [-var 'variable=value'] [-var-file='file']```

```terraform apply [-var 'variable=value'] [-var-file='file'] [-auto-approve]```

```terraform destroy [-target <object_to_destroy>]```

```terraform taint <object>```

```terraform untaint <object>```

```terraform console```

```terraform fmt [--recursive]```

```terraform get```

```terraform import <resource> <object_name>```

```terraform graph```

```terraform output <output_key>```

```terraform validate```

```terraform workspace <command> <args>```

```terraform refresh```

---

Para detalhes sobre a ferramenta de CLI e seus comandos, olhe a [documentação][cli-doc].

[udemy-course]: https://www.udemy.com/course/aws-com-terraform/
[cli-doc]: https://www.terraform.io/docs/commands/index.html
