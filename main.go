package main

import (
	"bank-app/api"
	db "bank-app/db/sqlc"
	"bank-app/utils"
	"database/sql"
	"log"

	_ "github.com/lib/pq"
)

func main() {
	config, err := utils.LoadConfig(".")
	if err != nil {
		log.Fatal("Cannot load config:", err)
	}

	conn, err := sql.Open(config.DBDriver, config.DBSource)
	if err != nil {
		log.Fatal("Cannot connect to db:", err)
	}

	store := db.NewStore(conn)
	server := api.NewServer(store)

	err = server.Start(config.ServerAddress)
	if err != nil {
		log.Fatal("Can't start server:", err)
	}
}
