package main

import (
	"fmt"
	"io"
	"net"
	"os"
)

func main() {
	port := os.Getenv("PORT")
	if port == "" {
		panic("Missing PORT environment variable")
	}
	ln, err := net.Listen("tcp", ":"+port)
	if err != nil {
		panic(err)
	}

	for {
		conn, err := ln.Accept()
		if err != nil {
			panic(err)
		}

		go handleRequest(conn)
	}
}

func handleRequest(conn net.Conn) {
	fmt.Println("new client")

	addr := net.JoinHostPort("127.0.0.1", os.Getenv("WAYBACK_TOR_LOCAL_PORT"))
	proxy, err := net.Dial("tcp", addr)
	if err != nil {
		panic(err)
	}

	fmt.Println("proxy connected")
	go copyIO(conn, proxy)
	go copyIO(proxy, conn)
}

func copyIO(src, dest net.Conn) {
	defer src.Close()
	defer dest.Close()
	io.Copy(src, dest)
}
