import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LogoWidget extends StatelessWidget {
  const LogoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset("assets/images/logo.svg");
  }
}

class EmailIdInputWidget extends StatelessWidget {
  final TextEditingController controller;

  const EmailIdInputWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(25),
      child: SizedBox(
        width: 300,
        child: TextField(
          controller:
              controller, // Assign the provided controller to the TextField
          decoration: const InputDecoration(
            hintText: 'Email ID',
            hintStyle: TextStyle(color: Color(0xff727272)),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xff000000)),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xff727272)),
            ),
          ),
          style: const TextStyle(color: Color(0xff727272)),
          maxLines: 1,
        ),
      ),
    );
  }
}

class PasswordInputWidget extends StatelessWidget {
  final TextEditingController controller;

  const PasswordInputWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(25),
      child: SizedBox(
        width: 300,
        child: TextField(
          controller:
              controller, // Assign the provided controller to the TextField
          decoration: const InputDecoration(
            hintText: 'Password',
            hintStyle: TextStyle(color: Color(0xff727272)),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xff000000)),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xff727272)),
            ),
          ),
          style: const TextStyle(color: Color(0xff727272)),
          maxLines: 1,
        ),
      ),
    );
  }
}

class FullNameInputWidget extends StatelessWidget {
  final TextEditingController controller;

  const FullNameInputWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(25),
      child: SizedBox(
        width: 300,
        child: TextField(
          controller:
              controller, // Assign the provided controller to the TextField
          decoration: const InputDecoration(
            hintText: 'Full Name',
            hintStyle: TextStyle(color: Color(0xff727272)),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xff000000)),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xff727272)),
            ),
          ),
          style: const TextStyle(color: Color(0xff727272)),
          maxLines: 1,
        ),
      ),
    );
  }
}

class PhoneNumberInputWidget extends StatelessWidget {
  final TextEditingController controller;

  const PhoneNumberInputWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(25),
      child: SizedBox(
        width: 300,
        child: TextField(
          controller:
              controller, // Assign the provided controller to the TextField
          decoration: const InputDecoration(
            hintText: 'Phone Number',
            hintStyle: TextStyle(color: Color(0xff727272)),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xff000000)),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xff727272)),
            ),
          ),
          style: const TextStyle(color: Color(0xff727272)),
          maxLines: 1,
        ),
      ),
    );
  }
}

class NewPasswordInputWidget extends StatelessWidget {
  final TextEditingController controller;

  const NewPasswordInputWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(25),
      child: SizedBox(
        width: 300,
        child: TextField(
          controller:
              controller, // Assign the provided controller to the TextField
          decoration: const InputDecoration(
            hintText: 'Enter your new password',
            hintStyle: TextStyle(color: Color(0xff727272)),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xff000000)),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xff727272)),
            ),
          ),
          style: const TextStyle(color: Color(0xff727272)),
          maxLines: 1,
        ),
      ),
    );
  }
}

class SignInButton extends StatelessWidget {
  final VoidCallback onPressed;

  const SignInButton({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xff8B1874),
      ),
      onPressed: onPressed,
      child: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 3.0),
        child: Text(
          'Sign in',
          style: TextStyle(
            color: Color.fromARGB(255, 255, 255, 255),
            fontFamily: 'Actor',
            fontWeight: FontWeight.bold,
            fontSize: 17,
          ),
        ),
      ),
    );
  }
}

class SubmitButton extends StatelessWidget {
  final VoidCallback onPressed;

  const SubmitButton({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xff8B1874),
      ),
      onPressed: onPressed,
      child: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 3.0),
        child: Text(
          'Submit',
          style: TextStyle(
            color: Color.fromARGB(255, 255, 255, 255),
            fontFamily: 'Actor',
            fontWeight: FontWeight.bold,
            fontSize: 17,
          ),
        ),
      ),
    );
  }
}
