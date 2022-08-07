terraform {
  backend "s3" {
    bucket         = "pokimane-terraform-state"
    dynamodb_table = "pokimane-terraform-lock"
    key            = "minecraft-server/terraform.tfstate"
    region         = "us-west-2"
    encrypt        = true
  }
}
