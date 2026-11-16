$ErrorActionPreference = "Stop"

docker compose -f docker-compose.local.yml up -d
if ($LASTEXITCODE -ne 0) {
    throw "Docker Compose could not start the local database stack."
}
try {
    docker compose -f docker-compose.local.yml ps
    if ($LASTEXITCODE -ne 0) { throw "Could not inspect the local database stack." }
    docker compose -f docker-compose.local.yml exec -T postgres-os pg_isready -U garage -d os_service
    if ($LASTEXITCODE -ne 0) { throw "OS PostgreSQL health check failed." }
    docker compose -f docker-compose.local.yml exec -T postgres-billing pg_isready -U garage -d billing_service
    if ($LASTEXITCODE -ne 0) { throw "Billing PostgreSQL health check failed." }
    docker compose -f docker-compose.local.yml exec -T mongodb-execution mongosh --quiet --eval "db.adminCommand('ping').ok"
    if ($LASTEXITCODE -ne 0) { throw "Execution MongoDB health check failed." }
    Write-Output "Local database stack is healthy."
}
finally {
    docker compose -f docker-compose.local.yml down
}
