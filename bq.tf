locals {
  # names = {
  #   for file in fileset("files", "*") : split("_", trimsuffix(file, ".sql"))[1] => {
  #     table_id  = split("_", trimsuffix(file, ".sql"))[0]
  #     file_name = file
  #   }...
  # }

  # dataset_views = { for dataset_name in keys(local.names) : (dataset_name) => {
  #   for views in local.names[dataset_name] : views["table_id"] => {
  #     table_id  = views["table_id"]
  #     file_name = views["file_name"]
  #   }
  #   }
  # }
  views = {
    for f in fileset("${var.data_dir}", "**/*.yaml") :
    trimsuffix(f, ".yaml") => yamldecode(file("${var.data_dir}/${f}"))
  }

  output = {
    for dataset in distinct([for v in values(local.views) : v.dataset]) :
    dataset => {
      for k, v in local.views :
      v.view => {
        friendly_name       = v.view
        labels              = {}
        query               = v.query
        use_legacy_sql      = false
        deletion_protection = false
      }
      if v.dataset == dataset
    }
  }
}

# module "bq" {
#   source  = "terraform-google-modules/bigquery/google"
#   version = "~> 4.5"

#   project_id = "bq_factory"

#   for_each   = local.views
#   dataset_id = try(each.value.dataset, null)
#   views = [
#     {
#       view_id        = try(each.value.view, null)
#       query          = "SELECT CURRENT_DATE()"
#       use_legacy_sql = false
#       labels = {
#         a = "b"
#       }
#     }
#   ]
# }

module "bq" {
  source = "github.com/GoogleCloudPlatform/cloud-foundation-fabric/modules/bigquery-dataset"

  for_each   = local.output
  project_id = module.project_factory.project_id
  id         = each.key
  views       = each.value
}





# distinct_datasets = distinct(flatten(values(local.views)))

# view_module = {
#   for k, v in local.views :
#     v.dataset => {
#       view_id = v.view
#       query   = v.query
#     }
# }

# view_module1 = {
#   for k, v in local.views :
#     v.dataset => {
#       for i in v :
#         i.view => {
#         query   = i.query
#       }
#     }
# }

# yes = {
#   for f in fileset("${var.data_dir}", "**/*.yaml") :
#   yamldecode(file("${var.data_dir}/${f}"))["project_id"] => {
#     view_id    = yamldecode(file("${var.data_dir}/${f}"))["view"]
#     dataset_id = yamldecode(file("${var.data_dir}/${f}"))["dataset"]
#   }...
# }

# list_test = [
#   for f in fileset("${var.data_dir}", "**/*.yaml") : yamldecode(file("${var.data_dir}/${f}"))
# ]

# lt = distinct(flatten([
#   for t in local.list_test : [
#     for k,v in t :
#     {
#       project = k

#     }
#   ]
# ]))

# all_yes = concat(
#   local.yes
# )

# yes2 = {
#   for f in fileset("${var.data_dir}", "**/*.yaml") :
#   yamldecode(file("${var.data_dir}/${f}"))["project_id"] => tolist([
#     for a,b in
#   ]){
#     view_id = yamldecode(file("${var.data_dir}/${f}"))["view"]
#     project_id = yamldecode(file("${var.data_dir}/${f}"))["dataset"]
#   }...
# }

# yes2 = flatten([
#   for y in local.yes : [
#     for v in y[0] : {
#       dataset = y.dataset
#       view_id = v
#     }
#   ]
# ])

# yes3 = flatten([
#   for y in local.yes : [
#     for v in y[0] : {
#       dataset = v["dataset_id"]
#       view    = v["view_id"]
#     }
#   ]
# ])

# yes4 = flatten([
#   for y in local.yes : [
#     dataset =
#   ]
# ])


# default_roles = [
#   {
#     role    = "roles/admin"
#     members = ["user:user@example.com"]
#   },
#   {
#     role    = "roles/viewer"
#     members = ["user:user2@example.com"]
#   }
# ]


# testi = {
#   for i in keys(local.yes) : i => {
#     view_id = local.view_id[i].
#   }
# }

# yamldecode(file("${var.data_dir}/${f}"))...



