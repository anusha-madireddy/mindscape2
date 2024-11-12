// lib/screens/responses_screen.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ResponsesScreen extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Responses'),
        backgroundColor: Colors.blue,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('daily_responses')
            .where('userId', isEqualTo: _auth.currentUser?.uid)
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          var responses = snapshot.data!.docs;
          return ListView.builder(
            itemCount: responses.length,
            itemBuilder: (context, index) {
              var response = responses[index];
              var date = response['timestamp'].toDate();
              return ListTile(
                title: Text(response['response']),
                subtitle: Text(date.toString()),
              );
            },
          );
        },
      ),
    );
  }
}
