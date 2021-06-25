package main

import (
	"context"
	"errors"
	"fmt"
	"github.com/Greyeye/go-lambda-template/pkg/awsclient"
	"github.com/aws/aws-lambda-go/lambda"
	"github.com/awslabs/aws-lambda-go-api-proxy/gorillamux"
	"github.com/gorilla/mux"
	"log"
	"net/http"
)

func main() {
	lh, err := NewLambdaHandler(NewAWSClient(context.Background()))
	if err != nil {
		log.Println(err)
		return
	}
	lambda.Start(lh.handler)
}

// NewLambdaHandler is a constructor to setup new lambda handler
func NewLambdaHandler(opts ...func(*LambdaHandler)) (*LambdaHandler, error) {
	lh := &LambdaHandler{}
	for _, opt := range opts {
		opt(lh)
	}
	// if awsClient is nil, system has failed to initialise configuration, return error
	if lh.awsClient == nil {
		return nil, errors.New("aws client init failed")
	}

	lh.gorillaMuxLambda = gorillamux.New(configRouter(lh))

	return lh, nil
}

func configRouter(lh *LambdaHandler) *mux.Router {
	r := mux.NewRouter()

	//some sample route
	r.HandleFunc("/agent", lh.getAgenthandler).Queries("agentname", "{agentname}").Methods(http.MethodGet)
	r.HandleFunc("/agent", lh.getAgenthandler).Methods(http.MethodGet)

	// R53 health check handler, this route must be outside of authentication
	r.HandleFunc("/check", func(w http.ResponseWriter, r *http.Request) {
		fmt.Println("health check from: ", r.UserAgent())
		w.WriteHeader(http.StatusOK)
	}).Methods(http.MethodGet)

	// "any" page handler, will return JSON payload with error and HTTP 404 code
	r.HandleFunc("/{any}", func(w http.ResponseWriter, r *http.Request) {
		w.WriteHeader(http.StatusNotFound)
		fmt.Fprint(w, "{\"error\":\"page not found\"}")
	}).Methods(http.MethodGet)
	return r
}

// NewAWSClient initialises the required aws configurations
func NewAWSClient(ctx context.Context) func(*LambdaHandler) {
	ac, err := awsclient.New(ctx)
	if err != nil {
		log.Println("init err:", err.Error())
		return func(l *LambdaHandler) {
			l.awsClient = nil
		}
	}
	return func(l *LambdaHandler) {
		l.awsClient = ac
	}
}

type LambdaHandler struct {
	awsClient *awsclient.Clients
	//someConfig  string
	gorillaMuxLambda *gorillamux.GorillaMuxAdapter
}
