# Autista
Raw Ware authentication software

-----------------------------------------------------------------------------

Note: All parameters and values must be strings. All errors/responses that aren't listed below don't come from my software(File System, OS, any other kind of exceptions).

Send requests to http://[${serverIP.address}]:4040/autista"

~~~dart
~~~



## ✅Create account 

### Request

Parameters:

- type = create_account
- username = username
- password = password
- email = email

### Possible Responses

- account_successfully_created
- account_already_exists
- account_creation_error
- invalid_parameters
- username_contains_ilegal_characters
  - if the username contains ["#","<","%",">","&","*","{","?","}","/","\\"," ","\$","+","!","`","'","|",'"',"=",":","@"]
- empty_parameter_value
  - One or more of the parameters has an empty string as a value

-----------------------------------------------------------------------------
## ✅Login to account

### Request

Parameters:

- type = login_to_account
- password = password
- username = username
- api_key = api_key
  - Use raw_microservices to bypass this check(do not publicise this)


### Possible Responses

- access_token:access token number will go here
  - Use "raw_microservices_access_token" to bypass this check(do not publicise this)
- wrong_password
- login_error
- account_does_not_exist
  - username is not registered
- invalid_parameters
- invalid_api_key
- empty_parameter_value
  - One or more of the parameters has an empty string as a value

-----------------------------------------------------------------------------
## ✅Token is valid

### Request

Parameters:

- type = token_is_valid
- username = username
- access_token = access_token
  - Use "raw_microservices_access_token" to bypass this check(do not publicise this)

- api_key = api_key
  - Use raw_microservices to bypass this check(do not publicise this)


### Possible Responses

- token_is_valid
- invalid_token
- invalid_api_key
- invalid_parameters
- empty_parameter_value
  - One or more of the parameters has an empty string as a value

-----------------------------------------------------------------------------
## ✅Delete account

### Request

Parameters:

- type = permanently_delete_account
- username = username
- password = password

### Possible Responses

- successfully_deleted_account
- account_does_not_exist
- wrong_password
- invalid_parameters
- error_deleting_account
- empty_parameter_value
  - One or more of the parameters has an empty string as a value


-----------------------------------------------------------------------------
## Forgot password

### Request

Parameters:

- username = username
- 

### Possible Responses

- invalid_parameters

-----------------------------------------------------------------------------

## ✅Register App / Get an API key

Generate an unique API key for your Raw Microservices account and assign it an app name.

### Request

Parameters:

- type = register_app
- username = username
- password = password
- app_name = name_of_the_app

### Possible Responses

- successfully_created_api_key
- app_name_already_exists
- app_name_contains_ilegal_characters
- error_creating_api_key
- invalid_parameters


-----------------------------------------------------------------------------
## 



