package main

import (
	"context"
	"encoding/json"
	"errors"
	"fmt"
	"github.com/Greyeye/go-lambda-template/pkg/awsclient"
	"github.com/aws/aws-lambda-go/lambda"
	"github.com/awslabs/aws-lambda-go-api-proxy/gorillamux"
	"github.com/gorilla/mux"
	"go.uber.org/zap"
	"log"
	"net/http"
	"os"
)

func main() {
	InitLogger()
	lh, err := NewLambdaHandler(NewAWSClient(context.Background()))
	if err != nil {
		logger.Error(err)
		return
	}
	lambda.Start(lh.handler)
}

var logger *zap.SugaredLogger

// InitLogger set up the zap log system.
func InitLogger() {
	// set env variable of LogLevel to debug/info/error
	LogLevel := os.Getenv("LogLevel")
	if LogLevel == "" {
		LogLevel = "info"
	}
	rawJSON := []byte(`{
	  "level": "` + LogLevel + `",
	  "encoding": "json",
	  "errorOutputPaths": ["stderr"],
	  "outputPaths": ["stdout", "/dev/null"],
	  "encoderConfig": {
	    "messageKey": "message",
	    "levelKey": "level",
	    "levelEncoder": "lowercase"
	  }
	}`)

	var cfg zap.Config
	if err := json.Unmarshal(rawJSON, &cfg); err != nil {
		panic(err)
	}
	initLogger, err := cfg.Build()
	if err != nil {
		panic(err)
	}
	logger = initLogger.Sugar()
	defer logger.Sync()
	logger.Debug("Debug Mode")
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
	r.HandleFunc("/agent", lh.getAgenthandler).Queries("agentname", "{agentname}").Methods(http.MethodGet, http.MethodOptions)
	r.HandleFunc("/agent", lh.getAgenthandler).Methods(http.MethodGet, http.MethodOptions)

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

	r.Use(mux.CORSMethodMiddleware(r))
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
