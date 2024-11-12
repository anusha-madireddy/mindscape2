import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> saveDailyResponses(String pssAnswer, String gadAnswer) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        String userId = user.uid;
        String date = DateFormat('yyyy-MM-dd').format(DateTime.now());

        await _db.collection('daily_responses').doc('${userId}_$date').set({
          'userId': userId,
          'date': date,
          'pssAnswer': pssAnswer,
          'gadAnswer': gadAnswer,
        });
      } else {
        throw Exception("User not logged in");
      }
    } catch (e) {
      print("Error saving daily responses: $e");
      rethrow;
    }
  }

  Future<List<String>> fetchRecommendations(String collectionName) async {
    try {
      QuerySnapshot querySnapshot = await _db.collection(collectionName).get();
      List<String> recommendations = querySnapshot.docs.map((doc) {
        return doc['recommendation'] as String;
      }).toList();
      return recommendations;
    } catch (e) {
      print("Error fetching recommendations: $e");
      rethrow;
    }
  }

  Future<Map<String, String>> fetchQuestions() async {
    try {
      DocumentSnapshot pssDoc =
          await _db.collection('questions').doc('pss').get();
      DocumentSnapshot gadDoc =
          await _db.collection('questions').doc('gad').get();

      if (!pssDoc.exists || !gadDoc.exists) {
        throw Exception("Document does not exist");
      }

      Map<String, dynamic>? pssData = pssDoc.data() as Map<String, dynamic>?;
      Map<String, dynamic>? gadData = gadDoc.data() as Map<String, dynamic>?;

      if (pssData == null ||
          !pssData.containsKey('question') ||
          gadData == null ||
          !gadData.containsKey('question')) {
        throw Exception("Field 'question' does not exist");
      }

      Map<String, String> questions = {
        'pssQuestion': pssData['question'],
        'gadQuestion': gadData['question'],
      };

      return questions;
    } catch (e) {
      print("Error fetching questions: $e");
      rethrow;
    }
  }
}
