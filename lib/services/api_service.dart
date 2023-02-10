import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:chat_gpt/constants/api_consts.dart';
import 'package:http/http.dart' as http;

import '../models/models_model.dart';

class ApiService{
  static Future<List<ModelsModel>> getModels() async{
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
      //print("Json Response $jsonResponse");
      //log("Json Response $jsonResponse");

      List temp = [];
      for(var value in jsonResponse["data"]){
        temp.add(value);
        print("temp ${value["id"]}");
        //log("temp ${value["id"]}");
      }
      return ModelsModel.modelsFromSnapshot(temp);
    }
    catch(error){
      print("ERROR ENCOUNTERED: $error");
      //log("ERROR ENCOUNTERED: $error");
      rethrow;
    }
  }
}