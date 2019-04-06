import 'package:firebase_auth/firebase_auth.dart';
import 'package:dartson/dartson.dart';
import 'package:firebase_database/firebase_database.dart';
class StateModel {
  bool isLoading;
  FirebaseUser user;

  StateModel({
    this.isLoading = false,
    this.user,
  });
}


class User{

   String username;
   String email;
   String uid;

//   User() {
//    // Default constructor required for calls to DataSnapshot.getValue(User.class)
//  }



  User.fromJson(Map model){
//    print(model["username"]);
    this.username = model["username"];
    this.email = model["email"];
    this.uid = model["uid"];
  }

}

class Message{

  String uid;
  String message;

  Message.fromJson(Map model){
//    print(model["username"]);
    this.uid = model["user"];
    this.message = model["message"];
  }
}