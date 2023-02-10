
//sful
import 'package:chat_gpt/constants/constants.dart';
import 'package:chat_gpt/models/chat_model.dart';
import 'package:chat_gpt/providers/chats_provider.dart';
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
  late FocusNode focusNode; //hide keyboard after typing
  late ScrollController _listScrollController;

  @override
  void initState() {
    textEditingController = TextEditingController();
    focusNode = FocusNode();
    _listScrollController = ScrollController();
    super.initState();
  }

  @override
  void dispose() {
    textEditingController.dispose();
    focusNode.dispose();
    _listScrollController.dispose();
    super.dispose();
  }

  //List<ChatModel> chatList = [];

  @override
  Widget build(BuildContext context) {
    final modelsProvider = Provider.of<ModelsProvider>(context);
    final chatProvider = Provider.of<ChatProvider>(context);
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
                    controller: _listScrollController,
                    itemCount: chatProvider.chatList.length, //chatList.length,
                    itemBuilder: (context, index){
                      return ChatWidget(
                        msg: chatProvider.getChatList[index].msg, //chatList[index].msg,
                        chatIndex: chatProvider.getChatList[index].chatIndex,//chatList[index].chatIndex,
                      );
                    },
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
                            focusNode : focusNode,
                            style: TextStyle( color: Colors.white),
                            controller: textEditingController,
                            onSubmitted: (value) async {
                              sendMessageFCT(modelsProvider: modelsProvider, chatProvider: chatProvider);
                            },
                            decoration: InputDecoration.collapsed(hintText: "How can I help you ?", hintStyle: TextStyle(color: Colors.grey)),
                          ),
                      ),
                      IconButton(onPressed: () async {
                        sendMessageFCT(modelsProvider: modelsProvider, chatProvider: chatProvider);
                      },
                        icon: Icon(Icons.send, color: Colors.white,),),
                    ],
                  ),
                ),
              ),

          ],
        ),
      ),
    );
  }
  void scrollListToEnd(){
    _listScrollController.animateTo(
        _listScrollController.position.maxScrollExtent,
        duration: Duration(seconds: 2),
        curve: Curves.easeOut
    );
  }

  Future<void> sendMessageFCT({required ModelsProvider modelsProvider, required ChatProvider chatProvider}) async {
    if (_isTyping) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: TextWidget(
            label: "You cant send multiple messages at a time",
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    if (textEditingController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: TextWidget(
            label: "Please type a message",
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try{

      setState(() {
        _isTyping=true;
        //chatList.add(ChatModel(msg: textEditingController.text, chatIndex: 0));
        chatProvider.addUserMessage(msg: textEditingController.text);
        textEditingController.clear();
        focusNode.unfocus(); //hide keyboard
      });

      await chatProvider.sendMessageAndGetAnswers(msg: textEditingController.text, chosenModelId: modelsProvider.getCurrentModel);
      // chatList.addAll(await ApiService.sendMessage(
      //     message: textEditingController.text,
      //     modelId: modelsProvider.getCurrentModel
      // ));

      setState(() {

      });
    }
    catch(error){
      //log("Error $error");
      print("Error $error");

      //toast error
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: TextWidget(
          label: error.toString(),
        ),
        backgroundColor: Colors.red,
      ));
    }
    finally{
      setState(() {
        scrollListToEnd();
        _isTyping=false;
      });
    }
  }
}
