import 'dart:convert';

import 'package:chat_app_flutter/chat.dart';
import 'package:chat_app_flutter/main.dart';
import 'package:chat_app_flutter/models/state.dart';
import 'package:chat_app_flutter/state_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  DatabaseReference mDatabase;
  List<User> userList ;

  StateModel appState;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    userList = new List();
    mDatabase = FirebaseDatabase.instance.reference();
    getFirebaseLoggedInUser();
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    appState = StateWidget.of(context).state;
    return _buildContent();
  }

  Widget _buildContent() {

    if (appState.isLoading) {
      return _buildContentView(
        child: _buildLoadingIndicator(),
      );
    } else if (!appState.isLoading && appState.user == null) {
      return new MyHomePage();
    } else {
      return _buildContentView(
        child: _buildHomeContent(),
      );
    }
  }

  Container _buildContentView ({Widget child}){

    return Container(

      child: child,
    );
  }

  Center _buildLoadingIndicator() {
    return Center(
      child: new CircularProgressIndicator(),
    );
  }

  Scaffold _buildHomeContent() {

    return Scaffold(
        appBar: new AppBar(
          title: new Text("Flutter Chat App"),
          backgroundColor: Colors.red,

        ),
//        drawer: new Drawer(),

        body: ListView.builder(itemBuilder: (BuildContext ctxt, int index) {
//         print("kkkfjj "+userList.length.toString());
          return new InkWell(
              child: Row(
              children: <Widget>[new Container(
                child: new Text (
                    userList[index].username[0],
                    style: new TextStyle(
                        color: Colors.blue[500],
                        fontSize: 30,
                        fontWeight: FontWeight.w900
                    )
                ),
                decoration: new BoxDecoration (
                    shape: BoxShape.circle,
                    color: Colors.black12

                ),
                padding: new EdgeInsets.all(20.0),
              ), new Padding(child: new Text (
                  userList[index].username), padding: new EdgeInsets.all(10.0))
              ]
          ),

          onTap: () => Navigator.push(
            context,
            new MaterialPageRoute(
                builder: (BuildContext context) => new ChatPage(name:userList[index].username,uid:userList[index].uid)),
          ),
          );
        }, itemCount: userList.length, padding: const EdgeInsets.all(10.0),

        )

    );



  }

  void getFirebaseLoggedInUser()  {

    mDatabase.child("users").once().then((DataSnapshot snapshot) {
      Map<String, dynamic> mapOfMaps = Map.from(snapshot.value);
      mapOfMaps.values.forEach((value) {
        User user = User.fromJson(Map.from(value));
        print(user.uid);
        userList.add(
            user
        );


      });

      
    }).whenComplete(() => doSetState());

  }

  bool stateIsSet = false;
  void doSetState(){
    if(!stateIsSet){
      setState(() {

      });
      stateIsSet = true;
    }
  }
}
