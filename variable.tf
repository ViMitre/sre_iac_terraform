variable "aws_key_name" {
    default = "sre_key"
}

variable "aws_key_path" {
    default = "~/.ssh/sre_key.pem"
}

variable "region" {
    default = "eu-west-1"
}

variable "app_ami" {
    default = "ami-00e8ddf087865b27f"
}

variable "db_ami" {
    default = "ami-090c2e11c335f901c"
}

variable "cidr_block" {
    default = "10.99.0.0/16"
}

variable "vpc_id" {
    default = "vpc-09ea469c8ddcf6f04"  
}

variable "subnet_id_public" {
    default = "subnet-05bd9f33f041f4ce5"
}

variable "subnet_id_private" {
    default = "subnet-0792fcea85dbac7d7"
}

variable "route_table_id" {
    default = "rtb-05ca2c72c87440b0b"
}

variable "ig_id" {
    default = "igw-0eb4682fed8b54225"
}

variable "app_sg" {
    default = "sg-098b74bc6a782e85a"
}

variable "db_sg" {
    default = "sg-0aada62f45642ac19"
}

variable "db_private_ip" {
    default = "10.99.2.124"
}