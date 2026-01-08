import 'package:shared_preferences/shared_preferences.dart';

class SessionService {
  static const _keyLoggedIn = 'is_logged_in';
  static const _keyEmail = 'user_email';
  static const _keyName = 'user_name';

  static Future<void> saveSession({
    required String email,
    required String name,
  })async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyLoggedIn, true);
    await prefs.setString(_keyEmail, email);
    await prefs.setString(_keyName, name);
  }
  // check login status 
  static Future<bool> isLoggedIn() async{
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyLoggedIn)?? false;
  }
  // get user data
  static Future<Map<String,String>> getUser() async{
    final prefs = await SharedPreferences.getInstance();
    return{
      'email':prefs.getString(_keyEmail) ?? '',
      'name':prefs.getString(_keyName) ?? '',
    };
  }
  static Future<void> clearSession() async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}