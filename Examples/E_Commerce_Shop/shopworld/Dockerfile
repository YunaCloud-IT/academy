# ---------------------------------------
# Stage 1: Builder
# ---------------------------------------
FROM node:20-slim AS builder

WORKDIR /app

# Copy root package files
COPY package.json package-lock.json ./

# Install dependencies
RUN npm install

# Copy source code
COPY . .

# Build the backend
RUN npx nx build backend --prod

# ---------------------------------------
# Stage 2: Runner
# ---------------------------------------
FROM node:20-slim AS runner

WORKDIR /app

ENV NODE_ENV=production

# 1. COPY package.json from your specific output path
#    Note: We updated the path from /dist/apps/backend -> /apps/backend/dist
COPY --from=builder /app/package*.json ./

# Install production dependencies
RUN npm install --omit=dev

# 2. COPY main.js from your specific output path
COPY --from=builder /app/apps/backend/dist/main.js ./

EXPOSE 3000

CMD ["node", "main.js"]
