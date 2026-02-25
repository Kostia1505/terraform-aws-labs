terraform {
  backend "s3" {
    bucket         = "it-step-lab-terraform-state-holovenko"
    key            = "dev/domain1/terraform.tfstate"
    region         = "eu-north-1"
    encrypt        = true
  }
}
