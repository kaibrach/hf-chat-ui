from keycloak import KeycloakOpenID
from keycloak import K
from keycloak import KeycloakAdmin
from keycloak import KeycloakOpenIDConnection

# Configure client
keycloak_openid = KeycloakOpenID(server_url="http://localhost:8080/auth/",
                                 client_id="example_client",
                                 realm_name="example_realm",
                                 client_secret_key="secret")

# Get WellKnown
config_well_known = keycloak_openid.well_known()

# Get Code With Oauth Authorization Request
auth_url = keycloak_openid.auth_url(
    redirect_uri="http://localhost:5173/login/*",
    scope="email",
    state="your_state_info")

# Get Access Token With Code
access_token = keycloak_openid.token(
    grant_type='authorization_code',
    code='the_code_you_get_from_auth_url_callback',
    redirect_uri="http://localhost:5173/login/*")


# Get Token
token = keycloak_openid.token("user", "password")
#token = keycloak_openid.token("user", "password", totp="012345")

# Get token using Token Exchange
#token = keycloak_openid.exchange_token(token['access_token'], "my_client", "other_client", "some_user")

# Get Userinfo
userinfo = keycloak_openid.userinfo(token['access_token'])

# Refresh token
#token = keycloak_openid.refresh_token(token['refresh_token'])

# Logout
#keycloak_openid.logout(token['refresh_token'])