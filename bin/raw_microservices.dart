import 'dart:io';
import 'autista.dart';
import 'variables.dart';

//Use this as a reference https://replit.com/@LiveUser/Generic-APIs#main.dart
//Host this project on REPL.it and use app secret to hide Tokens and other sensitive information. Maybe try online virtual machines later.

const int port = 8080;

void main()async{
  HttpServer server = await HttpServer.bind(
    //Change to ipv6 before publicising
    InternetAddress.anyIPv6,
    port,
  );
  //Display info
  var interfaces = await NetworkInterface.list();
  var serverIP = interfaces.first.addresses.first;
  print("Server running on http://[${serverIP.address}]:$port");
  //Handle requests
  await for(HttpRequest request in server){
    String requestURL = request.uri.path;
    try{
      if("Bearer $adminAccessToken" == request.headers.value("Authorization")){
        if(requestURL.startsWith("/api/autista")){
          if(request.headers.contentType?.mimeType == "application/json"){
            String serverResponse = await Autista(
              path: requestURL,
              request: request,
            );
            request.response.write(serverResponse);
            await request.response.close();
          }else{
            request.response.write("wrong_content_type");
            await request.response.close();
          }
        }else{
          request.response.write("wrong_api_path");
          await request.response.close();
        }
      }else{
        request.response.write("access_denied");
        await request.response.close();
      }
    }catch(error){
      print(error);
      //Prevent the entire server from crashing in case of an unhandled exception
      request.response.write("uncaught_server_exception");
      await request.response.close();
    }
  }
}
//TODO: Name the authentication API autistista
//TODO: 
//TODO: Make a prepaid service. People add credit. Allow for auto-recharge on $10 increments(or something like that). Cancel service when runs out of funds. Keep data stored.