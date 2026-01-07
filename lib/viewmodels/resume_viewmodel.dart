import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

enum UploadStatus { idle, uploading, success, error }

class ResumeViewModel extends ChangeNotifier {
  File? selectedFile; // Mobile
  Uint8List? selectedBytes; // Web
  String? fileName;
  bool readyToUpload = false;

  int atsScore = 0;
  String atsFeedback = " ";

  String? errorMessage;

  bool isUploading = false;
  double uploadProgress = 0.0;
  UploadStatus uploadStatus = UploadStatus.idle;

  static const int maxFileSize = 2 * 1024 * 1024; // 2MB

  /// 📄 Pick resume (Web + Mobile safe)
  Future<void> pickResume() async {
    errorMessage = null;

    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
      withData: kIsWeb,
    );

    if (result == null) return;

    final pickedFile = result.files.single;

    // File size check
    if (pickedFile.size > maxFileSize) {
      errorMessage = "File size must be under 2MB";
      notifyListeners();
      return;
    }

    fileName = pickedFile.name;

    if (kIsWeb) {
      selectedBytes = pickedFile.bytes;
      selectedFile = null;
    } else {
      selectedFile = File(pickedFile.path!);
      selectedBytes = null;
    }

    readyToUpload = true; // ✅ MARK READY, DO NOT UPLOAD
    notifyListeners();
  }

Future<void> uploadResume() async {
  try {
    if (!readyToUpload || isUploading) return;

    errorMessage = null;
    isUploading = true;
    uploadProgress = 0.0;
    uploadStatus = UploadStatus.uploading;
    notifyListeners();

    final supabase = Supabase.instance.client;
    final user = supabase.auth.currentUser;

    if (user == null) {
      throw Exception("User not logged in");
    }

    final filePath =
        '${user.id}/resume_${DateTime.now().millisecondsSinceEpoch}.pdf';

    // 1️⃣ Get signed upload URL
    final signedResponse = await supabase.storage
        .from('resume')
        .createSignedUploadUrl(filePath);

    final dio = Dio();

    // 2️⃣ Upload ONLY ONCE using PUT
    await dio.put(
      signedResponse.signedUrl,
      data: kIsWeb
          ? Stream.value(selectedBytes!)
          : selectedFile!.openRead(),
      options: Options(
        headers: {'Content-Type': 'application/pdf'},
      ),
      onSendProgress: (sent, total) {
        if (total > 0) {
          uploadProgress = sent / total;
          notifyListeners();
        }
      },
    );


    isUploading = false;
    readyToUpload = false;
    uploadStatus = UploadStatus.success;
    notifyListeners();
  } catch (e) {
    isUploading = false;
    uploadStatus = UploadStatus.error;
    errorMessage = e.toString();
    notifyListeners();
  }
}


  void calculateAtsScore() {
    int score = 0;
    if (fileName != null) {
      score += 20;
    }
    if (selectedBytes != null) {
      if (selectedBytes!.length < 1024 * 1024) {
        score += 20;
      }
    } else if (selectedFile != null) {
      final size = selectedFile!.lengthSync();
      if (size < 1024 * 1024) {
        score += 20;
      }
    }
    // keyword match
    score += 30;

    // formatting score
    score += 30;

    atsScore += score;

    if(score >= 80){
      atsFeedback = "Excellent Resume ";
    }else if(score >=60){
      atsFeedback = "Good Resume, minor improvemets needed";
    }else{
      atsFeedback = "Resume needs improvements";
    }
    notifyListeners();
  }
}
