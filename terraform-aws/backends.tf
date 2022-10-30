terraform {
  cloud {
    organization = "booo"

    workspaces {
      name = "mtc-dev"
    }
  }
}