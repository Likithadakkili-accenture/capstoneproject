terraform {
  required_version = ">= 1.2.0"
}

resource "terraform_data" "project12" {
  input = "Terraform CI Plan Validation"
}
