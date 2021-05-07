terraform {
  required_version = ">= 0.12.31"

  required_providers {
    lacework = {
      source  = "lacework/lacework"
      version = "~> 0.3"
    }
  }
}
