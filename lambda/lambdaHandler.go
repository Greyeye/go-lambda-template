package main

import (
	"context"
	"github.com/aws/aws-lambda-go/events"
)

// handler is entry point for the lambda.
func (h *LambdaHandler) handler(ctx context.Context, ev events.APIGatewayProxyRequest) (events.APIGatewayProxyResponse, error) {
	return h.gorillaMuxLambda.ProxyWithContext(ctx, ev)
}
