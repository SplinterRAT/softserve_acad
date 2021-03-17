provider "aws" {
    region = var.region
    secret_key = var.secret_k
    access_key = var.access_k
}
provider github {
    token = var.gittocken
    owner = "SplinterRAT"
}