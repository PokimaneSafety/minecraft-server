package main

import (
	"context"
	"errors"
	"log"
	"net/http"
	"os"
	"os/signal"
	"syscall"
)

func main() {
	host := ""
	port := "8080"

	secret, ok := os.LookupEnv("DEPLOYD_SECRET")
	if !ok {
		log.Fatalln("no deployer secret configured")
	}

	dpl := NewDeployer()
	srv := NewServer(dpl, secret, host, port)

	go func() {
		log.Printf("Listening at %s:%s\n", host, port)
		err := srv.ListenAndServe()
		if errors.Is(err, http.ErrServerClosed) {
			log.Println("Server closed")
		} else {
			log.Printf("Error listening %v", err)
		}
	}()
	defer func() {
		log.Println("Closing server")
		srv.Shutdown(context.Background())
	}()

	sigs := make(chan os.Signal, 1)
	signal.Notify(sigs, os.Interrupt, syscall.SIGTERM)
	<-sigs
}
