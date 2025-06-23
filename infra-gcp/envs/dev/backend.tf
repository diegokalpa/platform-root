terraform {
  cloud {
    organization = "dievops"
    workspaces {
      name = "dievops-dev"
    }
  }
}
