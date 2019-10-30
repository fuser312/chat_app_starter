import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController textController = TextEditingController();
  List<Widget> chatWidget = [];
  
  @override
  void initState() {
    textController.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  Future getMessages() async {
    QuerySnapshot messages =
        await Firestore.instance.collection('messages').getDocuments();
    FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();
    String currentUserEmail = currentUser.email;
    for (DocumentSnapshot message in messages.documents) {
      String text = message.data['text'];
      String sender = message.data['sender'];
      chatWidget.add(ChatBubble(
        text: text,
        sender: sender,
        color: sender == currentUserEmail ? Colors.green : Colors.white,
        rowAlignment: sender == currentUserEmail
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        colAlignment: sender == currentUserEmail
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(16.0),
          bottomRight: Radius.circular(16.0),
          topLeft: Radius.circular(16.0)))
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacementNamed(context, '/');
            },
          ),
          IconButton(
            icon: Icon(Icons.file_download),
            onPressed: () async {
              chatWidget.clear();
              await getMessages();
              setState(() {
                
              });
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
                child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: chatWidget,
              ),
            )),
            Divider(
              color: Colors.blue,
              height: 2,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                  height: 40,
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: TextField(
                    expands: false,
                    controller: textController,
                    autocorrect: false,
                    autofocus: false,
                    showCursor: false,
                    textAlign: TextAlign.center,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  disabledColor: Colors.grey,
                  color: Colors.blue,
                  onPressed: textController.text.isEmpty ? null : sendMessage,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void sendMessage() async {
    print(textController.text);
    FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();
    String currentUserEmail = currentUser.email;
    await Firestore.instance
        .collection('messages')
        .add({'sender': currentUserEmail, 'text': textController.text});
    textController.clear();
  }
}

class ChatBubble extends StatelessWidget {
  String text;
  String sender;
  Color color;
  MainAxisAlignment rowAlignment;
  CrossAxisAlignment colAlignment;
  ShapeBorder shape;
  ChatBubble(
      {this.text,
      this.sender,
      this.color,
      this.rowAlignment,
      this.colAlignment,
      this.shape});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Row(
        mainAxisAlignment: rowAlignment,
        children: <Widget>[
          Column(
            crossAxisAlignment: colAlignment,
            children: <Widget>[
              Text(
                sender,
                style: TextStyle(color: Colors.grey),
              ),
              Material(
                color: color,
                elevation: 5,
                shape: shape,
                child: Container(
                  padding: EdgeInsets.fromLTRB(8, 4, 8, 4),
                  child: Text(
                    text,
                    style: TextStyle(
                      fontSize: 16,
                    ),
                    softWrap: true,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}