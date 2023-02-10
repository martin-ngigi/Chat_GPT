import 'package:chat_gpt/models/models_model.dart';
import 'package:chat_gpt/services/api_service.dart';
import 'package:flutter/cupertino.dart';

class ModelsProvider  with ChangeNotifier{
  String currentModel = "text-davinci-003";

  String get getCurrentModel{
    return currentModel;
  }

  void setCurrentModel(String newModel){
    currentModel = newModel;
    notifyListeners();
  }

  List<ModelsModel> modelList = [];

  List<ModelsModel> get getModelsList{
    return modelList;
  }

  Future<List<ModelsModel>> getAllModels() async{
    modelList = await ApiService.getModels();
    return modelList;
  }
}