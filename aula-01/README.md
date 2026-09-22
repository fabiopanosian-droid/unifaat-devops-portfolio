# Aula 01 — Fundamentos de Git e Docker

## O que aprendi

- Criar e inicializar um repositório Git.
- Fazer commits e consultar o histórico do projeto.
- Trabalhar com branches e realizar merge.
- Utilizar `.gitignore` para ignorar arquivos sensíveis.
- Criar uma API com Node.js e Express.
- Criar imagens e executar containers Docker.

## Comandos Git praticados

- `git init`
- `git status`
- `git add`
- `git commit`
- `git log`
- `git branch`
- `git checkout`
- `git merge`
- `git push`

## Comandos Docker praticados

- `docker build`
- `docker run`
- `docker ps`
- `docker logs`
- `docker stop`
- `docker rm`

## Como executar

```bash
cd aula-01/app
npm install
npm start
```

Para executar com Docker:

```bash
cd aula-01/app
docker build -t portfolio-aula01:1.0 .
docker run -d --name portfolio-test -p 3000:3000 portfolio-aula01:1.0
curl http://localhost:3000
curl http://localhost:3000/health
```

## Dificuldades encontradas

A principal dificuldade foi entender a diferença entre executar a aplicação localmente e executá-la dentro de um container. O Dockerfile permitiu padronizar o ambiente da aplicação.