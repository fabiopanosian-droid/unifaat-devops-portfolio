# Aula 03 - Terraform + IAM | Fabio Panosian (RA 6325250)

## Design da estrutura IAM

O grupo `6325250-technova-developers` concentra usuários que precisam ler
objetos dos buckets TechNova. O grupo `6325250-technova-platform-eng` separa
as responsabilidades de plataforma e permite que Rafael gerencie instâncias
EC2 e leia ou grave objetos S3 dentro dos limites definidos.

Juliana e Lucas pertencem somente a `developers`. Rafael pertence aos dois
grupos porque precisa combinar desenvolvimento e operações de plataforma.

As policies são customizadas: a policy de leitura permite apenas listar
buckets e obter objetos; a policy de plataforma permite descrever EC2,
iniciar ou parar somente instâncias com a tag `Project=TechNova` e operar em
objetos S3; a policy de negação bloqueia ações destrutivas. A role da EC2
aceita somente o serviço EC2 e acessa apenas buckets `technova-app-data-*`.

## Princípio do menor privilégio

Menor privilégio significa conceder somente as ações e os recursos necessários
para cada função. Neste projeto, isso foi aplicado de duas formas:

1. Os desenvolvedores recebem leitura S3 em vez de acesso administrativo.
2. O grupo de plataforma pode iniciar e parar apenas instâncias com a tag do
   projeto, e a role da EC2 é limitada aos buckets de dados da aplicação.

Usar `AmazonS3FullAccess` daria permissões muito amplas, incluindo buckets e
objetos que não pertencem à TechNova. Policies específicas reduzem o impacto
de credenciais comprometidas e tornam a revisão de permissões mais objetiva.

## Diagrama de permissões

```text
Juliana + Rafael + Lucas -> developers -> s3-read + deny-destructive
Rafael                  -> platform-eng -> ec2-s3-full

EC2 -> instance profile -> ec2 role -> ec2-s3-access -> technova-app-data-*
```

## Comandos executados localmente

```bash
terraform fmt
terraform init -backend=false
terraform validate
```

## Comandos previstos para o laboratório AWS

```bash
terraform plan
terraform apply
terraform destroy
```

## Reflexão

O Console AWS pode ser útil para inspeções rápidas, mas a criação manual é
mais sujeita a diferenças entre ambientes e a alterações sem rastreabilidade.
Terraform registra a configuração em código, permite revisão por Pull Request
e facilita repetir ou auditar o desenho de permissões.

## Limitação de execução

Durante esta entrega não houve acesso ao AWS Academy Learner Lab. Por isso,
`terraform validate` foi executado localmente, mas `plan`, `apply` e
`destroy` não foram executados contra uma conta AWS. Nenhum recurso real foi
criado por este projeto.