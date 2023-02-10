import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:chat_gpt/constants/api_consts.dart';
import 'package:chat_gpt/models/chat_model.dart';
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

  // Send Message
  static Future<List<ChatModel>> sendMessage(
      {required String message, required String modelId}) async {
    try {
      //log("modelId $modelId");
      print("modelId $modelId");
      var response = await http.post(
        Uri.parse("$BASE_URL/completions"),
        headers: {
          'Authorization': 'Bearer $API_KEY',
          "Content-Type": "application/json"
        },
        body: jsonEncode(
          {
            "model": modelId,
            "prompt": message,
            "max_tokens": 1000, //message length
          },
        ),
      );

      Map jsonResponse = jsonDecode(response.body);

      if (jsonResponse['error'] != null) {
        // print("jsonResponse['error'] ${jsonResponse['error']["message"]}");
        throw HttpException(jsonResponse['error']["message"]);
      }
      List<ChatModel> chatList = [];
      if (jsonResponse["choices"].length > 0) {
        // log("jsonResponse[choices]text ${jsonResponse["choices"][0]["text"]}");
        print("jsonResponse[choices]text ${jsonResponse["choices"][0]["text"]}");
        chatList = List.generate(
          jsonResponse["choices"].length,
              (index) => ChatModel(
            msg: jsonResponse["choices"][index]["text"],
            chatIndex: 1,
          ),
        );
      }
      return chatList;
    } catch (error) {
      //log("error $error");
      print("error $error");
      rethrow;
    }
  }
}