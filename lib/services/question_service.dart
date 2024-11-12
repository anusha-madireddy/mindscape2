import 'package:cloud_firestore/cloud_firestore.dart';

class QuestionService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<String>> fetchPSSQuestions() async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection('questions').doc('pss').get();
      List<dynamic> questions = doc['questions'];
      return questions.cast<String>();
    } catch (e) {
      print('Error fetching questions: $e');
      return [];
    }
  }
}
