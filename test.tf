locals {
  default_roles = [
    {
      role    = "roles/admin"
      members = ["user:user@example.com"]
    },
    {
      role    = "roles/viewer"
      members = ["user:user2@example.com"]
    }
  ]

  default_roles2 = [
    {
      role    = "roles/admin"
      members = ["user:user3@example.com"]
    },
    {
      role    = "roles/viewer"
      members = ["user:user@example.com"]
    }
  ]

  all_roles = concat(
    local.default_roles,
    local.default_roles2,
  )

  # First we'll project the inputs so that we have one
  # role/member pair per element.
  flat_roles = flatten([
    for r in local.all_roles : [
      for m in r.members : {
        role   = r.role
        member = m
      }
    ]
  ])

  # Then we can use that flattened list to produce a map
  # grouped by unique role key.
  merged_roles = {
    for k, v in local.all_roles : k => v...
  }

  # Finally, if the list-of-objects representation was
  # important then we can recover it by projecting that
  # merged_roles map back into the list shape.
  merged_roles_list = tolist([
    for role, members in local.merged_roles : {
      role    = role
      members = tolist(members)
    }
  ])
}
