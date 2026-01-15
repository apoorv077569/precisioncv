// import 'package:flutter/material.dart';
// import 'package:precisioncv/services/auth_service.dart';

// class ResetpasswordScreen extends StatelessWidget {
//   const ResetpasswordScreen({super.key, required String email});

//   @override
//   Widget build(BuildContext context) {
//     final newPassword = TextEditingController();
//     final confirmNewPassword = TextEditingController();

//     return Scaffold(
//       body: Padding(
//         padding: const EdgeInsets.all(24),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Image.asset("assets/icon/app_logo.png", width: 100),
//             const SizedBox(height: 16),
//             const Text(
//               "PrecisonCV",
//               style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 5),
//             const Text(
//               "Reset Password",
//               style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
//             ),
//             const SizedBox(height: 30),
//             TextField(
//               controller: newPassword,
//               obscureText: true,
//               decoration: InputDecoration(
//                 labelText: "New Password",
//                 prefixIcon: const Icon(Icons.lock),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 16),
//             TextField(
//               controller: confirmNewPassword,
//               obscureText: true,
//               decoration: InputDecoration(
//                 prefixIcon: const Icon(Icons.lock),
//                 labelText: "Confirm New Password",
//                 prefix: const Icon(Icons.lock),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 24),
//             FilledButton(onPressed: () {}, child: Text("Reset Password")),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:precisioncv/services/auth_service.dart';

class ResetpasswordScreen extends StatelessWidget {
  final String email;

  const ResetpasswordScreen({
    super.key,
    required this.email,
  });

  @override
  Widget build(BuildContext context) {
    final newPassword = TextEditingController();
    final confirmNewPassword = TextEditingController();
    final authService = AuthService();

    Future<void> resetPassword() async {
      final password = newPassword.text.trim();
      final confirm = confirmNewPassword.text.trim();

      if (password.length < 6) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Password must be at least 6 characters")),
        );
        return;
      }

      if (password != confirm) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Passwords do not match")),
        );
        return;
      }

      try {
        await authService.resetPassword(email, password);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Password reset successful")),
        );

        // Go back to login screen
        Navigator.popUntil(context, (route) => route.isFirst);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString().replaceAll("Exception:", "")),
          ),
        );
      }
    }

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/icon/app_logo.png", width: 100),

            const SizedBox(height: 16),
            const Text(
              "PrecisionCV",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            const Text(
              "Reset Password",
              style: TextStyle(fontSize: 14),
            ),

            const SizedBox(height: 30),

            TextField(
              controller: newPassword,
              obscureText: true,
              decoration: InputDecoration(
                labelText: "New Password",
                prefixIcon: const Icon(Icons.lock),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 16),

            TextField(
              controller: confirmNewPassword,
              obscureText: true,
              decoration: InputDecoration(
                labelText: "Confirm New Password",
                prefixIcon: const Icon(Icons.lock),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              height: 48,
              child: FilledButton(
                onPressed: resetPassword,
                child: const Text("Reset Password"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
