import 'dart:convert';
import 'dart:io';

//-------------------------------------------------------------------------------------------------
//Classes/Types
class UserRegistrationDetails{
  UserRegistrationDetails({
    required this.lastName,
    required this.name,
    required this.password,
    required this.email,
  });
  final String email;
  final String password;
  final String name;
  final String lastName;
}
class UserToValidate{
  UserToValidate({
    required this.email,
    required this.validationCode,
  });
  final String email;
  final String validationCode;
}
class LoginUser{
  LoginUser({
    required this.email,
    required this.password,
  });
  final String email;
  final String password;
}
class UserWhoForgotPassword{
  UserWhoForgotPassword({
    required this.email,
  });
  final String email;
}
class  ChangePasswordCredentials{
  ChangePasswordCredentials({
    required this.email,
    required this.newPassword,
    required this.password,
  });
  final String email;
  final String password;
  final String newPassword;
}
//-------------------------------------------------------------------------------------------------
//Functions
Future<UserRegistrationDetails?> validateRegisterUser(HttpRequest request)async{
  try{
    String requestBody = await  utf8.decodeStream(request.asBroadcastStream());
    Map<String,dynamic> parsedJSON = jsonDecode(requestBody);
    if(parsedJSON.length == 4){
      return UserRegistrationDetails(
        lastName: parsedJSON["last_name"], 
        name: parsedJSON["name"], 
        password: parsedJSON["password"], 
        email: parsedJSON["email"],
      );
    }else{
      return null;
    }
  }catch(error){
    return null;
  }
}
Future<UserToValidate?> validateUserValidation(HttpRequest request)async{
  try{
    String requestBody = await  utf8.decodeStream(request.asBroadcastStream());
    Map<String,dynamic> parsedJSON = jsonDecode(requestBody);
    if(parsedJSON.length == 2){
      return UserToValidate(
        email: parsedJSON["email"], 
        validationCode: parsedJSON["validation_code"],
      );
    }else{
      return null;
    }
  }catch(err){
    return null;
  }
}
Future<LoginUser?> validateLoginUser(HttpRequest request)async{
  try{
    String requestBody = await  utf8.decodeStream(request.asBroadcastStream());
    Map<String,dynamic> parsedJSON = jsonDecode(requestBody);
    if(parsedJSON.length == 2){
      return LoginUser(
        email: parsedJSON["email"], 
        password: parsedJSON["password"],
      );
    }else{
      return null;
    }
  }catch(error){
    return null;
  }
}
Future<UserWhoForgotPassword?> validateUserWhoForgotPassword(HttpRequest request)async{
  try{
    String requestBody = await  utf8.decodeStream(request.asBroadcastStream());
    Map<String,dynamic> parsedJSON = jsonDecode(requestBody);
    if(parsedJSON.length == 1){
      return UserWhoForgotPassword(
        email : parsedJSON["email"],
      );
    }else{
      return null;
    }
  }catch(error){
    return null;
  }
}
Future<ChangePasswordCredentials?> validateChangePasswordCredentials(HttpRequest request)async{
  try{
    String requestBody = await  utf8.decodeStream(request.asBroadcastStream());
    Map<String,dynamic> parsedJSON = jsonDecode(requestBody);
    if(parsedJSON.length == 3){
      return ChangePasswordCredentials(
        email: parsedJSON["email"], 
        newPassword: parsedJSON["last_name"], 
        password: parsedJSON["password"],
      );
    }else{
      return null;
    }
  }catch(err){
    return null;
  }
}
//-------------------------------------------------------------------------------------------------