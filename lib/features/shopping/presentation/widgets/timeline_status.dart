import 'package:flutter/material.dart';

class TimelineStatus extends StatelessWidget {
  final bool isPast;
  final String message;
  const TimelineStatus({super.key, required this.isPast, required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: double.infinity,
      height: 50,
      margin: const EdgeInsets.only(left: 20),
      decoration: BoxDecoration(
        color: (isPast) ? Colors.green : Colors.purple.shade100,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Text(message,
          style: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.w500, fontSize: 21)),
    );
  }
}
