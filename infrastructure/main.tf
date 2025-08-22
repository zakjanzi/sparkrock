locals {
  # common name prefix/suffix for resources
  name_prefix = "${var.project}-${var.environment}"
  tags = {
    Project     = var.project
    Environment = var.environment
    ManagedBy   = "terraform"
    OwnerEmail  = var.owner_email
  }
}

# random suffix for unique resources
resource "random_pet" "suffix" {
  length = 2
}

output "name_prefix" {
  value = local.name_prefix
}

output "random_suffix" {
  value = random_pet.suffix.id
}

output "tags" {
  value = local.tags
}
