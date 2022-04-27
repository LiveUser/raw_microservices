import 'error_handling.dart';
import 'dart:io';
import 'dart:convert';
import 'package:dbx_platform/dbx_platform.dart';
import 'email.dart';
import 'dart:math';
import 'variables.dart';

DBX dbx = DBX(
  accessToken: dbxAccessToken, 
  appKey: "", 
  appSecret: "",
);

// ignore: non_constant_identifier_names
Future<String> Autista({
  required String path,
  required HttpRequest request,
})async{
  if(path == "/api/autista/registerUser"){
    //Request is post
    if(request.method == "POST"){
      //Read request body
      UserRegistrationDetails? validatedParameters = await validateRegisterUser(request);
      if(validatedParameters != null){
        return await registerUser(validatedParameters);
      }else{
        return "incorrect_parameters";
      }
    }else{
      return "wrong_method";
    }
  }else if(path == "/api/autista/validateAccount"){
    if(request.method == "POST"){
      //Parse the parameters
      UserToValidate? userToValidate = await validateUserValidation(request);
      if(userToValidate == null){
        return "incorrect_parameters";
      }else{
        //Check if credentials are valid and move the file to the accounts folder
        return confirmUserRegistration(userToValidate);
      }
    }else{
      return "wrong_method";
    }
  }else if(path == "/api/autista/login"){
    if(request.method == "POST"){
      //Parse the parameters
      LoginUser? user = await validateLoginUser(request);
      if(user == null){
        return "incorrect_parameters";
      }else{
        //Run the function
        return await loginUser(user);
      }
    }else{
      return "wrong_method";
    }
  }else if(path == "/api/autista/forgotPassword"){
    if(request.method == "POST"){
      UserWhoForgotPassword?  userWhoFOrgotPassword = await validateUserWhoForgotPassword(request);
      if(userWhoFOrgotPassword == null){
        return "incorrect_parameters";
      }else{
        return await forgotPassword(userWhoFOrgotPassword);
      }
    }else{
      return "wrong_method";
    }
  }else if(path == "/api/autista/changePassword"){
    if(request.method == "POST"){
      //Validate credentials
      ChangePasswordCredentials? changePasswordCredentials = await validateChangePasswordCredentials(request);
      if(changePasswordCredentials == null){
        return "incorrect_parameters";
      }else{
        return await changePassword(changePasswordCredentials);
      }      
    }else{
      return "wrong_method";
    }
  }else if(path == "/api/autista/deleteAccount"){
    if(request.method == "POST"){
      UserThatWantsToDeleteTheAccount? userThatWantsToDeleteTheAccount = await validateDeleteTheAccountCredentials(request);
      if(userThatWantsToDeleteTheAccount == null){
        return "incorrect_parameters";
      }else{
        return await deleteAccount(
          userThatWantsToDeleteTheAccount: userThatWantsToDeleteTheAccount,
        );
      }
    }else{
      return "wrong_method";
    }
  }else{
    return "wrong_api_path";
  }
}
Future<String> registerUser(UserRegistrationDetails parameters)async{
  try{
    DBX_File registeredUser = DBX_File(path: "/autista/accounts/${parameters.email}.json");
    DBX_File userAwaitingRegistration = DBX_File(path: "/autista/awaiting_confirmation/${parameters.email}.json");
    if(await dbx.itemExists(dbx_item: registeredUser)){
      return "user_already_registered";
    }else{
      String confirmationCode = "";
      bool emailSent;
      if(await dbx.itemExists(dbx_item: userAwaitingRegistration)){
        //Download/retrieve the file
        String json = await dbx.readFileAsString(dbx_file: userAwaitingRegistration);
        //Parse it
        Map<String,dynamic> parsedJSON = jsonDecode(json);
        //Get the code
        confirmationCode = parsedJSON["validation_code"];
        //Check if more than x amount of time(5 minutes) have passed before sending the email
        DateTime storedDate = DateTime.parse(parsedJSON["date_accessed"]);
        DateTime now = DateTime.now().toUtc();
        var dateTimeDifference = storedDate.difference(now);
        if(dateTimeDifference.inMinutes > 5){
          //replace the date on the file 
          //Email it to the person
          emailSent = await sendConfirmationEmail(
            details: parameters, 
            validationCode: confirmationCode,
          );
          return "resent_confirmation_email";
        }else{
          return "must_wait";
        }
      }else{
        //Generate a 6 digit confirmation code
        for(int i = 0; i < 6; i++){
          confirmationCode += Random().nextInt(9).toString();
        }
        //Generate and save a dropbox file
        Map<String,dynamic> accountConfirmationObject = {
          "password" : parameters.password,
          "validation_code" : confirmationCode,
          "date_accessed" : DateTime.now().toUtc().toString(),
          "last_name" : parameters.lastName,
          "name" : parameters.name,
        };
        String json = jsonEncode(accountConfirmationObject);
        //Create a function that accepts bytes
        await dbx.createFileFromMemory(
          bytes: json.codeUnits,
          fileToCreate: userAwaitingRegistration, 
          mode: WriteMode.add,
        );
        //Send the email
        emailSent = await sendConfirmationEmail(
          details: parameters, 
          validationCode: confirmationCode,
        );
        if(emailSent){
          return "user_registered_successfully";
        }else{
          return "error_registering_user";
        }
      }
      //-----------------------------------------------------------------------
    }
  }catch(error){
    return "error_registering_user";
  }
}
Future<String> confirmUserRegistration(UserToValidate userToValidate)async{
  DBX_File registeredUser = DBX_File(path: "/autista/accounts/${userToValidate.email}.json");
  DBX_File userAwaitingRegistration = DBX_File(path: "/autista/awaiting_confirmation/${userToValidate.email}.json");
  if(await dbx.itemExists(dbx_item: registeredUser)){
    return "user_already_registered";
  }else if((await dbx.itemExists(dbx_item: userAwaitingRegistration) == false)){
    return "is_not_registered";
  }else{
    //Get the file
    String json = await dbx.readFileAsString(dbx_file: userAwaitingRegistration);
    //Parse the file
    Map<String,dynamic> parsedJSON = jsonDecode(json);
    //Remove the extra keys and values
    parsedJSON.remove("validation_code");
    //Turn it back into a json
    json = jsonEncode(parsedJSON);
    //Save it to the accounts file
    await dbx.createFileFromMemory(
      bytes: json.codeUnits,
      fileToCreate: registeredUser, 
      mode: WriteMode.add,
    );
    //Delete the awaiting registration file
    await dbx.deleteItem(dbx_item: userAwaitingRegistration);
    return "validated_successfully";
  }
}
Future<String> loginUser(LoginUser loginUser)async{
  DBX_File registeredUser = DBX_File(path: "/autista/accounts/${loginUser.email}.json");
  if(await dbx.itemExists(dbx_item: registeredUser)){
    String json = await dbx.readFileAsString(dbx_file: registeredUser);
    Map<String,dynamic> registeredAccount = jsonDecode(json);
    String accountPassword = registeredAccount["password"];
    if(accountPassword == loginUser.password){
      return "successful_login";
    }else{
      return "invalid_credentials";
    }
  }else{
    return "is_not_registered";
  }
}
Future<String> forgotPassword(UserWhoForgotPassword userWhoForgotPassword)async{
  DBX_File registeredUser = DBX_File(path: "/autista/accounts/${userWhoForgotPassword.email}.json");
  if(await dbx.itemExists(dbx_item: registeredUser)){
    String json = await dbx.readFileAsString(dbx_file: registeredUser);
    Map<String,dynamic> parsedJSON = jsonDecode(json);
    String password = parsedJSON["password"];
    //Email password
    String html = await File("html_templates/forgot_password.html").readAsString();
    //Replace placeholder with password
    html.replaceFirst("[pass_code]", password);
    //Send email
    bool sentSuccessfully = await sendForgotPasswordEmail(
      email: userWhoForgotPassword.email, 
      password: password, 
      name: parsedJSON["name"], 
      lastName: parsedJSON["last_name"],
    );
    if(sentSuccessfully){
      return "password_sent_successfully";
    }else{
      return "error_sending_password";
    }
  }else{
    return "is_not_registered";
  }
}
Future<String> changePassword(ChangePasswordCredentials changePasswordCredentials)async{
  DBX_File registeredUser = DBX_File(path: "/autista/accounts/${changePasswordCredentials.email}.json");
  if(await dbx.itemExists(dbx_item: registeredUser)){
    String json = await dbx.readFileAsString(dbx_file: registeredUser);
    Map<String,dynamic> parsedJSON = jsonDecode(json);
    if(parsedJSON["password"] == changePasswordCredentials.password){
      //Change password
      parsedJSON["password"] = changePasswordCredentials.newPassword;
      json = jsonEncode(parsedJSON);
      await dbx.createFileFromMemory(
        bytes: json.codeUnits, 
        fileToCreate: registeredUser, 
        mode: WriteMode.overwrite,
      );
      return "successfully_changed_password";
    }else{
      return "invalid_credentials";
    }
  }else{
    return "is_not_registered";
  }
}
//Delete account function
Future<String> deleteAccount({
  required UserThatWantsToDeleteTheAccount userThatWantsToDeleteTheAccount,
})async{
  DBX_File account = DBX_File(path: "/autista/accounts/${userThatWantsToDeleteTheAccount.email}.json");
  if(await dbx.itemExists(dbx_item: account)){
    await dbx.deleteItem(dbx_item: account);
    return "successfully_deleted";
  }else{
    return "is_not_registered";
  }
}