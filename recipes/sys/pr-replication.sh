##### PRE-REQS #####
# - v and pr clusters are running
####################

# TODO, get exact permissions you need

# Can enable pr and manage
v0 policy write pr-admin - <<EOF
path "*" {
capabilities = [ "create", "read", "update", "delete", "list", "sudo", "patch" ]
}
EOF

v0 auth enable userpass

v0 write auth/userpass/users/pr-admin password="1234" token_policies=pr-admin

v0 write -f sys/replication/performance/primary/enable

PR_SECONDARY_TOKEN=$(v0 write sys/replication/performance/primary/secondary-token id=pr-secondary -format=json | jq -r '.wrap_info.token')

### Not Scripted ###
# - Sign in to pr
####################

pr0 write sys/replication/performance/secondary/enable token=$PR_SECONDARY_TOKEN 

# Test auth method works on PR
pr0 login -method=userpass username=pr-admin password=1234

# Read replication
v0 read sys/replication/performance/status -format=json | jq
pr0 read sys/replication/performance/status -format=json | jq

# Does not replicate to primary
pr0 auth enable -path=gdpr_userpass -local userpass

### Not Scripted ###
# - Sign in to v
####################

# Should be empty
v0 auth list | grep gdpr_userpass

# Paths filter with deny from the primary
v0 write sys/replication/performance/primary/paths-filter/pr-secondary \
    mode="deny" paths="auth/USA_1/,auth/amurica2/"

# Verify
v0 read /sys/replication/performance/primary/paths-filter/pr-secondary

# Enable auth paths on primary
v0 auth enable -path=USA_1 userpass
v0 auth enable -path=amurica2 userpass

pr0 login -method=userpass username=max password=1234

# Paths shouldn't be there
pr0 auth list | grep amurica