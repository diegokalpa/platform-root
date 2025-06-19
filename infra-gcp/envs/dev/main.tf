module "network" {
  source     = "../../modules/network"
  env        = "dev"
  region     = "us-central1"
  cidr_block = "10.70.0.0/17"
}
