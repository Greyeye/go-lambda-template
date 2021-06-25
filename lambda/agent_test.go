package main

import (
	"context"
	"encoding/json"
	"github.com/aws/aws-lambda-go/events"

	"github.com/stretchr/testify/assert"
	"net/http"
	"testing"
)

func TestGetAgenthandler(t *testing.T) {

	var tests = []struct {
		eventInput            events.APIGatewayProxyRequest
		queryParametersExists bool
		expectedStatusCode    int
		expectedBody          string
	}{
		{
			events.APIGatewayProxyRequest{
				Path:                  "/agent",
				HTTPMethod:            http.MethodGet,
				QueryStringParameters: map[string]string{"agentname": "superman"},
			},
			true,
			200,
			"{\"AgentName\":\"superman\"}",
		},
		{
			events.APIGatewayProxyRequest{
				Path:                  "/agent",
				HTTPMethod:            http.MethodGet,
				QueryStringParameters: nil,
			},
			false,
			400,
			"{\"error\":\"'agentname' is missing from query parameter\"}",
		},
	}
	for _, test := range tests {

		lh, _ := NewLambdaHandler(NewAWSClient(context.Background()))

		ev := test.eventInput
		response, err := lh.handler(context.Background(), ev)
		agent := &struct{ AgentName string }{}
		json.Unmarshal([]byte(response.Body), agent)
		assert.Nil(t, err)
		assert.Equal(t, test.expectedStatusCode, response.StatusCode)
		assert.Equal(t, test.expectedBody, response.Body)
		if test.queryParametersExists == true {
			assert.Equal(t, "superman", agent.AgentName)
		}

	}

}
