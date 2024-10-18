output "vpc_id" {
  value = aws_vpc.app-vpc.id
}

output "subnet_a_id" {
  value = aws_subnet.tm-subnet1.id
}

output "subnet_b_id" {
  value = aws_subnet.tm-subnet2.id
}

output "security_group_id" {
  value = aws_security_group.tm-sg.id
}
