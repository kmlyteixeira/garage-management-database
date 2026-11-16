# RFC-002: Estratégia de persistência dos microsserviços

- Status: Proposed

## Problema
Os microsserviços precisam de persistência isolada por bounded context, sem
compartilhar schema ou credenciais entre serviços.

## Contexto
OS Service e Billing Service usam PostgreSQL 16/Npgsql. Execution Service usa
MongoDB. No AWS Academy, o MongoDB é executado de forma persistente no EKS,
pois a role do laboratório não pode criar instâncias DocumentDB. Em
desenvolvimento, Docker Compose fornece duas instâncias PostgreSQL e uma
instância MongoDB independentes.

## Alternativas
RDS PostgreSQL separado por serviço, Aurora PostgreSQL, PostgreSQL
autogerenciado, MongoDB autogerenciado e Amazon DocumentDB.

## Critérios
Isolamento, compatibilidade dos drivers, custo, backup, disponibilidade,
operação, recuperação e separação de credenciais.

## Solução proposta
Dois RDS PostgreSQL privados, um por serviço relacional. O MongoDB do Execution
Service é provisionado pela plataforma EKS com volume persistente, enquanto
este repositório publica a URI interna no SSM. Os microsserviços mantêm a
evolução do schema lógico.

## Impactos e riscos
A compatibilidade é alta e os dados ficam isolados. O MongoDB no EKS reduz o
custo e funciona no AWS Academy, mas exige operação do volume, backups,
atualizações e alta disponibilidade pela equipe.

## Plano
Executar `docker compose -f docker-compose.local.yml up -d` para o cenário
local. Para produção, fornecer os dois passwords PostgreSQL por secrets,
security groups dos workloads EKS, duas subnets privadas, `multi_az=true`,
executar o apply da plataforma antes do banco, validar o volume persistente
do MongoDB e publicar a URI via SSM/External Secrets.
