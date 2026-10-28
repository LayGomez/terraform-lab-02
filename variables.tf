variable "aws_region" {
  type = string
  default = "eu-west-1"
}

variable "proyecto" {
  type = string
  default = "terraform-lab"
}

variable "vpc_cidr" {
  type = string
  default = "10.0.0.0/16"
}

# lista de configuraciones de subnets: objeto con nombre, CIDR y AZ
variable "subnets" {
  type = list(object({
    nombre = string
    cidr = string
    az = string
  }))
  
  default = [ 
    { nombre = "publica-1a", cidr = "10.0.1.0/24", az = "eu-west.1a"},
    { nombre = "publica-1b", cidr = "10.0.2.0/24", az = "eu-west-1b"} ]
}

# Lista de puertos para el security group (genera reglas dinámicas)

variable "puertos_web" {
  type = list(number)
  default = [80, 443]
}