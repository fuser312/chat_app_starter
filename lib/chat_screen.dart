import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController textController = TextEditingController();
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
              Navigator.pushNamed(context, '/');
            },
          ),
          IconButton(
            icon: Icon(Icons.file_download),
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
            child: Row(
            children: <Widget>[
                Flexible(
                  flex: 8,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(borderSide: BorderSide(color: Color(0xFF4790F1), width: 1)),
                    ),
                    controller: textController,
                    showCursor: true,
                    autofocus: true,
                  ),
                ),
                ),
                
              Flexible(
                flex: 3,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: RaisedButton(
                    
                    onPressed: () {
                      print('I was clicked.');
                    },
                    child: Text("Send",
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 16,
                          )
                          ),
                      ),
                  ),
              )
          ],
          ),
        
      ),
      );
    
  }
}