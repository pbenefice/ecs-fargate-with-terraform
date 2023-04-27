variable "env" {
  description = "The env"
  type        = string
}
variable "project_prefix" {
  description = "The prefix to use for naming resources, used in conjonction with env"
  type        = string
  default     = "ec2_ssm"
}

variable "vpc_id" {
  type        = string
  description = "The id of the VPC to use"
}
variable "private_subnets" {
  type        = list(string)
  description = "The list of ids of the private_subnets to use"
}
