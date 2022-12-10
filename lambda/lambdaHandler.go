package main

import (
	"context"
	"github.com/aws/aws-lambda-go/events"
)

// Handler is entry point for the lambda for API Gateway HTTP V2
func (l *LambdaHandler) Handler(ctx context.Context, ev events.APIGatewayV2HTTPRequest) (events.APIGatewayV2HTTPResponse, error) {
	return l.ginLambdaV2.ProxyWithContext(ctx, ev)
}

/*
This is the old entry for API Gateway V1
event and return payload is slightly different to v2.
func (l *LambdaHandler) Handler(ctx context.Context, ev events.APIGatewayProxyRequest) (events.APIGatewayProxyResponse, error) {
	return l.ginLambda.ProxyWithContext(ctx, ev)
}
*/
