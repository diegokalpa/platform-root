module "network" {
  source     = "git::https://github.com/diegokalpa/platform-root.git//infra-gcp/modules/network"
  env        = "dev"
  region     = "us-central1"
  cidr_block = "10.70.0.0/17"
}
