package main

import (
	"context"
	"encoding/json"
	"errors"
	"github.com/Greyeye/go-lambda-template/pkg/awsclient"
	"github.com/aws/aws-lambda-go/lambda"
	"github.com/aws/aws-xray-sdk-go/xray"
	ginadapter "github.com/awslabs/aws-lambda-go-api-proxy/gin"
	"github.com/gin-gonic/gin"
	gxr "github.com/oroshnivskyy/go-gin-aws-x-ray/xray"
	"go.uber.org/zap"
	"log"
	"net/http"
	"os"
	"strings"
)

func main() {
	InitLogger()
	lh, err := NewLambdaHandler(NewAWSClient(context.Background()))
	if err != nil {
		logger.Error(err)
		return
	}
	lambda.Start(lh.Handler)
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

// NewLambdaHandler is a constructor to set up new lambda handler
func NewLambdaHandler(opts ...func(*LambdaHandler)) (*LambdaHandler, error) {
	lh := &LambdaHandler{}
	for _, opt := range opts {
		opt(lh)
	}
	// if awsClient is nil, system has failed to initialise configuration, return error
	if lh.awsClient == nil {
		return nil, errors.New("aws client init failed")
	}

	lh.ginLambdaV2 = ginadapter.NewV2(configRouter(lh))

	return lh, nil
}

func configRouter(lh *LambdaHandler) *gin.Engine {
	// gin log print out mode
	gin.SetMode("debug")
	r := gin.New()
	// Global middleware
	// Logger middleware will write the logs to gin.DefaultWriter even if you set with GIN_MODE=release.
	// By default, gin.DefaultWriter = os.Stdout
	r.Use(gin.Logger())

	// Recovery middleware recovers from any panics and writes a 500 if there was one.
	r.Use(gin.Recovery())

	// xray middleware to provide wrapper service for XRAY context.
	r.Use(gxr.Middleware(xray.NewDynamicSegmentNamer(os.Getenv("AWS_LAMBDA_FUNCTION_NAME"), "*.execute-api.ap-southeast-2.amazonaws.com")))
	// API Gateway v2 adds staging prefix to the route (e.g. /development/sign)
	// add group route that matches with the staging name variable.
	// STAGING = "", is for SAM test
	// STAGING = development is for UAT/DEV env.
	// STAGING = main is for Production.
	v := r.Group("/" + strings.ToLower(os.Getenv("STAGING")))
	{
		v.GET("/agent", lh.getAgenthandler)
		r.GET("/check", func(c *gin.Context) {
			logger.Info("health check from: ", c.Request.UserAgent())
			c.Status(http.StatusNoContent)
		})
	}

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
	ginLambdaV2 *ginadapter.GinLambdaV2
}
