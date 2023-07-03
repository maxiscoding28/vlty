vault auth enable userpass

vault write auth/userpass/users/max password=1234

vault write auth/userpass/login/max password=1234

vault read auth/userpass/users/max

vault write auth/userpass/login/max password=1234