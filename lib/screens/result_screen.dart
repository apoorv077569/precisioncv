import 'package:flutter/material.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Analysis Result")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: const [
                    Text("ATS SCORE",
                        style: TextStyle(fontSize: 16)),
                    SizedBox(height: 8),
                    Text(
                      "82%",
                      style: TextStyle(
                        fontSize: 42,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            const ListTile(
              leading: Icon(Icons.check_circle, color: Colors.green),
              title: Text("Skills section optimized"),
            ),

            const ListTile(
              leading: Icon(Icons.cancel, color: Colors.red),
              title: Text("Missing REST API keyword"),
            ),

            const ListTile(
              leading: Icon(Icons.cancel, color: Colors.red),
              title: Text("Add quantified achievements"),
            ),
          ],
        ),
      ),
    );
  }
}
