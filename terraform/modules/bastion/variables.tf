variable "env" {
  description = "The env"
  type        = string
}
variable "name" {
  description = "The name for the ami, used as prefix in conjonction with env"
  type        = string
  default     = "ec2_ssm"
}

variable "vpc_id" {
  description = "The ID of the vpc to create the instance in"
  type        = string
}
variable "subnet_id" {
  description = "The CIDR to include in the security group attached to the created instances"
  type        = string
}
variable "allowed_cidrs" {
  description = "The CIDR to include in the security group attached to the created instances"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "instance_type" {
  description = "The instance type to use"
  type        = string
  default     = "t3.micro"
}
