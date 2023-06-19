import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Chat {
  final String senderName;
  final String message;
  final bool isMe;

  Chat({required this.senderName, required this.message, required this.isMe});
}

class ChatPage extends StatelessWidget {
  final List<Chat> chats = [
    Chat(senderName: 'John', message: 'Hello!', isMe: true),
    Chat(senderName: 'Jane', message: 'Hi there!', isMe: false),
    // Add more chat messages here
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Community CU'),
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.green,
          statusBarIconBrightness: Brightness.dark,
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(16.0),
              itemCount: chats.length,
              itemBuilder: (context, index) {
                return ChatBubble(
                  chat: chats[index],
                );
              },
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    // Implement send message logic here
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ChatBubble extends StatelessWidget {
  final Chat chat;

  ChatBubble({required this.chat});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.0),
      alignment: chat.isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        decoration: BoxDecoration(
          color: chat.isMe ? Colors.blue : Colors.grey[300],
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              chat.senderName,
              style: TextStyle(
                fontSize: 12.0,
                fontWeight: FontWeight.bold,
                color: chat.isMe ? Colors.white : Colors.black,
              ),
            ),
            SizedBox(height: 4.0),
            Text(
              chat.message,
              style: TextStyle(
                color: chat.isMe ? Colors.white : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
