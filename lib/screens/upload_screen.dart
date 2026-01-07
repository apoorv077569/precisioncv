import 'package:flutter/material.dart';
import 'package:precisioncv/screens/result_screen.dart';
import 'package:provider/provider.dart';
import '../viewmodels/resume_viewmodel.dart';

class UploadScreen extends StatelessWidget {
  const UploadScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ResumeViewModel>();

    // 🔔 SnackBar listener (fires once per state change)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // upload success 
      if (vm.uploadStatus == UploadStatus.success) {
        vm.calculateAtsScore();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Resume uploaded successfully")),
        );
        vm.uploadStatus = UploadStatus.idle;

        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const ResultScreen()),
        );
      }
      if(vm.uploadStatus == UploadStatus.error){
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(vm.errorMessage??"Upload Failed"),
          ),
        );
        vm.uploadStatus = UploadStatus.idle;
      }
    });

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

            // 📄 File picker card
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: vm.isUploading ? null : vm.pickResume,
                child: SizedBox(
                  height: 160,
                  child: Center(
                    child:
                        vm.fileName == null
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
                                Text(vm.fileName!, textAlign: TextAlign.center),
                              ],
                            ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // 📊 Upload progress
            if (vm.isUploading) ...[
              LinearProgressIndicator(value: vm.uploadProgress),
              const SizedBox(height: 8),
              Text(
                "Uploading ${(vm.uploadProgress * 100).toStringAsFixed(0)}%",
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
            ],

            // ☁️ Upload button (STRICTLY CONTROLLED)
            FilledButton.icon(
              onPressed:
                  vm.readyToUpload && !vm.isUploading
                      ? () {
                        vm.uploadResume(); // ✅ ONLY upload trigger
                      }
                      : null,
              icon: const Icon(Icons.cloud_upload),
              label: const Text("Check Score"),
            ),
          ],
        ),
      ),
    );
  }
}
