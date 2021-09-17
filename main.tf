provider "aws" {
    region = var.region
}

# create vpc with cidr block
resource "aws_vpc" "sre_viktor_tf_vpc" {
    cidr_block = var.cidr_block
    instance_tenancy = "default"

    tags = {
      "Name" = "sre_viktor_tf_vpc"
    }
}

# create subnets 
resource "aws_subnet" "sre_viktor_tf_public" {
  vpc_id     = var.vpc_id
  cidr_block = "10.99.1.0/24"
  map_public_ip_on_launch = "true"
  availability_zone = "eu-west-1a"

  tags = {
    Name = "sre_viktor_tf_public"
  }
}

resource "aws_subnet" "sre_viktor_tf_private" {
  vpc_id     = var.vpc_id
  cidr_block = "10.99.2.0/24"
  availability_zone = "eu-west-1a"

  tags = {
    Name = "sre_viktor_tf_private"
  }
}
# create SG
resource "aws_security_group" "app_group" {
  name        = "sre_viktor_tf_sg_app"
  description = "SG for app"
  vpc_id = var.vpc_id
# Inbound rules
  ingress {
    from_port       = "80"
    to_port         = "80"
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]   
  }
  ingress {
    from_port       = "22"
    to_port         = "22"
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]  
  }
  ingress {
    from_port       = "3000"
    to_port         = "3000"
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]  
  }

# Outbound rules
  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
  tags = {
    "Name" = "sre_viktor_tf_sg_app"
  }
}

resource "aws_security_group" "db_sg"{
	name = "sre_viktor_tf_sg_db"
	description = "Allow traffic on port 27017 for mongoDB"
	vpc_id = var.vpc_id

	ingress {
		description = "27017 from app instance"
		from_port = 27017
		to_port = 27017
		protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
		
	}

	egress {
		description = "All traffic out"
		from_port = 0
		to_port = 0
		protocol = "-1"
		cidr_blocks = ["0.0.0.0/0"]

	}

	tags = {
		Name = "sre_viktor_tf_sg_db"
	}
}

resource "aws_internet_gateway" "sre_viktor_tf_ig" {
  vpc_id = var.vpc_id

  tags = {
    Name = "sre_viktor_tf_ig"
  }
}

resource "aws_route" "sre_viktor_route_ig" {
    route_table_id = var.route_table_id
    destination_cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.sre_viktor_tf_ig.id
}

resource "aws_route_table_association" "rta" {
  subnet_id      = var.subnet_id_public
  route_table_id = var.route_table_id
}

resource "aws_instance" "db_instance" {
    ami = var.db_ami
    subnet_id = var.subnet_id_private
    instance_type = "t2.micro"
    key_name = var.aws_key_name
    associate_public_ip_address = false
    vpc_security_group_ids = [var.db_sg]

    tags = {
        Name = "sre_viktor_tf_db"
    }
}

resource "aws_instance" "app_instance" {
    ami = var.app_ami
    instance_type = "t2.micro"
    associate_public_ip_address = true
    key_name = var.aws_key_name
    subnet_id = var.subnet_id_public
    vpc_security_group_ids = [var.app_sg]
    tags = {
        Name = "sre_viktor_tf_app"
    }
    connection {
      type = "ssh"
      user = "ubuntu"
      private_key = file(var.aws_key_path)
      host = aws_instance.app_instance.public_ip
	} 

	# export private ip of mongodb instance and start app
	provisioner "remote-exec"{
		inline = [
      "export DB_HOST=${aws_instance.db_instance.private_ip}:27017/posts",
      "echo \"export DB_HOST=${aws_instance.db_instance.private_ip}:27017/posts\" >> /home/ubuntu/.bashrc",
			"cd /home/ubuntu/app",
      "node seeds/seed.js",
      "nohup node app.js > /dev/null 2>&1 &"
		]
	}
}

# Application Load Balancer

/* resource "aws_lb" "sre-viktor-tf-lb" {
  name               = "sre-viktor-tf-lb"
  internal           = true
  load_balancer_type = "application"
  security_groups    = [var.app_sg]
  subnets            = [var.subnet_id_public] */

  /* enable_deletion_protection = true

  access_logs {
    bucket  = aws_s3_bucket.lb_logs.bucket
    prefix  = "test-lb"
    enabled = true
  }

  tags = {
    Environment = "production"
  } */
}


