// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:flutter/material.dart';

// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'package:miogra/core/api_services.dart';
import 'package:miogra/features/auth/presentation/pages/otpsuccess.dart';
import 'package:miogra/features/auth/presentation/widgets/authwidgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OtpEnteringScreen extends StatefulWidget {
  const OtpEnteringScreen({super.key});

  @override
  State<OtpEnteringScreen> createState() => OtpEnteringState();
}

class OtpEnteringState extends State<OtpEnteringScreen> {
  dynamic size, height, width;
  late List<TextEditingController> controllers;
  late List<FocusNode> focusNodes;
  bool _isResendingOTP = false;

// Future<void> saveResponseInSharedPreferences(String response) async {

//   SharedPreferences prefs = await SharedPreferences.getInstance();

//   await prefs.setString('api_response', response);
// }

  void sendOTP() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final url =
        'https://${ApiServices.ipAddress}/end_user_otp/${prefs.getString("api_response")}';

    String otp = '';
    for (var controller in controllers) {
      otp += controller.text;
    }
    try {
      var request = http.MultipartRequest('POST', Uri.parse(url));

      // Populate form fields
      request.fields['user_otp'] = otp;

      var response = await request.send();

      if (response.statusCode == 200) {
        // Successfully posted data
        log('OTP Validated');
        //   String responseBody = await response.stream.bytesToString();
        //   responseBody = responseBody.trim().replaceAll('"', '');
        // await saveResponseInSharedPreferences(responseBody);
        // Redirect to approval page
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const OtpSuccess()),
        );
      } else if (response.statusCode == 400) {
        //    ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(
        //     content: Text('Check email ID and Password'),
        //   ),
        // );
        // Error occurred while posting data, but it's expected
        // Redirect to user details page
        log('Failed to post data: ${response.statusCode}');
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (context) => userdetails()),
        // );
      } else {
        // Handle other status codes if needed
        log('Unexpected status code: ${response.statusCode}');
      }
    } catch (e) {
      log('Exception while posting data: $e');
    }
  }

  void resendOTP() async {
    setState(() {
      _isResendingOTP = true; // Set loading state to true
    });

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final url =
        'https://10.0.2.2:3000/endresend_otp/${prefs.getString("api_response")}';

    try {
      var request = http.MultipartRequest('POST', Uri.parse(url));

      var response = await request.send();

      if (response.statusCode == 200) {
        // Successfully resent OTP
        log('OTP resend successful');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('OTP resend successful'),
          ),
        );
      } else {
        // Failed to resend OTP
        log('Failed to resend OTP: ${response.statusCode}');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to resend OTP'),
          ),
        );
      }
    } catch (e) {
      log('Exception while resending OTP: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to resend OTP'),
        ),
      );
    } finally {
      setState(() {
        _isResendingOTP = false; // Set loading state back to false
      });
    }
  }

  @override
  void initState() {
    super.initState();
    controllers = List.generate(4, (index) => TextEditingController());
    focusNodes = List.generate(4, (index) => FocusNode());
    for (int i = 0; i < controllers.length - 1; i++) {
      controllers[i].addListener(() {
        if (controllers[i].text.length == 1) {
          focusNodes[i + 1].requestFocus();
        }
      });
    }
  }

  @override
  void dispose() {
    for (var controller in controllers) {
      controller.dispose();
    }
    for (var node in focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // var size = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
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
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Enter the OTP",
                  style: TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 100),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(
                    4,
                    (index) => SizedBox(
                      width: 50,
                      child: TextField(
                        controller: controllers[index],
                        focusNode: focusNodes[index],
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        maxLength: 1,
                        decoration: const InputDecoration(
                          counter: Offstage(),
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) {
                          // Ensure only one character in the box
                          if (value.length == 1 &&
                              index < controllers.length - 1) {
                            focusNodes[index + 1].requestFocus();
                          }
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 70),
                SizedBox(
                  child: ElevatedButton(
                    onPressed: _isResendingOTP ? null : () => resendOTP(),
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.transparent),
                      elevation: MaterialStateProperty.all<double>(0),
                      overlayColor:
                          MaterialStateProperty.all<Color>(Colors.transparent),
                    ),
                    child: _isResendingOTP // Check loading state
                        ? const CircularProgressIndicator() // Show circular progress indicator
                        : TextButton(
                            onPressed: () {
                              resendOTP();
                            },
                            child: const Text(
                              'Resend OTP',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 50),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SubmitButton(
                      onPressed: () {
                        sendOTP();
                      },
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
