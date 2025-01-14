terraform {
  required_version = ">= 1.3.0"

  required_providers {
    aws    = ">= 5.0"
    random = ">= 2.1"
    time   = "~> 0.6"
    lacework = {
      source  = "lacework/lacework"
      version = "~> 2.0"
    }
  }
}
