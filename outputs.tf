output "vpc_id" {
  description = "ID de la VPC creada"
  value = aws_vpc.main.id
}

output "subnet_ids" {
  description = "IDs de las subnets creadas (map nombre -> ID)"
  value = {for k, s in aws_subnet.publicas : k => s.id}
}

output "security_group_id" {
  description = "ID del security group web"
  value = aws_security_group.web.id
}

output "az_por_subnet" {
  description = "Zona de disponibilidad de cada subnet"
  value = {for k, s in aws_subnet.publicas : k => s.availability_zone }
}