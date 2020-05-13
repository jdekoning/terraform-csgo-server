provider "aws" {
  region = "eu-west-1"
}

terraform {
  backend "s3" {
    bucket = "csgo-republic"
    key    = "terraform-csgo"
    region = "eu-west-1"
  }
}