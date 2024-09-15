terraform {
  backend "s3" {
    bucket  = "threat-modeling-tool--tf"
    key     = "state"
    region  = "us-east-1"
    encrypt = true
  }
}
