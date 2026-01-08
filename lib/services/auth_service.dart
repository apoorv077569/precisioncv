import 'package:supabase_flutter/supabase_flutter.dart';
import 'hash_helper.dart';

class AuthService {
  final _db = Supabase.instance.client;

  Future<void> signup({
    required String name,
    required String email,
    required String password,
  }) async{
    final hash = HashHelper.hash(password);

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
  }
}