#!/bin/bash

echo "Installing PostgreSQL 12 Docker image..."
docker run -it --rm -e POSTGRES_PASSWORD=mysecretpassword -v postgres12-data:/var/lib/postgresql/data -p 5432:5432 postgres:12