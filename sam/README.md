# SAM local test

This is to help run the SAM local test.
template.yml is to help run the local test (assuming the lambda you're building is for API Gateway)

In order to run, build the binary named `bootstrap` under `./sam` folder and run sam command

```bash
sam local start-api -n ../config/env_local.json 
```

you must have the config file, but it must be wrapped with "Parameters", 
template env_local.json file should be good enough to start the test.

```json
{
  "Parameters": {
    "GIN_MODE": "debug",
    "someConfig": "some env value"
  }
}
```

## Prerequisites

1. Docker
2. AWS SAM CLI (https://docs.aws.amazon.com/serverless-application-model/latest/developerguide/install-sam-cli.html)