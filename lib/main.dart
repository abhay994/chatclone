import 'package:flutter/material.dart';
import 'dart:async';
import 'home.dart';
import 'signin.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      home: check(),
    );
  }


}
class check extends StatefulWidget {
  @override
  _checkState createState() => _checkState();
}

class _checkState extends State<check> {
  String name;
  @override
  void initState() {
    _getCurrentUserName();
    // TODO: implement initState
  Future.delayed(Duration(milliseconds: 800)).then((_){
    if(name!=null){
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => ChatBox()));
    }else{
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => SignIn()));
    }
  });



    super.initState();
  }
  _getCurrentUserName() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    name= user.displayName;
    print(name);
  }

  @override
  Widget build(BuildContext context) {
    return Container(

    );
  }
}

