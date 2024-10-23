import 'dart:convert';

import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AiBotScreen extends StatefulWidget {
  const AiBotScreen({super.key, required String title});

  @override
  State<AiBotScreen> createState() => _AiBotScreenState();
}

class _AiBotScreenState extends State<AiBotScreen> {
  ChatUser myself = ChatUser(id:'1',firstName: 'zeeshan');
  ChatUser bot = ChatUser(id:'2',firstName: 'gemini');

  List<ChatMessage> allMessages = [];
  List<ChatUser> typing = [];
  final oururl='https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash-latest:generateContent?key=AIzaSyAnBj_V2WOkHaAr4g0pqvM5gpCKahIm1E4';
  final header={
    'Content-Type': 'application/json'
  };

  getdata(ChatMessage m)async{
    typing.add(bot);
     allMessages.insert(0,m);
      setState(() {
        
      });
      var data={"contents":[{"parts":[{"text":m.text}]}]};
      await http.post(Uri.parse(oururl),headers:header,body: jsonEncode(data)).then((value){
        if(value.statusCode==200){
             var result=jsonDecode(value.body);
             print(result['candidates'][0]['content']['parts'][0]['text']);
             ChatMessage m1=ChatMessage(
              text: result['candidates'][0]['content']['parts'][0]['text'],
              user:bot,
              createdAt: DateTime.now() );
             allMessages.insert(0,m1);
             
        }
        else{
          print("error occured");
        }
      }).catchError((e){

      });
      typing.remove(bot);
      setState(() {
               
             });
  }
  
 
  
  @override
 Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56.0), // Set the height of the AppBar
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue, Colors.white, Colors.lightBlueAccent], // Gradient colors
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: AppBar(
            title: const Text(
              "Ai Bot",
              style: TextStyle(color: Colors.black), // Change text color to black for better contrast
            ),
            backgroundColor: Colors.transparent, // Make AppBar background transparent
            centerTitle: true,
            elevation: 0, // Remove shadow
          ),
        ),
      ),
      body: Container(
        color: Colors.lightBlue[100], // Set the background color of the body to a sky blue shade
        child: DashChat(
          typingUsers: typing,
          currentUser: myself,
          onSend: (ChatMessage m) {
            getdata(m);
          },
          messages: allMessages,
        ),
      ),
    );
  }



}