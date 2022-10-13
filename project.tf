module "project_factory" {
  source  = "terraform-google-modules/project-factory/google"
  version = "11.3.1"

  name            = var.project_name
  org_id          = var.organization_account
  billing_account = var.billing_account
  activate_apis   = var.activated_apis
}
