# TODO: Designate a cloud provider, region, and credentials
provider "aws" {
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  region  = var.aws_region
}

# TODO: provision 4 AWS t2.micro EC2 instances named Udacity T2
resource "aws_instance" "udacity-t2" {
  count = "4"
  ami = "ami-0323c3dd2da7fb37d"
  instance_type = "t2.micro"
  subnet_id= var.aws_subnet_id
  tags= {
    Name = "Udacity T2"
  }
}

# TODO: provision 2 m4.large EC2 instances named Udacity M4
# Comment below to delete the 2 m4.large instances
# resource "aws_instance" "udacity-m4" {
#   count = "2"
#   ami = "ami-0323c3dd2da7fb37d"
#   instance_type = "m4.large"
#   subnet_id = var.aws_subnet_id
#   tags= {
#     Name = "Udacity M4"
#   }
# }