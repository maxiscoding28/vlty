# import "controlgroup"

# control_group = func() {
#   numAuthzs = 0
#   for controlgroup.authorizations as authz {
#     if "manager-group" in authz.groups.by_name {
#       numAuthzs = numAuthzs + 1
#     }
#   }
#   if numAuthzs >= 2 {
#     return true
#   }
#   return false
# }

# main = rule {
#   control_group()
# }