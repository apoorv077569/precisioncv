import 'package:flutter/material.dart';
import 'package:precisioncv/screens/login_screen.dart';
import 'package:precisioncv/viewmodels/resume_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://yfpfvygosglyfhueohyr.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InlmcGZ2eWdvc2dseWZodWVvaHlyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjczNzIwMjMsImV4cCI6MjA4Mjk0ODAyM30.pSaC2pDqTWmRGyqdqk2ZZ7hAYaV4deZl1asbSBtUzjM'
    );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_)=>ResumeViewmodel(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'ATS Resume Analyzer',
        theme: ThemeData(
          useMaterial3: true,
          colorSchemeSeed: Colors.blue,
        ),
        home: const LoginScreen(),
      ),

    );
  }
}

