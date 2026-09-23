# Análise do Uso de IA — Aula 02 TF

## Prompt Utilizado

Crie um docker-compose.yml para uma aplicação Node.js 20 com Express que usa PostgreSQL 15 como banco de dados e Redis 7 como cache. A API roda na porta 3000. O PostgreSQL precisa de volume nomeado para persistência. Todos os serviços devem estar na mesma rede bridge customizada. Use variáveis de ambiente com interpolação de arquivo .env. Adicione healthchecks, depends_on com condition, e restart policy unless-stopped.

Também me entregue uma estrutura completa do projeto com:
- Dockerfile
- .dockerignore
- .gitignore
- package.json
- app.js
- .env
- .env.example
- ia-analise.md

Explique o que a IA gerou e o que eu devo ajustar manualmente para deixar o ambiente pronto para uso em desenvolvimento local.

## Output Original do Kiro

```yaml
version: '3.8'

services:
  api:
    build:
      context: .
      dockerfile: Dockerfile
    container_name: technova-api
    ports:
      - "${PORT:-3000}:3000"
    environment:
      - NODE_ENV=${NODE_ENV:-development}
      - PORT=3000
      - DB_HOST=postgres
      - DB_PORT=5432
      - DB_NAME=${POSTGRES_DB:-technova}
      - DB_USER=${POSTGRES_USER:-technova}
      - DB_PASSWORD=${POSTGRES_PASSWORD:-technova_tf_2024}
      - REDIS_HOST=redis
      - REDIS_PORT=6379
    depends_on:
      postgres:
        condition: service_healthy
      redis:
        condition: service_healthy
    networks:
      - technova-network
    restart: unless-stopped

  postgres:
    image: postgres:15-alpine
    container_name: technova-db
    environment:
      - POSTGRES_DB=${POSTGRES_DB:-technova}
      - POSTGRES_USER=${POSTGRES_USER:-technova}
      - POSTGRES_PASSWORD=${POSTGRES_PASSWORD:-technova_tf_2024}
    ports:
      - "5432:5432"
    volumes:
      - pgdata:/var/lib/postgresql/data
    networks:
      - technova-network
    restart: unless-stopped
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U technova -d technova"]
      interval: 10s
      timeout: 5s
      retries: 5
      start_period: 20s

  redis:
    image: redis:7-alpine
    container_name: technova-redis
    ports:
      - "6379:6379"
    networks:
      - technova-network
    restart: unless-stopped
    healthcheck:
      test: ["CMD", "redis-cli", "ping"]
      interval: 10s
      timeout: 5s
      retries: 5
      start_period: 10s

networks:
  technova-network:
    driver: bridge

volumes:
  pgdata:
    driver: local
```

## Alterações que Fiz Manualmente

| O que mudei | Por quê |
|------------|---------|
| Removi a linha `version` do arquivo Compose | O Docker Compose v2 considera essa chave obsoleta e emite aviso |
| Mudei a porta da API para `3001:3000` | A porta 3000 já estava em uso no ambiente local |
| Ajustei o bind do Express para `0.0.0.0` | Para garantir que o servidor responda corretamente fora do container |
| Revisei o `.env` e `.env.example` | Para evitar senhas hardcoded e manter a configuração segura |
| Validei o ambiente com `docker compose up` | Para confirmar que os serviços subiram de fato e responderam corretamente |

## O que o Kiro Acertou

- gerou a base correta do ambiente com 3 serviços
- entendeu a arquitetura com API + PostgreSQL + Redis
- definiu rede bridge customizada
- incluiu volume nomeado para persistência do banco
- inseriu healthchecks e dependências lógicas entre os serviços

## O que o Kiro Errou ou Omitiu

- não avisou que a porta 3000 pode estar ocupada em um ambiente local real
- não considerou que a chave `version` do Compose está obsoleta no Docker Compose v2
- exigiu revisão manual para adaptar o ambiente ao host real e validar a execução

## Minha Avaliação

- Tempo economizado usando IA: 20 minutos
- Tempo gasto validando: 15 minutos
- Nota para o output da IA: 8/10
- Usaria novamente: sim, porque acelera a criação da estrutura do ambiente, mas exige revisão crítica para adaptar o projeto ao ambiente real e validar o comportamento final.

## Evidência de Funcionamento

Comandos validados no ambiente:

```bash
cd /home/fabio/unifaat-devops-portfolio/aula-02
docker compose up -d --build
docker compose ps
curl http://localhost:3001
curl http://localhost:3001/health
docker compose exec postgres psql -U technova -d technova -c "SELECT 1;"
docker compose exec redis redis-cli ping
```

Resultado observado:
- API respondendo em `http://localhost:3001`
- PostgreSQL em status `healthy`
- Redis em status `healthy`
- Redis respondendo com `PONG`
