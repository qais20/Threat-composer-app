terraform {
  backend "s3" {
    bucket         = "threat-modelling-bucket"  
    key            = "terraform/statefile/terraform.tfstate"  
    region         = "eu-west-2"  
  }
}
