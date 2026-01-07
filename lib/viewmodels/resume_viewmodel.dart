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

  bool isValidResume = false;
  String resumeValidationMessage = "";

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
        data: kIsWeb ? Stream.value(selectedBytes!) : selectedFile!.openRead(),
        options: Options(headers: {'Content-Type': 'application/pdf'}),
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
    atsScore = 0;
    int structureScore = 0;
    int formattingScore = 0;
    int fileQualityScore = 0;

    if (!validateResume()) {
      atsFeedback = resumeValidationMessage;
      notifyListeners();
      return;
    }

    // resume validation
    atsScore += 20;
    int size = 0;
    if (selectedBytes != null) {
      size = selectedBytes!.length;
    } else if (selectedFile != null) {
      size = selectedFile!.lengthSync();
    }

    if (size >= 100 * 1024 && size <= 600 * 1024) {
      structureScore = 25;
    } else if (size <= 900 * 1024) {
      structureScore = 18;
    } else {
      structureScore = 10;
    }
    atsScore += structureScore;

    if (size <= 700 * 1024) {
      formattingScore = 25;
    } else {
      formattingScore = 15;
    }
    atsScore += formattingScore;

    final name = fileName!.toLowerCase();

    if (name.contains('resume') || name.contains('cv')) {
      fileQualityScore = 30;
    } else {
      fileQualityScore = 20;
    }
    atsScore += fileQualityScore;

    // cap score
    atsScore = atsScore.clamp(0, 100);

    if (atsScore >= 85) {
      atsFeedback = "Excellent ATS-Friendly resume";
    } else if (atsScore >= 70) {
      atsFeedback = "Good Resume, minor ATS improvement recommended";
    } else if (atsScore >= 50) {
      atsFeedback = "Average resume, needs optimization";
    } else {
      atsFeedback = "Poor ATS compatibility - revise resume";
    }
    notifyListeners();
  }

  bool validateResume() {
    if (fileName == null) {
      resumeValidationMessage = "No file selected";
      return false;
    }
    final name = fileName!.toLowerCase();

    final resumeKeyWords = [
      'resume',
      'cv',
      'curriculum',
      'profile',
      'bio',
      'bio_data',
      'bio-data',
    ];

    final containsResumeKeyword = resumeKeyWords.any((k) => name.contains(k));

    if (!containsResumeKeyword) {
      resumeValidationMessage = "Upload file does not look like a resume";
      return false;
    }
    int size = 0;
    if (selectedBytes != null) {
      size = selectedBytes!.length;
    } else if (selectedFile != null) {
      size = selectedFile!.lengthSync();
    }
    if (size < 50 * 1024 || size > 2 * 1024 * 1024) {
      resumeValidationMessage = "File size is not typical for a resume";
      return false;
    }
    resumeValidationMessage = "valid resume detected";
    isValidResume = true;
    return true;
  }
}
