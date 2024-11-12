import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/firestore_service.dart';
import '../screens/recommendations_screen.dart';

class DailyQuestionScreen extends StatefulWidget {
  @override
  _DailyQuestionScreenState createState() => _DailyQuestionScreenState();
}

class _DailyQuestionScreenState extends State<DailyQuestionScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  String pssAnswer = '';
  String gadAnswer = '';
  String pssQuestion = '';
  String gadQuestion = '';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  void _loadQuestions() async {
    try {
      Map<String, String> questions = await _firestoreService.fetchQuestions();
      setState(() {
        pssQuestion = questions['pssQuestion']!;
        gadQuestion = questions['gadQuestion']!;
        isLoading = false;
      });
    } catch (e) {
      print("Error loading questions: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to load questions. Please try again.")),
      );
    }
  }

  void _submitAnswers() async {
    try {
      await _firestoreService.saveDailyResponses(pssAnswer, gadAnswer);

      List<String> stressRecommendations = await _firestoreService
          .fetchRecommendations('stress_recommendations');
      List<String> anxietyRecommendations = await _firestoreService
          .fetchRecommendations('anxiety_recommendations');

      List<String> combinedRecommendations = [
        ...stressRecommendations,
        ...anxietyRecommendations
      ];

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              RecommendationsScreen(recommendations: combinedRecommendations),
        ),
      );
    } catch (e) {
      print("Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to submit answers. Please try again.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Daily Questions')),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text(pssQuestion, style: TextStyle(fontSize: 18)),
                  TextField(
                    decoration: InputDecoration(labelText: 'PSS Answer'),
                    onChanged: (value) {
                      setState(() {
                        pssAnswer = value;
                      });
                    },
                  ),
                  SizedBox(height: 20),
                  Text(gadQuestion, style: TextStyle(fontSize: 18)),
                  TextField(
                    decoration: InputDecoration(labelText: 'GAD Answer'),
                    onChanged: (value) {
                      setState(() {
                        gadAnswer = value;
                      });
                    },
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _submitAnswers,
                    child: Text('Submit'),
                  ),
                ],
              ),
            ),
    );
  }
}
