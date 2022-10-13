terraform {
  backend "gcs" {
        bucket = "worms-tfstate-0890"
        prefix = "bq_factory"
  }
}
