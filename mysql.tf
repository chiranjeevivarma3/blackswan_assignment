# adding subets to RDS
resource "aws_db_subnet_group" "rds-private-subnet" {
  name = "rds-private-subnet-group"
  subnet_ids = aws_subnet.private.*.id
}
# creates security group to RDS
resource "aws_security_group" "rds-sg" {
  name   = "my-rds-sg"
  vpc_id = aws_vpc.demo.id
}
resource "aws_security_group_rule" "mysql_inbound_access" {
  from_port         = 3306
  protocol          = "tcp"
  security_group_id = aws_security_group.rds-sg.id
  to_port           = 3306
  type              = "ingress"
  cidr_blocks       = ["0.0.0.0/0"]
  depends_on = [aws_security_group.rds-sg]
}
# creates RDS mysql database
resource "aws_db_instance" "mysql" {
  allocated_storage    = var.allocated_storage
  engine               = "mysql"
  engine_version       = "8.0.23"
  instance_class       = var.mysql_instance_type
  name                 = var.database_name
  username             = var.database_username
  password             = var.database_password
  db_subnet_group_name   = aws_db_subnet_group.rds-private-subnet.name
  vpc_security_group_ids = [aws_security_group.rds-sg.id]
  skip_final_snapshot  = true
}