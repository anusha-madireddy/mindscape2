// results_screen.dart

import 'package:flutter/material.dart';

class ResultsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, int>;
    final pssScore = args['pssScore']!;
    final gadScore = args['gadScore']!;

    return Scaffold(
      appBar: AppBar(
        title: Text('Results'),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'PSS Score: $pssScore',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            Text(
              'GAD-7 Score: $gadScore',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Go Back'),
            ),
          ],
        ),
      ),
    );
  }
}
