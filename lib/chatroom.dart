
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class ChatRoom extends StatefulWidget {
  String uid;
  String pname;
  ChatRoom({
    Key key,
    @required this.uid,
    @required this.pname

}) : super(key:key);

  @override
  _ChatRoomState createState() => _ChatRoomState();
}


class _ChatRoomState extends State<ChatRoom> {
  final TextEditingController _textController = new TextEditingController();
  String myuid;
  String ppuid;
  String groupChatId;

  @override
  void initState() {
    ppuid=widget.uid;
    _getCurrentUserName();
    // TODO: implement initState
    super.initState();

  }

  void _handleSubmitted(String text) {
    _textController.clear();
    Map<String, String> data = <String, String>{
      "content": text,
       "from":myuid,
        "time":DateTime.now().toString()
    };
   Firestore.instance.collection("chat").document(groupChatId).collection(groupChatId).document().setData(data);

  }

  _getCurrentUserName() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    setState(() {
      myuid = user.uid;
    });
    if (myuid.hashCode <= widget.uid.hashCode) {
      groupChatId = '$myuid-$ppuid';
    } else {
      groupChatId = '$ppuid-$myuid';
    }
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: Text("ghgh"),
      ),
      body: Column(
        children: <Widget>[
          Expanded(flex: 9,child:StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance
          .collection('chat')
          .document(groupChatId)
           .collection(groupChatId)
          .orderBy('time', descending: true)
            .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError)
          return new Text('Error: ${snapshot.error}');
        switch (snapshot.connectionState) {
          case ConnectionState.waiting: return new Text('Loading...');
          default:
            return new ListView(
              reverse: true,
              children: snapshot.data.documents.map((DocumentSnapshot document) {
                if(myuid == document['from']) {


                  return new Column(

                   crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                  new ListTile(
                      contentPadding: EdgeInsets.only(left: 210),
                title: new Card(child: Text(document['content'],textAlign: TextAlign.right,
                ))),
                    ],



                    /*subtitle: new Text(document['content']),*/

                  );




                    /*subtitle: new Text(document['content']),*/


                }
                else{

                  return new ListTile(
                    contentPadding: EdgeInsets.only(right: 210),
                    title: new Card(child: Text(document['content'].toString().trimLeft(),textAlign: TextAlign.left,
                  )),
                    /*subtitle: new Text(document['content']),*/

                  );

                }

              }).toList(),
            );
        }
      },
    )


            ,),
          _buildTextComposer()


        ],
      )
    );
  }

  Widget _buildTextComposer() {
    return new Container(
      color: Theme.of(context).cardTheme.color,
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: new Row(
            children: <Widget>[
              new Flexible(
                child: new TextField(
                  controller: _textController,
                  onSubmitted: _handleSubmitted,
                  decoration: new InputDecoration.collapsed(
                      hintText: "Send a message"),
                ),
              ),
              new Container(
                margin: new EdgeInsets.symmetric(horizontal: 4.0),
                child: new IconButton(
                    icon: new Icon(Icons.send),
                    onPressed: () => _handleSubmitted(_textController.text)),
              ),
            ]
        )
    );
  }
}
/*const String _name = "Your Name";

class ChatMessage extends StatelessWidget {
  ChatMessage({this.text});
  final String text;
  @override
  Widget build(BuildContext context) {
    return new Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: new Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Container(
            margin: const EdgeInsets.only(right: 16.0),
            child: new CircleAvatar(child: new Text(_name[0])),
          ),
          new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new Text(_name, style: Theme.of(context).textTheme.subhead),
              new Container(
                margin: const EdgeInsets.only(top: 5.0),
                child: new Text(text),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ChatScreen extends StatefulWidget {
  @override
  State createState() => new ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> {
  final List<ChatMessage> _messages = <ChatMessage>[];
  final TextEditingController _textController = new TextEditingController();

  void _handleSubmitted(String text) {
    _textController.clear();
    ChatMessage message = new ChatMessage(
      text: text,
    );
    setState(() {
      _messages.insert(0, message);
    });
  }

  Widget _buildTextComposer() {
    return new Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: new Row(
            children: <Widget>[
              new Flexible(
                child: new TextField(
                  controller: _textController,
                  onSubmitted: _handleSubmitted,
                  decoration: new InputDecoration.collapsed(
                      hintText: "Send a message"),
                ),
              ),
              new Container(
                margin: new EdgeInsets.symmetric(horizontal: 4.0),
                child: new IconButton(
                    icon: new Icon(Icons.send),
                    onPressed: () => _handleSubmitted(_textController.text)),
              ),
            ]
        )
    );
  }

  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(title: new Text("Friendlychat")),
      body: new Column(
          children: <Widget>[
           Expanded(flex: 9,child:ListView() ,),
    _buildTextComposer()
          ]
      ),
    );
  }
}*/
