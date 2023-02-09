
//sful
import 'package:chat_gpt/constants/constants.dart';
import 'package:chat_gpt/services/assets_manager.dart';
import 'package:chat_gpt/widgets/chat_widget.dart';
import 'package:chat_gpt/widgets/text_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  bool _isTyping = true;
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
              await showModalBottomSheet(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                  ),
                  backgroundColor: scaffoldBackgroundColor,
                  context: context,
                  builder: (context){
                    return Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Row(
                        children: [
                          Flexible(
                              child: TextWidget(
                                label: "Chosen Model",
                                fontSize: 16,
                              ),
                          ),
                        ],
                      ),
                    );
                  }
              );
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
                      IconButton(onPressed: (){}, icon: Icon(Icons.send, color: Colors.white,),),
                    ],
                  ),
                ),
              ),
            ],

          ],
        ),
      ),
    );
  }
}
