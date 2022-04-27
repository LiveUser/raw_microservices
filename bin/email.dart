import 'dart:io';
import 'package:mailjet/mailjet.dart';
import 'error_handling.dart' show UserRegistrationDetails;
import 'variables.dart';

//Mailjet setup
MailJet mailJet = MailJet(apiKey: apiKey, secretKey: secretKey);

Future<bool> sendConfirmationEmail({
  required UserRegistrationDetails details,
  required String validationCode,
})async{
  try{
    //Read the HTML text file
    String html = await File("html_templates/confirmation_code.html").readAsString();
    //Replace the placeholder with the validation code
    html = html.replaceFirst("[validation_code]", validationCode);
    await mailJet.sendEmail(
      subject: "Raw Microservices Account Validation", 
      sender: Sender(
        email: myEmail, 
        name: "Raw Ware Software",
      ), 
      reciepients: [
        Recipient(
          email: details.email, 
          name: details.name + " " + details.lastName,
        ),
      ],
      htmlEmail: html,
      InlinedAttachments: [
        InlinedAttachment(
          file: File("images/logo.png"), 
          contentID: "logo",
        ),
      ],
    );
    return true;
  }catch(error){
    return false;
  }
}
Future<bool> sendForgotPasswordEmail({
  required String email,
  required String password,
  required String name,
  required String lastName,
})async{
  try{
    //Read the HTML text file
    String html = await File("html_templates/forgot_password.html").readAsString();
    //Replace the placeholder with the validation code
    html = html.replaceFirst("[pass_code]", password);
    await mailJet.sendEmail(
      subject: "Raw Microservices - Password", 
      sender: Sender(
        email: myEmail, 
        name: "Raw Ware Software",
      ), 
      reciepients: [
        Recipient(
          email: email, 
          name: name + " " + lastName,
        ),
      ],
      htmlEmail: html,
      InlinedAttachments: [
        InlinedAttachment(
          file: File("images/logo.png"), 
          contentID: "logo",
        ),
      ],
    );
    return true;
  }catch(err){
    return false;
  }
}