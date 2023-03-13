provider "aws" {
  region = "ap-northeast-2"
}

terraform {
  required_version = ">= 1.0.0"
  required_providers {
    aws = ">= 3.58.0"
  }
}
