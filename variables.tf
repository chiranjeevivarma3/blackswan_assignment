
variable "mysql_instance_type" {
  description = "RDS mysql instance type"
  type        = string
  default     = "db.t2.micro"
}
variable "allocated_storage" {
  description = "RDS mysql allocation size"
  type        = number
  default     = 30
}
variable "database_name" {
  description = "RDS Mysql DB name to create"
  type        = string
  default     = "chiru"
}
variable "database_username" {
  description = "Username for the master DB user"
  type        = string
  default     = "admin"
}
variable "database_password" {
  description = "Password for the master DB user. Note that this may show up in logs, and it will be stored in the state file"
  type        = string
  default     = "chiru123demo"
}
variable "webserver_instance_type" {
  description = "ec2 instance type"
  type        = string
  default     = "t2.micro"
}
variable "root_volume_size" {
  description = "Volume size of root volumen of Web Server"
  type        = number
  default     = 20
}
variable "subnets_cidr" {
  description = "Volume size of root volumen of Web Server"
  type        = list
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}
variable "azs" {
  description = "availability zones for VPC"
	type = list
	default = ["us-east-1a", "us-east-1b"]
}