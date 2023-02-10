
//sful
import 'package:chat_gpt/constants/constants.dart';
import 'package:chat_gpt/providers/models_provider.dart';
import 'package:chat_gpt/services/api_service.dart';
import 'package:chat_gpt/services/assets_manager.dart';
import 'package:chat_gpt/services/services.dart';
import 'package:chat_gpt/widgets/chat_widget.dart';
import 'package:chat_gpt/widgets/text_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  bool _isTyping = false;
  late TextEditingController textEditingController;

  @override
  void initState() {
    textEditingController = new TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final modelsProvider = Provider.of<ModelsProvider>(context);
    return  Scaffold(
      appBar: AppBar(
        elevation: 2,
        leading: Padding(
          padding: EdgeInsets.all(8),
          child: Image.asset(AssetsManager.openaiLogo),
        ),
        title: Text("ChatGPT"),
        actions: [
          IconButton(
            onPressed: () async {
              await Services.showModalSheet(context: context);
            },
            icon: Icon(Icons.more_vert_rounded),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Flexible(
                child: ListView.builder(
                    itemCount: 6,
                    itemBuilder: (context, index){
                      return ChatWidget(
                        msg: chatMessages[index]["msg"].toString(),
                        chatIndex: int.parse(chatMessages[index]["chatIndex"].toString()),
                      );
                    }
                ),
            ),
            if ( _isTyping) ...[
              SpinKitThreeBounce(
                color: Colors.white,
                size: 18,
              ),
            ],
              SizedBox(height: 15,),
              Material(
                color: cardColor,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                          child: TextField(
                            style: TextStyle( color: Colors.white),
                            controller: textEditingController,
                            onSubmitted: (value){

                            },
                            decoration: InputDecoration.collapsed(hintText: "How can I help you ?", hintStyle: TextStyle(color: Colors.grey)),
                          ),
                      ),
                      IconButton(onPressed: () async {
                        print("Request has been sent");
                        try{

                          setState(() {
                            _isTyping=true;
                          });

                          final list = await ApiService.sendMessage(
                              message: textEditingController.text,
                              modelId: modelsProvider.getCurrentModel
                          );
                        }
                        catch(error){
                          //log("Error $error");
                          print("Error $error");
                        }
                        finally{
                          setState(() {
                            _isTyping=false;
                          });
                        }
                      }, icon: Icon(Icons.send, color: Colors.white,),),
                    ],
                  ),
                ),
              ),

          ],
        ),
      ),
    );
  }
}
