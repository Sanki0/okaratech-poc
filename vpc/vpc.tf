resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "${var.prefix_resource_name}-${var.app_name}"
  }
}


# Crear subredes públicas
resource "aws_subnet" "public_a" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidrs[0]
  availability_zone       = var.availability_zones[0]
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.prefix_resource_name}-${var.app_name}-public-subnet-a"
  }
}

resource "aws_subnet" "public_b" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidrs[1]
  availability_zone       = var.availability_zones[1]
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.prefix_resource_name}-${var.app_name}-public-subnet-b"
  }
}

# Crear subredes privadas
resource "aws_subnet" "private_a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_cidrs[0]
  availability_zone = var.availability_zones[0]
  map_public_ip_on_launch = false
  tags = {
    Name = "${var.prefix_resource_name}-${var.app_name}-private-subnet-a"
  }
}

resource "aws_subnet" "private_b" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_cidrs[1]
  availability_zone = var.availability_zones[1]
  map_public_ip_on_launch = false
  tags = {
    Name = "${var.prefix_resource_name}-${var.app_name}-private-subnet-b"
  }
}

# Crear un Internet Gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "${var.prefix_resource_name}-${var.app_name}-ig"
  }
}

# Crear tabla de rutas para subredes públicas
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "${var.prefix_resource_name}-${var.app_name}-public-route-table"
  }
}

# Crear ruta a Internet para tabla pública
resource "aws_route" "public_route" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.main.id
}

# Asociar tabla de rutas pública con subredes públicas
resource "aws_route_table_association" "public_a" {
  subnet_id      = aws_subnet.public_a.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_b" {
  subnet_id      = aws_subnet.public_b.id
  route_table_id = aws_route_table.public.id
}

# Crear tablas de rutas privadas (una para ambas subredes privadas, se puede dividir si es necesario)
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "${var.prefix_resource_name}-${var.app_name}-private-route-table"
  }
}

resource "aws_route" "private_route" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat.id
}

# Asociar tabla de rutas privada con subredes privadas
resource "aws_route_table_association" "private_a" {
  subnet_id      = aws_subnet.private_a.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private_b" {
  subnet_id      = aws_subnet.private_b.id
  route_table_id = aws_route_table.private.id
}


###
resource "aws_vpc_endpoint" "s3_endpoint" {
  vpc_id = aws_vpc.main.id
  service_name = "com.amazonaws.us-east-1.s3"
  route_table_ids = [aws_route_table.private.id]
}

resource "aws_vpc_endpoint" "sagemaker_api_endpoint" {
  vpc_id = aws_vpc.main.id
  service_name = "com.amazonaws.us-east-1.sagemaker.api"
  subnet_ids = [ aws_subnet.private_a.id, aws_subnet.private_b.id ]
  vpc_endpoint_type = "Interface"
}

resource "aws_vpc_endpoint" "sagemaker_runtime_endpoint" {
  vpc_id = aws_vpc.main.id
  service_name = "com.amazonaws.us-east-1.sagemaker.runtime"
  subnet_ids = [ aws_subnet.private_a.id, aws_subnet.private_b.id ]
  vpc_endpoint_type = "Interface"
}

resource "aws_vpc_endpoint" "sts_endpoint" {
  vpc_id = aws_vpc.main.id
  service_name = "com.amazonaws.us-east-1.sts"
  subnet_ids = [ aws_subnet.private_a.id, aws_subnet.private_b.id ]
  vpc_endpoint_type = "Interface"
}

resource "aws_vpc_endpoint" "logs_endpoint" {
  vpc_id = aws_vpc.main.id
  service_name = "com.amazonaws.us-east-1.logs"
  subnet_ids = [ aws_subnet.private_a.id, aws_subnet.private_b.id ]
  vpc_endpoint_type = "Interface"
}


resource "aws_eip" "nat" {
  tags = {
    Name = "nat-eip"
  }
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public_a.id # Ubica el NAT Gateway en una subred pública
  tags = {
    Name = "nat-gateway"
  }
}

# resource "aws_route" "private_route" {
#   route_table_id         = aws_route_table.private.id
#   destination_cidr_block = "0.0.0.0/0"
#   nat_gateway_id         = aws_nat_gateway.nat.id
# }