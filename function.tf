# locals {
#   test = {
#     for f in fileset("${var.data_dir}", "**/*.yaml") :
#     trimsuffix(f, ".yaml") => yamldecode(file("${var.data_dir}/${f}"))
#   }
# }
