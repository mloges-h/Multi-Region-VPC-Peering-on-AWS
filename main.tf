provider "aws" {
  region = "ap-south-1"   # Mumbai
  alias  = "mumbai"
}

provider "aws" {
  region = "ap-southeast-1"   # Singapore
  alias  = "singapore"
}

# -----------------------
# VPC 1 (Mumbai)
# -----------------------
resource "aws_vpc" "mumbai_vpc" {
  provider   = aws.mumbai
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "mumbai-vpc"
  }
}

resource "aws_subnet" "mumbai_public_subnet" {
  provider          = aws.mumbai
  vpc_id            = aws_vpc.mumbai_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "ap-south-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "mumbai-public-subnet"
  }
}

resource "aws_internet_gateway" "mumbai_igw" {
  provider = aws.mumbai
  vpc_id   = aws_vpc.mumbai_vpc.id
  tags = {
    Name = "mumbai-igw"
  }
}

resource "aws_route_table" "mumbai_rt" {
  provider = aws.mumbai
  vpc_id   = aws_vpc.mumbai_vpc.id
  tags = {
    Name = "mumbai-rt"
  }
}

resource "aws_route_table_association" "mumbai_assoc" {
  provider       = aws.mumbai
  subnet_id      = aws_subnet.mumbai_public_subnet.id
  route_table_id = aws_route_table.mumbai_rt.id
}

resource "aws_route" "mumbai_igw_route" {
  provider               = aws.mumbai
  route_table_id         = aws_route_table.mumbai_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.mumbai_igw.id
}

# Security Group for EC2 (allow SSH + ICMP)
resource "aws_security_group" "mumbai_sg" {
  provider = aws.mumbai
  vpc_id   = aws_vpc.mumbai_vpc.id
  name     = "mumbai-sg"

  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow ICMP"
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# EC2 in Mumbai
resource "aws_instance" "mumbai_ec2" {
  provider      = aws.mumbai
  ami           = "ami-02d26659fd82cf299" # Amazon Linux 2 (update if needed)
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.mumbai_public_subnet.id
  vpc_security_group_ids = [aws_security_group.mumbai_sg.id]
  key_name      = "lokiss"   # Replace with your key

  tags = {
    Name = "mumbai-ec2"
  }
}

# -----------------------
# VPC 2 (Singapore)
# -----------------------
resource "aws_vpc" "singapore_vpc" {
  provider   = aws.singapore
  cidr_block = "10.1.0.0/16"
  tags = {
    Name = "singapore-vpc"
  }
}

resource "aws_subnet" "singapore_private_subnet" {
  provider          = aws.singapore
  vpc_id            = aws_vpc.singapore_vpc.id
  cidr_block        = "10.1.1.0/24"
  availability_zone = "ap-southeast-1a"
  tags = {
    Name = "singapore-private-subnet"
  }
}

# Security Group for EC2 (allow ICMP + SSH from Mumbai VPC)
resource "aws_security_group" "singapore_sg" {
  provider = aws.singapore
  vpc_id   = aws_vpc.singapore_vpc.id
  name     = "singapore-sg"

  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"] # Mumbai VPC
  }

  ingress {
    description = "Allow ICMP"
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["10.0.0.0/16"] # Mumbai VPC
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# EC2 in Singapore
resource "aws_instance" "singapore_ec2" {
  provider      = aws.singapore
  ami           = "ami-0a2fc2446ff3412c3" # Amazon Linux 2 (update if needed)
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.singapore_private_subnet.id
  vpc_security_group_ids = [aws_security_group.singapore_sg.id]
  key_name      = "loganssinagpore"   # Replace with your key

  tags = {
    Name = "singapore-ec2"
  }
}

# -----------------------
# VPC Peering
# -----------------------
resource "aws_vpc_peering_connection" "peering" {
  provider      = aws.mumbai
  vpc_id        = aws_vpc.mumbai_vpc.id
  peer_vpc_id   = aws_vpc.singapore_vpc.id
  peer_region   = "ap-southeast-1"
  auto_accept   = false

  tags = {
    Name = "mumbai-singapore-peering"
  }
}

resource "aws_vpc_peering_connection_accepter" "peering_accepter" {
  provider                  = aws.singapore
  vpc_peering_connection_id = aws_vpc_peering_connection.peering.id
  auto_accept               = true

  tags = {
    Name = "peering-accepter"
  }
}

# Add Routes
resource "aws_route" "mumbai_to_singapore" {
  provider               = aws.mumbai
  route_table_id         = aws_route_table.mumbai_rt.id
  destination_cidr_block = "10.1.0.0/16"
  vpc_peering_connection_id = aws_vpc_peering_connection.peering.id
}

resource "aws_route_table" "singapore_rt" {
  provider = aws.singapore
  vpc_id   = aws_vpc.singapore_vpc.id
  tags = {
    Name = "singapore-rt"
  }
}

resource "aws_route_table_association" "singapore_assoc" {
  provider       = aws.singapore
  subnet_id      = aws_subnet.singapore_private_subnet.id
  route_table_id = aws_route_table.singapore_rt.id
}

resource "aws_route" "singapore_to_mumbai" {
  provider               = aws.singapore
  route_table_id         = aws_route_table.singapore_rt.id
  destination_cidr_block = "10.0.0.0/16"
  vpc_peering_connection_id = aws_vpc_peering_connection.peering.id
}

root@ip-172-31-37-4:~# 
