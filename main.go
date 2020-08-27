package main

import (
	"io"
	"log"
	"net/http"
	"os"
)

func main() {
	port := os.Getenv("PORT")
	if port == "" {
		log.Fatal("$PORT must be set")
	}

	http.HandleFunc("/", handleIndex)
	log.Println(http.ListenAndServe(":"+port, nil))
}

func handleIndex(w http.ResponseWriter, r *http.Request) {
	if _, err := io.WriteString(w, `Usage: curl "https://<app name>.herokuapp.com/"`); err != nil {
		log.Println(err.Error())
	}
}
