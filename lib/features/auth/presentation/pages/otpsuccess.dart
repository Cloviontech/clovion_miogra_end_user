import 'package:flutter/material.dart';
import 'package:miogra/home_page/home_page.dart';
import 'dart:async';

import 'package:miogra/home_page/home_page_trail.dart';

class OtpSuccess extends StatefulWidget {
  const OtpSuccess({super.key});

  // @override
  @override
  // ignore: library_private_types_in_public_api
  _OtpSuccessState createState() => _OtpSuccessState();
}

class _OtpSuccessState extends State<OtpSuccess> with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    _controller.forward();
    // Redirect to another page after 3 seconds
    Timer(
      const Duration(seconds: 3),
      () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => HomePage(),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(
          // mainAxisAlignment: MainAxisAlignment.center,
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
                SizedBox(
                  child: Center(
                    child: AnimatedBuilder(
                      animation: _controller,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: _controller.value *
                              1.5, // Increase scale for splash effect
                          child: Transform.rotate(
                            angle: _controller.value * 2 * 3.1415926535897932,
                            child: const Icon(
                              Icons.check_circle,
                              color: Color.fromARGB(255, 0, 211, 7),
                              size: 100,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const SizedBox(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 20),
                      Text(
                        'Validated Successfully',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
