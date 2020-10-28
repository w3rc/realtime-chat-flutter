import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:realtime_chat_app/widgets/chats/message_bubble.dart';

class Chats extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FirebaseAuth.instance.currentUser(),
      builder: (ctx, futureSnapshot) {
        if (futureSnapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return StreamBuilder(
          stream: Firestore.instance
              .collection('chat')
              .orderBy('createdAt', descending: true)
              .snapshots(),
          builder: (ctx, streamSnapshot) {
            if (streamSnapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            final messages = streamSnapshot.data.documents;
            return ListView.builder(
              reverse: true,
              itemCount: messages.length,
              itemBuilder: (ctx, index) => Container(
                padding: EdgeInsets.all(8.0),
                child: MessageBubble(
                  messages[index]['text'],
                  messages[index]['userId'] == futureSnapshot.data.uid,
                  messages[index]['username'],
                  key: ValueKey(messages[index].documentID),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
