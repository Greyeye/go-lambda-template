data "local_file" "env_variables" {
  filename = "../../config/env_${var.environment}.json"
}

locals {
  # read JSON from the env value and add to the env_variables.
  env_variables = merge ({
    name = var.project_name
    terraform = true
  }, {for k, v in jsondecode(data.local_file.env_variables.content): k => v})
}