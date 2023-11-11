terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}
 
# TODO: Designate a cloud provider, region, and credentials
# Set up aws connection  in local
# 1. run 'aws configure'
# 2. Fill: AWS Access Key ID: <>
#          AWS Secret Access Key: <>
#          Default region name : us-east-1
# So we can use shared_credentials_files with the directory as bellow (MacOS)
provider "aws" {
  shared_credentials_files = ["~/.aws/credentials"]

}

# TODO: provision 4 AWS t2.micro EC2 instances named Udacity T2
resource "aws_instance" "Udacity-T2" {
    ami           = "ami-05c13eab67c5d8861"
    instance_type = "t2.micro"
    count         = 4
}

# TODO: provision 2 m4.large EC2 instances named Udacity M4
resource "aws_instance" "Udacity-M4" {
    ami           = "ami-05c13eab67c5d8861"
    instance_type = "m4.large"
    count         = 2
}

