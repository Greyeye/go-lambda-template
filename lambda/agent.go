package main

import (
	"github.com/gin-gonic/gin"
	"net/http"
)

// getAgentHandler returns some data
func (l *LambdaHandler) getAgentHandler(c *gin.Context) {

	agentName := c.Query("agentname")
	// do something like call Database and get agent details, or perform transform data etc...
	/*
		e.g.
			data, err := callMYSQL(agentName)
		    if err != nil {
				c.JSON(http.StatusInternalServerError gin.H{
					"message": "no data",
				}
				return
			}
		This sample will return {"message": "no data"} when callMYSQL fail.
	*/
	jsonResponse := struct {
		AgentName string
	}{AgentName: agentName}

	c.JSON(http.StatusOK, jsonResponse)
}
