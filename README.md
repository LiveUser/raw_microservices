# Raw Microservices

-----------------------------------------------------------------------
## Notes

- All parameters must be in json format
- All of the parameters values must be of type string
- uncaught_server_exception means that some kind of exception that was not handled occurred on the server side

# Autista
-----------------------------------------------------------------------
Simple authentication services. 

## How to run the package locally

While inside your work/project directory run the command below(requires [installing dart](https://dart.dev/))

~~~
dart run
~~~



## API Functions
-----------------------------------------------------------------------

## Register account

Registers an account and sends a confirmation email.

### URL Path

~~~
/api/autista/registerUser
~~~

### Method

POST

### Header

- Content-Type = application/json
- Bearer ${admin_access_token_here}

### Request Parameters(post request body)

- email
- password
- name
- last_name

### Server Responses

All server responses are type string

- wrong_api_path - no API function corresponds to the URL path
- wrong_content_type - must be in JSON format and contain the header Content-Type = application/json
- access_denied - invalid access token
- wrong_method - method must be a POST request
- incorrect_parameters - incorrect parameters sent on the body or the data is not in JSON file format
- error_registering_user - server error
- user_registered_successfully - user registered. but the user must use the code on their email to confirm the account
- resent_confirmation_email - Successfully resent an email with the validation code
- must_wait - must wait at least 5 minutes in order to be allowed to request another email

-----------------------------------------------------------------------
## Validate account

### URL Path

~~~
/api/autista/validateAccount
~~~

### Method

POST

### Header

- Content-Type = application/json
- Bearer ${admin_access_token_here}

### Request Parameters(post request body)

- email
- validation_code

### Server Responses

All server responses are type string
- wrong_api_path - no API function corresponds to the URL path
- wrong_content_type - must be in JSON format and contain the header Content-Type = application/json
- access_denied - invalid access token
- wrong_method - method must be a POST request
- incorrect_parameters - incorrect parameters sent on the body or the data is not in JSON file format 
- user_already_registered - no need to validate. user has already been registered
- is_not_registered - you must Register account first(before running this function)
- incorrect_validation_code - incorrect validation code
- validated_successfully - validation code and email matched and the user is now successfully registered

-----------------------------------------------------------------------

## Login(Using username and password)

### URL Path

~~~
/api/autista/login
~~~

### Method

POST

### Header

- Content-Type = application/json
- Bearer ${admin_access_token_here}

### Request Parameters(post request body)

- email
- password

### Server Responses

All server responses are type string

- wrong_api_path - no API function corresponds to the URL path
- wrong_content_type - must be in JSON format and contain the header Content-Type = application/json
- access_denied - invalid access token
- wrong_method - method must be a POST request
- incorrect_parameters - incorrect parameters sent on the body or the data is not in JSON file format 
- is_not_registered - you must Register account first(before running this function)
- invalid_credentials - username and password don't match
- successful_login - credentials match

-----------------------------------------------------------------------

## Forgot password

### URL Path

~~~
/api/autista/forgotPassword
~~~

### Method

POST

### Header

- Content-Type = application/json
- Bearer ${admin_access_token_here}

### Request Parameters(post request body)

- email

### Server Responses

All server responses are type string

- wrong_api_path - no API function corresponds to the URL path
- wrong_content_type - must be in JSON format and contain the header Content-Type = application/json
- access_denied - invalid access token
- wrong_method - method must be a POST request
- incorrect_parameters - incorrect parameters sent on the body or the data is not in JSON file format 
- is_not_registered - you must Register account first(before running this function)
- error_sending_password - could not email password
- password_sent_successfully - check your inbox or spam folder, your password should be there

-----------------------------------------------------------------------

## Change Password

### URL Path

~~~
/api/autista/changePassword
~~~

### Method

POST

### Header

- Content-Type = application/json
- Bearer ${admin_access_token_here}

### Request Parameters(post request body)

- email
- password
- new_password

### Server Responses

All server responses are type string

- wrong_api_path - no API function corresponds to the URL path
- wrong_content_type - must be in JSON format and contain the header Content-Type = application/json
- access_denied - invalid access token
- wrong_method - method must be a POST request
- incorrect_parameters - incorrect parameters sent on the body or the data is not in JSON file format
- is_not_registered - you must Register account first(before running this function)
- invalid_credentials - username and password don't match
- successfully_changed_password

-----------------------------------------------------------------------

## Delete Account

### URL path

~~~
/api/autista/deleteAccount
~~~

### Method

POST

### Header

- Content-Type = application/json
- Bearer ${admin_access_token_here}

### Request Parameters(post request body)

- email
- password

### Server Responses

All server responses are type string

- wrong_api_path - no API function corresponds to the URL path
- wrong_content_type - must be in JSON format and contain the header Content-Type = application/json
- access_denied - invalid access token
- wrong_method - method must be a POST request
- incorrect_parameters - incorrect parameters sent on the body or the data is not in JSON file format
- is_not_registered - no account is registered under the given email
- successfully_deleted - account got deleted successfully

-----------------------------------------------------------------------
# Contribute/donate by tapping on the Pay Pal logo/image

<a href="https://www.paypal.com/paypalme/onlinespawn"><img src="https://www.paypalobjects.com/webstatic/mktg/logo/pp_cc_mark_74x46.jpg"/></a>  


-----------------------------------------------------------------------
# References

- https://api.dart.dev/stable/2.15.1/dart-io/HttpRequest-class.html
- https://stackoverflow.com/questions/20680073/dart-how-do-you-read-the-content-body-of-a-http-request