### Not Scripted ###
GITHUB_ORG=
GITHUB_USERNAME=
GITHUB_TOKEN=
####################

vault auth enable github

vault write auth/github/config organization=$GITHUB_ORG

vault write auth/github/map/users/max value=$GITHUB_USERNAME

vault login -method=github token=$GITHUB_TOKEN