# Autoscaling Application

Para validar, basta acessar as duas instâncias geradas inicialmente via SSH (dá pra fazer pelo Console da AWS) e deixar o seguinte comando executando:
```bash
stress --cpu 1 --timeout 300
```

Então acompanhar os alertas pelo CloudWatch e pelo Autoscaling Group.