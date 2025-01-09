# Load environment variables from app.env file
ifneq (,$(wildcard .env))
include .env
export
endif

postgres:
	docker run --restart=always --network db_network --name postgres12 -p 5433:5432 -e POSTGRES_USER=$(POSTGRES_USER) -e POSTGRES_PASSWORD=$(POSTGRES_PASSWORD) -d postgres:12-alpine

pgadmin:
	docker run -d --restart=always --network db_network -p 5050:80 --name pgadmin -e PGADMIN_DEFAULT_EMAIL=$(PGADMIN_DEFAULT_EMAIL) -e PGADMIN_DEFAULT_PASSWORD=$(PGADMIN_DEFAULT_PASSWORD) dpage/pgadmin4

createdb:
	docker exec -it postgres12 createdb --username=$(POSTGRES_USER) --owner=$(POSTGRES_USER) simple_bank

dropdb:
	docker exec -it postgres12 dropdb simple_bank

migrateup:
	migrate -path db/migration -database "$(DB_SOURCE)" -verbose up

migratedown:
	migrate -path db/migration -database "$(DB_SOURCE)" -verbose down

sqlc:
	sqlc generate

test:
	go test -v -count=1 -cover ./...

server:
	go run main.go

.PHONY: postgres pgadmin createdb dropdb migrateup migratedown sqlc test server
