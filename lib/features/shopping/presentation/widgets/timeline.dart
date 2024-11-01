import 'package:flutter/material.dart';
import 'package:timeline_tile/timeline_tile.dart';

class Timeline extends StatelessWidget {
  final bool isFirst;
  final bool isLast;
  final bool isPast;
  const Timeline({super.key, required this.isFirst, required this.isLast, required this.isPast});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      height: 70,
      child: TimelineTile(
        isFirst: isFirst,
        isLast: isLast,
        beforeLineStyle: LineStyle(
          color: (isPast) ? Colors.green : Colors.purple.shade100,
        ),
        indicatorStyle: IndicatorStyle(
            width: 30,
            color: (isPast) ? Colors.green : Colors.purple.shade100,
            iconStyle: (isPast) ? IconStyle(iconData: Icons.done_all, color: Colors.white) : IconStyle(iconData: Icons.done, color: Colors.white)
        ),
        
      ),
    );
  }
}
