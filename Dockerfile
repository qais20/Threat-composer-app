FROM node:18-alpine AS builder

WORKDIR /app

COPY package.json yarn.lock ./

RUN yarn install --frozen-lockfile

COPY . .

RUN yarn build

# Production stage
FROM node:18-alpine

ENV NODE_ENV=production
ENV NEXT_OUTPUT_STANDALONE=true

WORKDIR /app

COPY --from=builder /app/build ./build
COPY --from=builder /app/package.json ./package.json
COPY --from=builder /app/yarn.lock ./yarn.lock

RUN yarn install --frozen-lockfile --production

EXPOSE 3000

RUN yarn global add serve

CMD ["serve", "-s", "build", "-l", "3000"]
