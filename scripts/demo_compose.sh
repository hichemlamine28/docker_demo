#!/bin/bash
mkdir compose
cd compose
docker-compose config
docker compose up -d

docker compose ps

docker compose logs --tail 100 -f

