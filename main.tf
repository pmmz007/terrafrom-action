// VPC

resource "aws_vpc" "myvpc" {
  cidr_block = var.cidr_block
  tags       = local.common_tags
}


// Subnet Availability Zone 

data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_subnet" "public-subnets" {
  count                   = var.subnet_count
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  vpc_id                  = aws_vpc.myvpc.id
  map_public_ip_on_launch = true
  cidr_block              = var.cidr_blocks[count.index]
  tags = {
    Name = "${var.subnet_name}-${count.index}"
  }
}

// Internet Gateway

resource "aws_internet_gateway" "myigw" {
  vpc_id = aws_vpc.myvpc.id
  tags = {
    Name = var.myigw
  }
}

// public route tables with count index
resource "aws_route_table" "my_route_tbls" {
  count  = var.route_tbl_count
  vpc_id = aws_vpc.myvpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.myigw.id
  }
  tags = {
    Name = "${var.pr-rtbs}-${count.index}"

  }
}

// public route table assication
resource "aws_route_table_association" "public-rtbs" {
  count          = var.route_tbl_count
  subnet_id      = aws_subnet.public-subnets[count.index].id
  route_table_id = aws_route_table.my_route_tbls[count.index].id
}

// security group for webservers
resource "aws_security_group" "webserver_nsg" {
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic"
  vpc_id      = aws_vpc.myvpc.id

  ingress {
    description = "TLS from VPC"
    from_port   = 0
    to_port     = "22"
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.myvpc.cidr_block]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_ssh"
  }
}
// instances

resource "aws_instance" "webservers" {
  count                  = 2
  ami                    = "ami-0eeadc4ab092fef70"
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.public-subnets[count.index].id
  vpc_security_group_ids = [aws_security_group.webserver_nsg.id]

}



