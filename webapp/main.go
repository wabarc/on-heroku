package main

import (
	"flag"
	"net/http"
)

var port string

func redirect(w http.ResponseWriter, req *http.Request) {
	println("Redirecting to: " + "https://" + req.Host + req.URL.String())
	if req.Header.Get("X-Forwarded-Proto") == "http" {
		http.Redirect(w, req, "https://"+req.Host+req.URL.String(), http.StatusMovedPermanently)
	}
}

func main() {
	flag.StringVar(&port, "port", "80", "Port listen on")
	flag.Parse()

	http.ListenAndServe(":"+port, http.HandlerFunc(redirect))
}
