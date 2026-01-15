// ignore_for_file: unnecessary_brace_in_string_interps

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:precisioncv/screens/resetpassword_screen.dart';
import 'package:precisioncv/services/auth_service.dart';

// class OtpVerificationScreen extends StatelessWidget {
//   final String email;
//   const OtpVerificationScreen({super.key,required this.email});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: const Color(0xFF1E3A5F),
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Colors.white),
//           onPressed: () {
//             Navigator.pop(context);
//           },
//         ),
//         title: const Text(
//           '8:38',
//           style: TextStyle(color: Colors.white, fontSize: 14),
//         ),
//         centerTitle: false,
//       ),
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 24.0),
//           child: Column(
//             children: [
//               const SizedBox(height: 40),
//               // LOGO
//               Container(
//                 width: 80,
//                 height: 80,
//                 decoration: BoxDecoration(
//                   color: const Color(0xFF1E3A5F),
//                   borderRadius: BorderRadius.circular(20),
//                 ),
//                 child: Image.asset("assets/icon/app_logo.png", width: 120),
//               ),
//               const SizedBox(height: 32),
//               // TITLE
//               const Text(
//                 'We just sent an Email',
//                 style: TextStyle(
//                   fontSize: 22,
//                   fontWeight: FontWeight.bold,
//                   color: Color(0xFF1A1A1A),
//                 ),
//               ),
//               const SizedBox(height: 12),
//               // SUBTITLE
//               const Text(
//                 'Enter the security code we sent to',
//                 textAlign: TextAlign.center,
//                 style: TextStyle(fontSize: 14, color: Color(0xFF666666)),
//               ),
//               const SizedBox(height: 4),
//               // EMAIL
//               Text(
//                email,
//                 textAlign: TextAlign.center,
//                 style: TextStyle(fontSize: 14, color: Color(0xFF666666)),
//               ),
//               const SizedBox(height: 32),
//               // OTP BOXES
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   _buildOtpBox(),
//                   const SizedBox(width: 16),
//                   _buildOtpBox(),
//                   const SizedBox(width: 16),
//                   _buildOtpBox(),
//                   const SizedBox(width: 16),
//                   _buildOtpBox(),
//                 ],
//               ),
//               const SizedBox(height: 32),
//               // VERIFY BUTTON
//               SizedBox(
//                 width: 150,
//                 height: 56,
//                 child: ElevatedButton(
//                   onPressed: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (_) => const ResetpasswordScreen(),
//                       ),
//                     );
//                   },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: const Color(0xFF1E3A5F),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     elevation: 0,
//                   ),
//                   child: const Text(
//                     'VERIFY',
//                     style: TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.white,
//                       letterSpacing: 1.2,
//                     ),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 16),
//               // RESEND TEXT
//               const Text(
//                 "Didn't receive code?",
//                 style: TextStyle(fontSize: 14, color: Color(0xFF666666)),
//               ),
//               const SizedBox(height: 4),
//               const Text(
//                 'Resend - 00:42',
//                 style: TextStyle(fontSize: 14, color: Color(0xFF666666)),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildOtpBox() {
//     return Container(
//       width: 56,
//       height: 56,
//       decoration: BoxDecoration(
//         color: const Color(0xFFF5F5F5),
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: TextField(
//         textAlign: TextAlign.center,
//         keyboardType: TextInputType.number,
//         maxLength: 1,
//         style: const TextStyle(
//           fontSize: 24,
//           fontWeight: FontWeight.bold,
//           color: Color(0xFF1A1A1A),
//         ),
//         decoration: const InputDecoration(
//           counterText: '',
//           border: InputBorder.none,
//         ),
//         inputFormatters: [FilteringTextInputFormatter.digitsOnly],
//       ),
//     );
//   }
// }

class OtpVerificationScreen extends StatefulWidget{

  final String email;
  const OtpVerificationScreen({super.key,required this.email});

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen>{
  final _authService = AuthService();

  final List<TextEditingController> _controllers = 
      List.generate(4, (_)=> TextEditingController());

  bool _isLoading = false;

  String get _otp => _controllers.map((controller) => controller.text).join();

  Future<void> _verifyOtp() async{
    if(_otp.length != 4){
      _showError("Please enter valid OTP");
      return;
    }
    setState(() => _isLoading = true);
    try{
      await _authService.verifyOtp(widget.email, _otp);
      if(!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder:(_) => ResetpasswordScreen(email:widget.email),
        ),
      );
    }catch(e){
      _showError(e.toString().replaceAll("Exception", ""));
    }finally{
      if(mounted) setState(() => _isLoading = false);
    }
  }
  void _showError(String message){
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content:Text(message)),
    );
  }
  @override
  void dispose(){
    for(final c in _controllers){
      c.dispose();
    }
    super.dispose();
  }
  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E3A5F),
        elevation: 0,
        leading: BackButton(color: Colors.white),
        title: const Text("Verify OTP",style: TextStyle(fontSize: 14)),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            const SizedBox(height: 40),
            Image.asset("assets/icon/app_logo.png",width: 80),
            const SizedBox(height: 24),
            const Text(
              'Enter verification code',
              style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                4,
                (index) => _buildOtpBox(index),
                ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _verifyOtp,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E3A5F),
                  shape:RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isLoading
                ?const CircularProgressIndicator(color: Colors.white)
                :const Text("Verify"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOtpBox(int index){
    return Container(
      width: 56,
      height: 56,
      margin: const EdgeInsets.symmetric(horizontal: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextField(
        controller: _controllers[index],
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        style: const TextStyle(fontSize: 22,fontWeight: FontWeight.bold),
        decoration: const InputDecoration(
          counterText: '',
          border: InputBorder.none,
        ),
        onChanged: (value){
          if(value.isNotEmpty && index < 3){
            FocusScope.of(context).nextFocus();
          }
        },
      ),
    );
  }
}