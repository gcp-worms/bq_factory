locals {
  views = {
    for f in fileset("${var.views_dir}", "**/*.yaml") :
    trimsuffix(f, ".yaml") => yamldecode(file("${var.views_dir}/${f}"))
  }

  tables = {
    for f in fileset("${var.tables_dir}", "**/*.yaml") :
    trimsuffix(f, ".yaml") => yamldecode(file("${var.tables_dir}/${f}"))
  }

  output = {
    for dataset in distinct([for v in values(merge(local.views, local.tables)) : v.dataset]) :
    dataset => {
      "views" = {
        for k, v in local.views :
        v.view => {
          friendly_name       = v.view
          labels              = try(v.labels, null)
          query               = v.query
          use_legacy_sql      = try(v.use_legacy_sql, false)
          deletion_protection = try(v.deletion_protection, false)
        }
        if v.dataset == dataset
      },
      "tables" = {
        for k, v in local.tables :
        v.table => {
          friendly_name       = v.table
          labels              = try(v.labels, null)
          options             = try(v.options, null)
          partitioning        = try(v.partitioning, null)
          schema              = jsonencode(v.schema)
          use_legacy_sql      = try(v.use_legacy_sql, false)
          deletion_protection = try(v.deletion_protection, false)
        }
        if v.dataset == dataset
      }
    }
  }
}

module "bq" {
  source = "../modules/bigquery-dataset"

  for_each   = local.output
  project_id = var.project_id
  id         = each.key
  views      = try(each.value.views, null)
  tables     = try(each.value.tables, null)
}
