
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:happ_eats/controllers/message_controller.dart';

import '../models/message.dart';
import '../utils/getChatroomId.dart';



class ChatPage extends StatefulWidget {
  final String currentUser;
  final String otherUser;

  const ChatPage ({ super.key, required this.currentUser,  required this.otherUser});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {

  final _messageText = TextEditingController();

  int _amount = 20;

  ScrollController? _scrollController;

  MessagesController controllerMessages = MessagesController(db: FirebaseFirestore.instance, repositoryMessages: MessageRepository(db: FirebaseFirestore.instance));

  String _chatroom= "";

  late Stream _stateApplication;

  @override
  void initState() {


    _chatroom = getChatroomId(widget.currentUser, widget.otherUser);

    _stateApplication = controllerMessages.retrieveConversationMessages(_amount, _chatroom);

    _scrollController = ScrollController();
    _scrollController!.addListener(() {
      if (_scrollController!.position.pixels == _scrollController!.position.maxScrollExtent)
      {
        setState(() {
          _amount += 20;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(

        appBar: AppBar(
            title: const Text("Happ-eats"),
            actions: <Widget>[
              IconButton(
                icon: const Icon(Icons.settings),
                tooltip: 'Setting Icon',
                onPressed: () {},
              ),
            ]
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                  child: StreamBuilder(
                      stream: _stateApplication,//controllerMessages.retrieveConversationMessages(_amount, _chatroom),
                      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {

                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return  Column(
                            children: [
                              SizedBox(
                                height: size.height * 0.35,
                              ),
                              const Center(
                                child: CircularProgressIndicator(),
                              )
                            ],
                          );
                        }
                        else if (snapshot.hasError) {
                          return  Column(
                            children: [
                              SizedBox(
                                height: size.height * 0.35,
                              ),
                              const Center(child: Text("No se han podido recuperar los mensages"),)
                            ],
                          );
                        }
                        else if (!snapshot.hasData) {
                        return const Column(
                          children: [
                              Center(
                               child: Text("No hay mensajes todavía"),
                              )
                          ],
                        );
                        }
                        else {
                          return ListView.builder(
                            reverse: true,
                            padding: const EdgeInsets.only(right: 10.0, left: 10.0),
                            shrinkWrap: true,
                            itemCount:  snapshot.data.docs.length,
                            itemBuilder: (context, index) {
                              return createMessageBox(snapshot.data.docs[index]);
                            },
                          );
                        }
                      }
                  )
              ),

              Padding(
                padding: const EdgeInsets.only(right: 10.0, left: 10.0, bottom: 10.0, top: 10.0),
                child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  SizedBox(
                    width: size.width * 0.8,
                    child: TextField(
                      controller: _messageText,
                      decoration:  InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        hintText: 'Escribe aquí tu mensaje',
                      ),
                    )
                  ),
                  IconButton(
                      onPressed: () async {
                          if (_messageText.text!="")
                            {
                              String? result = await controllerMessages.sendMessage(_chatroom, widget.otherUser, widget.currentUser, _messageText.text);
                              setState(() {
                                controllerMessages.retrieveConversationMessages(_amount, _chatroom);
                              });
                              if (result==null&&context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(result!),)
                                );
                              }
                              else {
                                _messageText.clear();
                              }
                            }
                        },
                      icon: const Icon(Icons.send_sharp),
                       padding: const EdgeInsets.only(left: 10.0),
                  ),
                ],
              ),),


            ],
          ),
        )
    );
  }

  Widget createMessageBox(snapshot) {
    if (snapshot["fromID"]==widget.currentUser) {
      return Container(
        alignment: Alignment.centerRight,
        child: Card.filled(
          color: Colors.blueGrey,
          margin: const EdgeInsets.only(right: 10.0, left: 10.0, bottom: 10.0),
          child:
              Padding(
                padding:  const EdgeInsets.only(right: 10.0, left: 10.0, bottom: 5.0, top: 5.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(snapshot['text']),

                    Text("${snapshot['timestamp'].toDate().day.toString()}/${snapshot['timestamp'].toDate().month.toString()}/${snapshot['timestamp'].toDate().year.toString()} - ${snapshot['timestamp'].toDate().hour.toString()}:${snapshot['timestamp'].toDate().minute.toString()}")
                  ],
                )
              )
          /*ListTile(
            leading: Text(snapshot["text"]),
            trailing: Text(snapshot["timestamp"].toString()),
          ),*/
        ),
      );
    } else {
      return Container(
        alignment: Alignment.centerLeft,
        child: Card.filled(
            color: Colors.orange,
            margin: const EdgeInsets.only(right: 10.0, left: 10.0, bottom: 10.0),
            child:
            Padding(
                padding:  const EdgeInsets.only(right: 10.0, left: 10.0, bottom: 5.0, top: 5.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(snapshot['text']),

                    Text("${snapshot['timestamp'].toDate().day.toString()}/${snapshot['timestamp'].toDate().month.toString()}/${snapshot['timestamp'].toDate().year.toString()} - ${snapshot['timestamp'].toDate().hour.toString()}:${snapshot['timestamp'].toDate().minute.toString()}")
                    /*Text(snapshot['timestamp'].toDate().day.toString() + "/" +
                        snapshot['timestamp'].toDate().month.toString() + "/" +
                        snapshot['timestamp'].toDate().year.toString() + " - " +
                        snapshot['timestamp'].toDate().hour.toString() + ":" +
                        snapshot['timestamp'].toDate().minute.toString()
                    )*/
                  ],
                )
            )
          /*ListTile(
            leading: Text(snapshot["text"]),
            trailing: Text(snapshot["timestamp"].toString()),
          ),*/
        ),
      );
    }
  }


}