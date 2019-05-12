import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'home.dart';

import 'package:flutter_signin_button/flutter_signin_button.dart';
class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => new _SignInState();
}

class _SignInState extends State<SignIn> {
  String uid;
  String name;
  String mtoken;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  void routing() async {

    Map<String, String> data = <String, String>{
      "uid": uid,
      "name": name,
      "mtoken" :mtoken

    };
    Firestore.instance.collection("userschat").document(uid).setData(data).whenComplete((){


    });

    Navigator.push(context, MaterialPageRoute(builder: (context) => ChatBox()));
  }
  bool p=false;
  Future<FirebaseUser> _handleSignIn() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
    await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final FirebaseUser user = await _auth.signInWithCredential(credential);
    uid= user.uid;
    name= user.displayName;
    print("signed in " + user.displayName);
    return user;
  }
  void signOut()  async{

  }
  @override
  void initState() {
    // TODO: implement initState
    if(FirebaseAuth.instance.currentUser()!=null){

      Future.delayed(Duration(seconds:2 ),(){
        _googleSignIn.signOut();
        FirebaseAuth.instance.signOut();
      });
    }
    super.initState();
    _firebaseMessaging.getToken().then((token){
      mtoken=token;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Hero(tag: 'btn2', child: Container(
          color: Colors.white,

          child: Stack(


            children: <Widget>[
              Container(

              ),


              Column(
                children: <Widget>[
                  Expanded(child: Container(
                    color: Colors.transparent,

                  ),
                    flex: 8,


                  ),
                  Expanded(child: Container(
                    color: Colors.white30,
                    child: Center(
                      child:Container(
                        height: 100.0,

                        child:  Column(
                          children: <Widget>[
                            SignInButton(

                              Buttons.Google,
                              onPressed: () {


                                _handleSignIn()
                                    .then((FirebaseUser user) => routing())
                                    .catchError((e) => print(e));

                                setState(() {
                                  p=true;
                                });

                              },
                            ),
                            Container(child: p==true ? Center(child: CircularProgressIndicator(),):null ),

                          ],
                        ),
                      ),
                      /*RaisedButton(
                          onPressed: () {
                            _handleSignIn()
                                .then((FirebaseUser user) => routing())
                                .catchError((e) => print(e));
                          },
                          child: Text("click"),


                        )*/
                    ),

                  ),
                    flex: 2,


                  )

                ],

              ),




            ],
          ),
        )),
        onWillPop: null);
  }
}
