import 'dart:convert';
import 'dart:io';

import 'package:chat_gpt/constants/api_consts.dart';
import 'package:http/http.dart' as http;

class ApiService{
  static Future<void> getModels() async{
    try{
      var response  = await http.get(
        Uri.parse("$BASE_URL/models"),
        headers: {'Authorization': 'Bearer $API_KEY'}
      );

      Map jsonResponse  = jsonDecode(response.body);

      //print errors.
      if (jsonResponse['error'] != null) {
        print("jsonResponse['error'] ${jsonResponse['error']["message"]}");
        throw HttpException(jsonResponse['error']["message"]);
      }
      print("Json Response $jsonResponse");
    }
    catch(error){
      print("ERROR ENCOUNTERED: $error");
    }
  }
}