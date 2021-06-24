data "local_file" "env_variables" {
  filename = "../../config/env_${var.environment}.json"
}

locals {
  env_variables = {
    name = var.project_name,
    terraform = true
    someConfig = jsondecode(data.local_file.env_variables.content)["someConfig"]
  }
}