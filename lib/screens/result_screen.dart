import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/resume_viewmodel.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ResumeViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Analysis Result"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 🔢 ATS SCORE CARD
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    const Text(
                      "ATS SCORE",
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "${vm.atsScore}%",
                      style: TextStyle(
                        fontSize: 42,
                        fontWeight: FontWeight.bold,
                        color: _scoreColor(vm.atsScore),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      vm.atsFeedback,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // 📌 IMPROVEMENT SUGGESTIONS
            const Text(
              "Improvement Suggestions",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            Expanded(
              child: vm.improvementSuggestions.isEmpty
                  ? const Center(
                      child: Text(
                        "No major issues found 🎉",
                        style: TextStyle(color: Colors.green),
                      ),
                    )
                  : ListView.builder(
                      itemCount: vm.improvementSuggestions.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading: const Icon(
                            Icons.info_outline,
                            color: Colors.orange,
                          ),
                          title: Text(vm.improvementSuggestions[index]),
                        );
                      },
                    ),
            ),

            const SizedBox(height: 12),

            FilledButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Analyze Another Resume"),
            ),
          ],
        ),
      ),
    );
  }

  /// 🎨 Score-based color
  Color _scoreColor(int score) {
    if (score >= 80) return Colors.green;
    if (score >= 60) return Colors.orange;
    return Colors.red;
  }
}
