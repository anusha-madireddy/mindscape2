import 'package:flutter/material.dart';
import '../services/question_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class QuestionScreen extends StatefulWidget {
  @override
  _QuestionScreenState createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen> {
  final QuestionService _questionService = QuestionService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  List<String> _questions = [];
  List<int> _responses = [];
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  void _loadQuestions() async {
    List<String> questions = await _questionService.fetchPSSQuestions();
    setState(() {
      _questions = questions;
      _responses =
          List.filled(questions.length, 0); // Initialize responses with 0
    });
  }

  int _calculatePSSScore() {
    int score = 0;
    for (int i = 0; i < _responses.length; i++) {
      // Adjust scoring based on reverse coding for specific questions
      if (i == 3 || i == 4 || i == 6) {
        score += 4 - _responses[i]; // Reverse score for questions 4, 5, and 7
      } else {
        score += _responses[i];
      }
    }
    return score;
  }

  void _submitResponses() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        int score = _calculatePSSScore();
        await _firestore.collection('responses').doc(user.uid).set({
          'responses': _responses,
          'score': score,
          'timestamp': FieldValue.serverTimestamp(),
        });
        setState(() {
          _errorMessage = 'Responses submitted successfully';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to submit responses: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Questions'),
        backgroundColor: Colors.blue,
      ),
      body: _questions.isEmpty
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: <Widget>[
                  ..._questions.asMap().entries.map((entry) {
                    int index = entry.key;
                    String question = entry.value;
                    return Card(
                      child: ListTile(
                        title: Text(question),
                        subtitle: DropdownButton<int>(
                          value: _responses[index],
                          items: List.generate(5, (i) => i).map((int value) {
                            return DropdownMenuItem<int>(
                              value: value,
                              child: Text(value.toString()),
                            );
                          }).toList(),
                          onChanged: (int? newValue) {
                            setState(() {
                              _responses[index] = newValue!;
                            });
                          },
                        ),
                      ),
                    );
                  }).toList(),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _submitResponses,
                    child: Text('Submit Responses'),
                  ),
                  SizedBox(height: 20),
                  Text(
                    _errorMessage,
                    style: TextStyle(color: Colors.red),
                  ),
                ],
              ),
            ),
    );
  }
}
