package main

import (
	"fmt"
	"log"
	"net/http"
	"os"
)

func main() {
	log.Println("Registering the handler function for the root URL pattern '/'")
	http.HandleFunc("/", helloHandler)

	log.Println("Determining the port for Cloud Run deployment, or default to 8080 for local testing")
	port := os.Getenv("PORT")
	if port == "" {
		port = "8080"
		log.Printf("Defaulting to port %s", port)
	}

	log.Println("Starting the HTTP server")
	log.Printf("Listening on port %s", port)
	if err := http.ListenAndServe(":"+port, nil); err != nil {
		log.Fatal(err)
	}
}

func helloHandler(w http.ResponseWriter, r *http.Request) {
	log.Println("helloHandler writes the response to the client")
	fmt.Fprint(w, "Hello World")
}
