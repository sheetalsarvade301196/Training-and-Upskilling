variable "region" {
  description = "AWS region (optional if set in AWS CLI)"
  type        = string
  default     = ""
}

variable "instance_type" {
  description = "EC2 instance type (t2.micro is Free Tier eligible in many regions)"
  type        = string
  default     = "t2.micro"
}

variable "key_name" {
  description = "Name of an existing EC2 key pair in the region. Create one if you don't have (see instructions below)."
  type        = string
  default     = "mykey"
}

variable "ssh_cidr" {
  description = "CIDR block allowed to SSH. Set to your IP for security, or 0.0.0.0/0 to allow all (not recommended)."
  type        = string
  default     = "0.0.0.0/0"
}

variable "instance_name" {
  description = "Tag name for the instance"
  type        = string
  default     = "tf-free-tier-ec2"
}
