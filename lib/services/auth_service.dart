import 'dart:convert';

import 'package:precisioncv/services/session_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'hash_helper.dart';
import 'package:uuid/uuid.dart'; 
import 'package:http/http.dart' as http;

class AuthService {
  final _db = Supabase.instance.client;
  // ignore: constant_identifier_names
  static const BASE_URL = "https://precisioncv-backend.onrender.com";

  Future<void> signup({
    required String name,
    required String email,
    required String password,
  }) async{
    final hash = HashHelper.hash(password);
    final uuid = const Uuid().v4();
    
    final exists = await _db
    .from('profiles')
    .select()
    .eq('email', email)
    .maybeSingle();

    if(exists != null){
      throw Exception("User already exist");
    }
    await _db.from('profiles')
    .insert({
      'id': uuid,
      'name':name,
      'email':email,
      'password':hash,
    });
  }

  Future<void> login({
    required String email,
    required String password,
  })async{
    final hash = HashHelper.hash(password);

    final user = await _db
    .from('profiles')
    .select()
    .eq('email', email)
    .eq('password', hash)
    .maybeSingle();

    if(user == null){
      throw Exception("Insert email or password");
    }
    // save session
    await SessionService.saveSession(
      email: user['email'],
      name: user['name'],
    );
  }

  Future<void> sendOtp(String email) async{
    final response = await http.post(
      Uri.parse("$BASE_URL/api/auth/send-otp"),
      headers: {"Content-Type":"application/json"},
      body: jsonEncode({"email":email}),
    );
    if(response.statusCode != 200){
      throw Exception(jsonDecode(response.body)["message"]);
    }
  }

  Future<void> verifyOtp(String email,String otp) async{
    final response = await http.post(
      Uri.parse("$BASE_URL/api/auth/verify-otp"),
      headers: {"Content-Type":"application/json"},
      body: jsonEncode({
        "email":email,
        "otp":otp
      }),
    );
    if(response.statusCode != 200){
      throw Exception(jsonDecode(response.body)["message"]);
    }
  }

  Future<void> resetPassword(String email,String newPassword) async{
    final response = await http.post(
      Uri.parse("$BASE_URL/api/auth/reset-password"),
      headers: {"Content-Type":"application/json"},
      body: jsonEncode({
        "email":email,
        "new_password":newPassword,
      }),
    );
    if(response.statusCode != 200){
      throw Exception(jsonDecode(response.body)["message"]);
    }
  }
}