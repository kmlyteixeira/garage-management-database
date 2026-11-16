# RFC-002: Estratégia de persistência dos microsserviços

- Status: Proposed

## Problema
Os microsserviços precisam de persistência isolada por bounded context, sem
compartilhar schema ou credenciais entre serviços.

## Contexto
OS Service e Billing Service usam PostgreSQL 16/Npgsql. Execution Service usa
MongoDB; em produção, o Terraform provisiona Amazon DocumentDB compatível com
MongoDB. Em desenvolvimento, Docker Compose fornece duas instâncias PostgreSQL
e uma instância MongoDB independentes.

## Alternativas
RDS PostgreSQL separado por serviço, Aurora PostgreSQL, PostgreSQL
autogerenciado, MongoDB autogerenciado e Amazon DocumentDB.

## Critérios
Isolamento, compatibilidade dos drivers, custo, backup, disponibilidade,
operação, recuperação e separação de credenciais.

## Solução proposta
Dois RDS PostgreSQL privados, um por serviço relacional, e um cluster
DocumentDB para o Execution Service. Os microsserviços mantêm a evolução do
schema lógico; este repositório provisiona somente rede, instâncias, backups,
segurança e outputs.

## Impactos e riscos
A compatibilidade é alta e os dados ficam isolados. DocumentDB exige conexão
TLS e deve usar pelo menos duas instâncias em produção. O custo é maior que um
banco compartilhado, mas reduz acoplamento e limita o impacto de falhas.

## Plano
Executar `docker compose -f docker-compose.local.yml up -d` para o cenário
local. Para produção, fornecer os três passwords por secrets, security groups
dos workloads EKS, duas subnets privadas, `multi_az=true` e
`docdb_instance_count >= 2`, executar plan aprovado e publicar os endpoints
via Secrets Manager/External Secrets.
