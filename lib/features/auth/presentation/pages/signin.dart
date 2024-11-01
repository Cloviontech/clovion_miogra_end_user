// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'package:miogra/core/api_services.dart';
import 'package:miogra/features/auth/presentation/pages/forgotpassword.dart';
import 'package:miogra/features/auth/presentation/pages/signup.dart';
import 'package:miogra/features/auth/presentation/widgets/authwidgets.dart';
import 'package:miogra/home_page/home_page.dart';
import 'package:miogra/features/profile/pages/address.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../home_page/home_page_trail.dart';

class SignInPage extends StatefulWidget {
  final String? productId;
  final String? shopId;

  const SignInPage({super.key, this.productId, this.shopId});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  dynamic size, height, width;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false; // Track password visibility

  Future<void> saveResponseInSharedPreferences(String response) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    await prefs.setString('api_response', response);
    log('response $response');
  }

  void sendPostRequestSignIn() async {
    const url = 'https://${ApiServices.ipAddress}/end_user_signin/';

    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(
            color: Color.fromARGB(255, 137, 26, 119),
            backgroundColor: Colors.white,
          ),
        );
      },
    );

    try {
      var request = http.MultipartRequest('POST', Uri.parse(url));

      // Populate form fields
      request.fields['email'] = _emailController.text;
      request.fields['password'] = _passwordController.text;

      var response = await request.send();

      if (response.statusCode == 200) {
        // Successfully posted data
        log('SignIn successfully');
        String responseBody = await response.stream.bytesToString();
        responseBody = responseBody.trim().replaceAll('"', '');

        log('userId $responseBody');
        saveResponseInSharedPreferences(responseBody);

        Navigator.pop(context);

        widget.shopId == null
            ? Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const HomePage(),
                ),
              )
            : Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddressPage(
                    amountToBePaid: '',
                    userId: responseBody,
                    cartlist: const [],
                  ),
                ),
              );
      } else {
        Navigator.pop(context);
        // Display a Snackbar when the response is not 200
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Check Email Id and Password'),
          ),
        );
        // Error occurred while posting data, but it's expected
        log('Failed to post data: ${response.statusCode}');
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
          Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const LogoWidget(),
                  const SizedBox(height: 5),
                  Container(
                    margin: const EdgeInsets.only(top: 50),
                    child: SizedBox(
                      width: 340,
                      child: EmailIdInputWidget(controller: _emailController),
                    ),
                  ),
                  SizedBox(
                    child: SizedBox(
                      width: 295,
                      child: TextFormField(
                        controller: _passwordController,
                        obscureText:
                            !_isPasswordVisible, // Toggle password visibility
                        decoration: InputDecoration(
                          labelText: 'Password',
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.grey,
                            ),
                            onPressed: () {
                              setState(() {
                                _isPasswordVisible = !_isPasswordVisible;
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  SizedBox(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ForgotPassword()),
                        );
                      },
                      style: ButtonStyle(
                        backgroundColor:
                            WidgetStateProperty.all<Color>(Colors.transparent),
                        elevation: WidgetStateProperty.all<double>(0),
                        overlayColor:
                            WidgetStateProperty.all<Color>(Colors.transparent),
                      ),
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const ForgotPassword()),
                          );
                        },
                        child: const Text(
                          'Forgot Password ?',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        child: Text(
                          "Don't have an account ?",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                      ),
                      TextButton(
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SignUp()),
                        ),
                        child: const Text(
                          'Sign up',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.purple,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SignInButton(
                        onPressed: () {
                          sendPostRequestSignIn();
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
