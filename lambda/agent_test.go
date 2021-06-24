package main

import (
	"context"
	"encoding/json"

	"github.com/aws/aws-lambda-go/events"

	"github.com/awslabs/aws-lambda-go-api-proxy/gorillamux"
	"github.com/gorilla/mux"
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

		lh := &LambdaHandler{}

		// create the new router and replace override the default.
		// dont call the method directly with http requests, as MUX will not handle QueryStringParameters.
		router := mux.NewRouter()
		// setup different handler if query is missing.
		if test.queryParametersExists {
			router.HandleFunc("/agent", lh.getAgenthandler).Queries("agentname", "{agentname}").Methods(http.MethodGet)
		} else {
			router.HandleFunc("/agent", lh.getAgenthandler).Methods(http.MethodGet)
		}

		lh.gorillaMuxLambda = gorillamux.New(router)

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
