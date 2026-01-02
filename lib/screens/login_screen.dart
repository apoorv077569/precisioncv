import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:precisioncv/screens/signup_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'upload_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final email = TextEditingController();
    final password = TextEditingController();
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.description,
              size: 70,
              color: Theme.of(context).colorScheme.primary,
            ),

            const SizedBox(height: 16),

            const Text(
              "ATS Resume Analyzer",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 30),

            TextField(
             controller: email,
              obscureText: false,
              decoration: InputDecoration(
                labelText: "Email",
                prefixIcon: const Icon(Icons.mail),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              )
            ),

            const SizedBox(height: 16),

            TextField(
              controller: password,
              obscureText: true,
              decoration: InputDecoration(
                labelText: "Password",
                prefixIcon: const Icon(Icons.lock),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              )
            ),
            const SizedBox(height: 5),
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                "Forget Password",
                style: TextStyle(color: Colors.blueAccent),
              ),
            ),
            const SizedBox(height: 24),

            FilledButton(
              onPressed: () async {
                try{
                await Supabase.instance.client.auth.signInWithPassword(
                  email: email.text.trim(),
                  password: password.text.trim(),
                );
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const UploadScreen()),
                );
                }catch(_){
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Login Failed")),
                  );
                }
              },
              child: const Text("Login"),
            ),
            const SizedBox(height: 40),
            Container(
              alignment: Alignment.center,
              child: RichText(
                text: TextSpan(
                  text: "Don't have an account? ",
                  style: TextStyle(color: Colors.black), // Normal text color
                  children: [
                    TextSpan(
                      text: "Signup",
                      style: TextStyle(
                        color: Colors.blueAccent,
                        fontWeight: FontWeight.bold, // Optional
                      ),
                      recognizer:
                          TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const SignupScreen(),
                                ),
                              );
                            },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
