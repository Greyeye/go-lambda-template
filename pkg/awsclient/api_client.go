// Package awsclient provides helper libraries to setup aws services and connections.
package awsclient

import (
	"context"
)

// Clients help defines AWS Services under a single struct
type Clients struct {
	//Dynamodbclient dynamoDBClient.ApiClientIface
}

// New is a function to help set up AWS Clients
func New(ctx context.Context) (*Clients, error) {
	//cfg, err := config.LoadDefaultConfig(ctx)
	//if err != nil {
	//	return nil, err
	//}
	// init all client connections
	//dynamodbclient, err := dynamoDBClient.New(ctx, &cfg)
	//if err != nil {
	//	log.Printf("unable to load SDK config, %v", err)
	//	return nil, err
	//}
	//
	//return &Clients{
	//	Dynamodbclient: dynamodbclient,
	//}, nil
	return &Clients{}, nil
}
