vault auth enable aws

vault write auth/aws/role/vault-aws-role \
     auth_type=iam \
     bound_iam_principal_arn= \
     policies=vault-policy-for-aws-ec2role
