package main

import (
	"fmt"
	"log"
	"net/http"
)

func NewServer(deployer Deployer, host, port string) *http.Server {
	handler := http.NewServeMux()
	handler.HandleFunc("/healthz", func(w http.ResponseWriter, r *http.Request) {
		if r.Method != http.MethodGet {
			return
		}

		w.WriteHeader(http.StatusOK)
		w.Write([]byte("OK"))
	})
	handler.HandleFunc("/deploy", logHttp(func(w http.ResponseWriter, r *http.Request) {
		if r.Method != http.MethodPost {
			return
		}

		if err := deployer.Deploy(); err != nil {
			w.WriteHeader(http.StatusInternalServerError)
			w.Write([]byte(err.Error()))
			return
		}

		w.WriteHeader(http.StatusOK)
		w.Write([]byte("OK"))
	}))
	return &http.Server{
		Addr:    fmt.Sprintf("%s:%s", host, port),
		Handler: handler,
	}
}

func logHttp(handler func(http.ResponseWriter, *http.Request)) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		handler(w, r)
		log.Printf("%s %s\n", r.Method, r.URL.Path)
	}
}
