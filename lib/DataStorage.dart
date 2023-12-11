import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import "package:flutter/material.dart";
import 'package:firebase_auth/firebase_auth.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}
class _ChatPageState extends State<ChatPage>{
  final _authentication = FirebaseAuth.instance;
  User? loggrdUser;
  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }
  void getCurrentUser(){
    try {
      final user = _authentication.currentUser;
      if (user !=null){
        loggrdUser = user;
      }
    }catch(e){
      print(e);
    }

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chat"),
        actions: [
          IconButton(onPressed: (){
            FirebaseAuth.instance.signOut();
            Navigator.pop(context);
          }, icon: Icon(Icons.logout)),
        ],
      ),
      body:  NewMessage(),
    );
  }
}
class NewMessage extends StatefulWidget {
  const NewMessage({super.key});

  @override
  State<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  String newMessage = "";
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            decoration: InputDecoration(
              labelText: "New Message"
            ),
            onChanged: (value){
              setState(() {
                newMessage =value;
              });
            },
          ),
        )),
            IconButton(
                color:Colors.deepPurple,
                onPressed: newMessage.trim().isEmpty?null:()async{
                  final currentUser = FirebaseAuth.instance.currentUser;
                  final currentUserInfo = await FirebaseFirestore.instance.collection("user").doc(currentUser!.uid).get();
                  FirebaseFirestore.instance.collection("chat").add({
                    "text":newMessage,
                    "useName":currentUserInfo.data()!["userName"],
                    "timestamp":Timestamp.now(),
                    "uid":currentUser.uid,
                  });
                },
                icon: Icon(Icons.send))
      ],
    );
  }
}
