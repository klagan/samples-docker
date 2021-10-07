locals {
  location = "uksouth"

  tags = {
    client          = "kam"
    environment     = "demo"
    "business unit" = "rnd"
  }
}

resource "random_pet" "prefix" {}
