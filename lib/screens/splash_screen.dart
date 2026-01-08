import 'package:flutter/material.dart';
import 'package:precisioncv/screens/upload_screen.dart';
import 'package:precisioncv/services/session_service.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>{
  @override
  void initState(){
    super.initState();
    Future.delayed(const Duration(seconds: 2),() async {
      final loggedIn = await SessionService.isLoggedIn();

      if(loggedIn){
        Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (_)=> const UploadScreen()),
        );
      }else{
        Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        );
      }
    });
  }
  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/icon/app_logo.png",
              width: 120,
            ),
            const SizedBox(height: 20),
            const Text(
              "PrecisonCV",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}