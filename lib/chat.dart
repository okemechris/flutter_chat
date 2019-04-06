
import 'dart:collection';

import 'package:chat_app_flutter/models/state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget{

  ChatPage({Key key,this.name,this.uid}) : super(key: key);

  final String name;
  final String uid;


  @override
  _ChatState createState() => _ChatState();




}


class _ChatState extends State<ChatPage> {

  @override ChatPage get widget => super.widget;
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseUser user;
  DatabaseReference reference1;
  DatabaseReference reference2;
  TextEditingController _controller;
  List<Message> chatHolder;


  @override
  void initState() {
    super.initState();


    getLoggedInUser();
    _controller = new TextEditingController();
    chatHolder = new List<Message>();

  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return new  Scaffold(

        appBar: new AppBar(
          title: new Text(widget.name),
          backgroundColor: Colors.red,

        ),

        backgroundColor: Colors.white,
        body: new Container(


          child: new Stack(
            //alignment:new Alignment(x, y)
            children: <Widget>[
              new Positioned(
                  child: new ListView.builder(itemBuilder: (BuildContext ctxt, int index) {

                    if(chatHolder[index].uid == user.uid){
                      return new Bubble(
                        message: chatHolder[index].message,
                        time: '12:00',
                        delivered: true,
                        isMe: true,
                      );
                    }else{

                      return new Bubble(
                        message: chatHolder[index].message,
                        time: '12:00',
                        delivered: true,
                        isMe: false,
                      );
                    }

                  },itemCount: chatHolder.length, padding: new EdgeInsets.fromLTRB(0, 0, 0, 70),


                )




              ),
              new Positioned(
                child: new Align(

                    alignment: FractionalOffset.bottomCenter,
                    
                    child: new Container( child : new Container(

                      child: new Row(
                      children: <Widget>[

                        Expanded(child: new Padding(child: new TextField(

                            decoration: new InputDecoration.collapsed(
                          hintText: "type a message"
                        ),
                          controller: _controller,
                        ), padding: EdgeInsets.fromLTRB(10.0,0,10,0),), ),
                        new IconButton(onPressed: ()=> sendMessage(), icon: new Icon(Icons.send),)

                      ],
                    ),
                    
                    decoration: new BoxDecoration(
                    borderRadius: new BorderRadius.all(Radius.circular(10.0)),
                    color: Colors.black12,

                    ),
                      margin: EdgeInsets.all(10.0),
                
                
                
                ),
              color: Colors.white,
                    ),)
              )
            ],
          ),


        ),



    );
  }



   getLoggedInUser() async {
     user = await _auth.currentUser();
     reference1 =  FirebaseDatabase.instance.reference().child("messages").child( user.uid + "_" + widget.uid);
     reference2 =  FirebaseDatabase.instance.reference().child("messages").child( widget.uid + "_" + user.uid);

     reference1.onChildAdded.listen((Event event){
//       print('Child added: ${event.snapshot.value}');
       Map map = event.snapshot.value;
//       String message = map["message"];
//       String userName = map["user"];
//       print(message);
//       print(userName);
       Message m =  Message.fromJson(map);
       setState(() {
         chatHolder.add(m);
       });

//       if(userName == user.uid){
//         addMessageBox(message, 1);
//       }
//       else{
//         addMessageBox( message, 2);
//       }

     }, onError: (Object o) {
       final DatabaseError error = o;
       print('Error: ${error.code} ${error.message}');
     });
    // here you write the codes to input the data into firestore
  }

  void sendMessage(){
    if(_controller.text != null){
      Map<String, String> map = new HashMap<String, String>();
      map.putIfAbsent("message", ()=> _controller.text);
      map.putIfAbsent("user", ()=> user.uid);
      reference1.push().set(map);
      reference2.push().set(map);
      _controller.clear();
    }
  }

  void addMessageBox(String message, int type){
    Bubble messageBox;
    if(type == 1){

      messageBox = new Bubble(
        message: message,
        time: '12:00',
        delivered: true,
        isMe: true,
      );
    }else{

      messageBox = Bubble(
        message: message,
        time: '12:00',
        delivered: true,
        isMe: false,
      );
    }

//    setState(() {
//      chatHolder.add(messageBox);
//    });
//    return messageBox;
  }
}

class Bubble extends StatelessWidget {
  Bubble({this.message, this.time, this.delivered, this.isMe});

  final String message, time;
  final delivered, isMe;

  @override
  Widget build(BuildContext context) {
    final bg = isMe ? Colors.white : Colors.greenAccent.shade100;
    final align = isMe ? CrossAxisAlignment.start : CrossAxisAlignment.end;
    final icon = delivered ? Icons.done_all : Icons.done;
    final radius = isMe
        ? BorderRadius.only(
      topRight: Radius.circular(5.0),
      bottomLeft: Radius.circular(10.0),
      bottomRight: Radius.circular(5.0),
    )
        : BorderRadius.only(
      topLeft: Radius.circular(5.0),
      bottomLeft: Radius.circular(5.0),
      bottomRight: Radius.circular(10.0),
    );
    return Column(
      crossAxisAlignment: align,
      children: <Widget>[
        Container(
          margin: const EdgeInsets.all(3.0),
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                  blurRadius: .5,
                  spreadRadius: 1.0,
                  color: Colors.black.withOpacity(.12))
            ],
            color: bg,
            borderRadius: radius,
          ),
          child: Stack(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(right: 48.0),
                child: Text(message),
              ),
              Positioned(
                bottom: 0.0,
                right: 0.0,
                child: Row(
                  children: <Widget>[
                    Text(time,
                        style: TextStyle(
                          color: Colors.black38,
                          fontSize: 10.0,
                        )),
                    SizedBox(width: 3.0),
                    Icon(
                      icon,
                      size: 12.0,
                      color: Colors.black38,
                    )
                  ],
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}