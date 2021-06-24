package main

import (
	"encoding/json"
	"fmt"
	"github.com/gorilla/mux"
	"net/http"
	"net/url"
)

// getAgenthandler returns some data
func (h *LambdaHandler) getAgenthandler(w http.ResponseWriter, r *http.Request) {
	requiredOptions := []string{"agentname"}
	for _, v := range requiredOptions {
		if _, ok := mux.Vars(r)[v]; !ok {
			w.WriteHeader(http.StatusBadRequest)
			fmt.Fprint(w, "{\"error\":\"'"+v+"' is missing from query parameter\"}")
			return
		}
	}
	agentName, _ := url.QueryUnescape(mux.Vars(r)["agentname"])

	w.WriteHeader(http.StatusOK)
	jsonResponse, _ := json.Marshal(struct {
		AgentName string
	}{AgentName: agentName})
	fmt.Fprint(w, string(jsonResponse))
}
