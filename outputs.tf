output "VPC-name" {
  value = aws_vpc.myvpc.id

}

output "VPC-CIDR" {
  value = aws_vpc.myvpc.cidr_block

}

output "az-zone1" {
  value = data.aws_availability_zones.available.names

}

output "private-route-tables" {
  value = aws_route_table.my_route_tbls[0].id

}

// getting webservers public ip 
output "webserver1-ip" {
  value = aws_instance.webservers[0].public_ip
}

output "webserver2-ip" {
  value = aws_instance.webservers[1].public_ip

}