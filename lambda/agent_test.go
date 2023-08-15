package main

import (
	"encoding/json"
	"github.com/Greyeye/go-lambda-template/internal/awsclient"
	ginadapter "github.com/awslabs/aws-lambda-go-api-proxy/gin"
	"github.com/gin-gonic/gin"
	"github.com/stretchr/testify/assert"
	"net/http"
	"net/http/httptest"
	"net/url"
	"testing"
)

func TestLambdaHandler_getAgenthandler(t *testing.T) {
	type fields struct {
		awsClient   *awsclient.Clients
		ginLambdaV2 *ginadapter.GinLambdaV2
	}
	type args struct {
		u      string
		method string
	}
	tests := []struct {
		name     string
		fields   fields
		args     args
		expected string
	}{
		{
			name: "normal ok request",
			fields: fields{
				awsClient:   &awsclient.Clients{},
				ginLambdaV2: &ginadapter.GinLambdaV2{},
			},
			args: args{
				u:      "http://localhost/agent?agentname=test",
				method: "GET",
			},
			expected: "test",
		},
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			h := &LambdaHandler{
				awsClient:   tt.fields.awsClient,
				ginLambdaV2: tt.fields.ginLambdaV2,
			}
			c, w := MockGin(tt.args.u, tt.args.method)
			h.getAgentHandler(c)
			var got map[string]interface{}
			err := json.Unmarshal(w.Body.Bytes(), &got)
			assert.Equal(t, tt.expected, got["AgentName"])
			assert.Nil(t, err)
		})
	}
}

func mockURLParser(mockURL string) *url.URL {
	u, err := url.Parse(mockURL)
	if err != nil {
		return nil
	}
	return u
}

func MockGin(mockURL, method string) (*gin.Context, *httptest.ResponseRecorder) {
	w := httptest.NewRecorder()
	gin.SetMode(gin.TestMode)
	ctx, _ := gin.CreateTestContext(w)
	ctx.Request = &http.Request{
		Method: method,
		Header: make(http.Header),
		URL:    mockURLParser(mockURL),
	}
	ctx.Request.Header.Set("Content-Type", "application/json")
	return ctx, w
}
