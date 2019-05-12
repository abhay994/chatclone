import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'chatroom.dart';
class ChatBox extends StatefulWidget {
  @override
  _ChatBoxState createState() => _ChatBoxState();
}

class _ChatBoxState extends State<ChatBox> {
  String name;

  @override
  void initState() {
    _getCurrentUserName();

    // TODO: implement initState
    super.initState();
  }
  _getCurrentUserName() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    setState(() {
      name= user.displayName;
    });

    print(name);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection('userschat').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) return new Text('Error: ${snapshot.error}');
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return new Text('Loading...');
            default:
              return new OrientationBuilder(builder: (context, orientation) {
                return new GridView.count(
                  primary: false,
                  crossAxisCount: orientation == Orientation.portrait ? 2 : 4,
                  mainAxisSpacing: 0.0,
                  crossAxisSpacing: 0.0,
                  children:
                  snapshot.data.documents.map((DocumentSnapshot document) {
                    String name = document['name'].toString();
                    String uid= document['uid'].toString();

                    return InkWell(
                      onTap: () {
                       Navigator.push(context, MaterialPageRoute(
                           builder: (context) => ChatRoom(uid: uid,pname: name,)));
                      },
                      child: Card(
                          child: Column(
                            children: <Widget>[

                              Expanded(child: Container(

                                child:  Padding(padding: EdgeInsets.all(5),
                                  child: Row(
                                    children: <Widget>[
                                      Text(name)
                                    ],
                                  ),



                                ),
                              ),
                                flex: 2,
                              )

                            ],
                          )),
                    );
                  }).toList(),
                );
              });
          }
        },
      ),
    );
  }
}
