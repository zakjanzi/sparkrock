variable "project" {
  description = "Sparkrock's SaaS Escalations & operations Engineer assignment."
  type        = string
  default     = "sparkrock-assignment"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "staging"
}

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "eu-central-1"
}

variable "owner_email" {
  description = "Owner email for tagging/alerts"
  type        = string
  default     = "zakjanzi@duck.com"
}
