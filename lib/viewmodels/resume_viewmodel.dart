import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class ResumeViewmodel extends ChangeNotifier {
  File? _selectedFile;
  String? _errorMessage;

  File? get selectedFile => _selectedFile;
  String? get errorMessage => _errorMessage;

  static const int maxFileSize = 2*1024*1024;

  Future<void> pickResume() async{
    _errorMessage = null;

    final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
        withData: true,
    );
    if(result == null) return;
    final fileBytes = result.files.single.bytes;
    final filePath = result.files.single.path;

    if(fileBytes == null || filePath == null){
      _errorMessage = "Failed to read file";
      notifyListeners();
      return;
    }
    if(fileBytes.length > maxFileSize){
      _errorMessage = "File must be less than 2 MB";
      notifyListeners();
      return;
    }
    _selectedFile = File(filePath);
    notifyListeners();
  }
  void clear(){
    _selectedFile = null;
    _errorMessage = null;
    notifyListeners();
  }
}