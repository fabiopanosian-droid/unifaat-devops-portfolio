# ==================================================
# Dockerfile - Portfolio DevOps API (Aula 01)
# Containeriza a API do portfólio DevOps
# ==================================================

# 1. Imagem base: Node.js 20 com Alpine Linux (leve)
FROM node:20-alpine

# 2. Definir diretório de trabalho dentro do container
WORKDIR /app

# 3. Copiar apenas arquivos de dependências primeiro
#    (OTIMIZAÇÃO: cache de camadas - se package.json não mudar,
#    a camada de npm install é reaproveitada do cache)
COPY package*.json ./

# 4. Instalar dependências de produção
RUN npm install --production

# 5. Copiar o restante do código-fonte
COPY . .

# 6. Documentar a porta que a aplicação utiliza
EXPOSE 3000

# 7. Comando para iniciar a aplicação
CMD ["node", "server.js"]
