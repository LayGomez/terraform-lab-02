# ----------- Locals-------------------------------

locals {
  tags_comunes = {
    project = var.proyecto
    ManagedBy = "Terraform"
  }
}

# ------------------ VPC --------------------------------
resource "aws_vpc" "main" {
  cidr_block =  var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support = true

  tags = merge(local.tags_comunes, {
    Name = "${var.proyecto}-vpc"
  })
}

# -------------------Internet Gateway -------------------------------------------
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id # referencia cruzada: depende de la VPC

  tags = merge(local.tags_comunes, {
    Name = "${var.proyecto}-igw"
  })
}

# ---------------------- Subnets con for_each ----------------------------------
# Convertimos la lista en un map para poder usar for_each
resource "aws_subnet" "publicas" {
  for_each = { for s in var.subnets : s.nombre => s}

  vpc_id = aws_vpc.main.id # referencia cruzada
  cidr_block =  each.value.cidr
  availability_zone = each.value.az
  map_public_ip_on_launch = true

  tags = merge(local.tags_comunes,{
    Name = "${var.proyecto}-${each.key}"
  })
}

# ------------------ Security goups con dynamic -----------------------------------
resource "aws_security_group" "web" {
  name = "${var.proyecto}-sg-web"
  description = "Trafico web: puertos ${join(",", var.puertos_web)}"
  vpc_id = aws_vpc.main.id # referencia cruzada

  # Genera una regla ingress por cada puerto de la variable
  dynamic "ingress" {
    for_each = var.puertos_web
    content {
      description = "Puerto ${ingress.value}"
      from_port = ingress.value
      to_port = ingress.value
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.tags_comunes, {
    Name = "${var.proyecto}-sg-web"
  })
}