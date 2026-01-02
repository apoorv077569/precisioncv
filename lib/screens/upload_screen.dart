import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/resume_viewmodel.dart';
import 'result_screen.dart';

class UploadScreen extends StatelessWidget {
  const UploadScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ResumeViewmodel>();

    return Scaffold(
      appBar: AppBar(title: const Text("Upload Resume")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              "Upload your resume (PDF)",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 16),

            if (vm.errorMessage != null)
              Text(
                vm.errorMessage!,
                style: const TextStyle(color: Colors.red),
              ),

            const SizedBox(height: 16),

            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: vm.pickResume,
                child: SizedBox(
                  height: 160,
                  child: Center(
                    child: vm.selectedFile == null
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(Icons.upload_file, size: 40),
                              SizedBox(height: 10),
                              Text("Tap to select PDF (Max 2MB)"),
                            ],
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.picture_as_pdf,
                                size: 40,
                                color: Colors.red,
                              ),
                              const SizedBox(height: 10),
                              Text(
                                vm.selectedFile!.path.split('/').last,
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),

            FilledButton.icon(
              onPressed: vm.selectedFile == null
                  ? null
                  : () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ResultScreen(),
                        ),
                      );
                    },
              icon: const Icon(Icons.analytics),
              label: const Text("Analyze Resume"),
            ),
          ],
        ),
      ),
    );
  }
}
