import 'dart:convert';
import 'package:crypto/crypto.dart';

class HashHelper {
  static String hash(String input){
    return sha256.convert(utf8.encode(input)).toString();
  }
}