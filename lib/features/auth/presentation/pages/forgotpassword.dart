// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:http/http.dart' as http;
import 'package:miogra/features/auth/presentation/pages/signin.dart';
import 'package:miogra/features/auth/presentation/widgets/authwidgets.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  dynamic size, height, width;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();

  void sendPostRequestSignUp() async {
    const url = 'https://10.0.2.2:3000/endforget_password/';

    try {
      var request = http.MultipartRequest('POST', Uri.parse(url));

      // Populate form fields
      request.fields['email'] = _emailController.text;
      request.fields['password'] = _newPasswordController.text;

      var response = await request.send();

      if (response.statusCode == 200) {
        // Successfully posted data
        log('New Password Updated Successfully');

        // Show snackbar
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Password updated successfully'),
            duration: Duration(seconds: 2), // Adjust duration as needed
          ),
        );

        // Redirect to sign in page after a delay
        Future.delayed(const Duration(seconds: 2), () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SignInPage()),
          );
        });
      } else if (response.statusCode == 400) {
        // Error occurred while posting data, but it's expected
        log('Failed to post data: ${response.statusCode}');
      } else {
        // Handle other status codes if needed
        log('Unexpected status code: ${response.statusCode}');
      }
    } catch (e) {
      log('Exception while posting data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xffE29AD3),
                  Color(0xffFFF8E1),
                ],
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: Color.fromARGB(255, 137, 26, 119),
                ),
              ),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const LogoWidget(),
                  const SizedBox(height: 45),
                  SizedBox(
                    child: SizedBox(
                      width: 340,
                      child: EmailIdInputWidget(
                        controller: _emailController,
                      ),
                    ),
                  ),
                  SizedBox(
                    child: SizedBox(
                      width: 340,
                      child: NewPasswordInputWidget(
                        controller: _newPasswordController,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SubmitButton(
                        onPressed: () {
                          sendPostRequestSignUp();
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
