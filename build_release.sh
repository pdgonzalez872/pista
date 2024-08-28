#!/bin/bash
echo "Building Phoenix release"
git pull origin main
export $(cat .env | xargs)
mix deps.get --only prod
MIX_ENV=prod mix ecto.migrate
MIX_ENV=prod mix compile
MIX_ENV=prod mix assets.build
MIX_ENV=prod mix assets.deploy
MIX_ENV=prod mix release --overwrite
