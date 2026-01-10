import 'package:flutter/material.dart';
import 'package:precisioncv/screens/otp_verification_screen.dart';

class ForgetPassword extends StatelessWidget {
  const ForgetPassword({super.key});

  @override
  Widget build(BuildContext context) {
    final email = TextEditingController();

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/icon/app_logo.png", width: 100),

            const SizedBox(height: 16),
            const Text(
              "PrecisionCV",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 1),
            const Text(
              "Reset Password",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
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
              ),
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const OtpVerificationScreen(),
                  ),
                );
              },
              child: const Text("Send Email"),
            ),
          ],
        ),
      ),
    );
  }
}
