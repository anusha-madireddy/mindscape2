import 'package:flutter/material.dart';

class RecommendationsScreen extends StatelessWidget {
  final List<String> recommendations;

  RecommendationsScreen({required this.recommendations});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Recommendations')),
      body: ListView.builder(
        itemCount: recommendations.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(recommendations[index]),
          );
        },
      ),
    );
  }
}
