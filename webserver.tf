
# creates ec2 instaces (ngnix webserver)
resource "aws_instance" "webserver" {
  ami           = "ami-087c17d1fe0178315"
  instance_type = var.webserver_instance_type
  subnet_id     = aws_subnet.private[0].id
  user_data     = file("install_nginx.sh")
  iam_instance_profile = aws_iam_instance_profile.ec2ssm_profile.name
  security_groups = [aws_security_group.web-node.id]
  root_block_device {
    volume_size           = var.root_volume_size
    delete_on_termination = true
  }
  tags = {
    Name = "demo-webserver"
  }
}
# creates security group to allow http & https
resource "aws_security_group" "web-node" {
  name = "web-node"
  description = "Web Security Group for both http & https"
  vpc_id      = aws_vpc.demo.id
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }    
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}