import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class VerticalProgressIndicator extends StatelessWidget {
  final String label;
  final double goal;
  final double current;
  final Color color;

  const VerticalProgressIndicator({
    Key? key,
    required this.label,
    required this.goal,
    required this.current,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Calculate the progress percentage
    final double progressPercentage = (goal > 0) ? (current / goal).clamp(0.0, 1.0) : 0.0;
    // Define the maximum height for the container
    final double maxContainerHeight = 300.0;
    // Define the container height with a limit of maxContainerHeight
    final double containerHeight = MediaQuery.of(context).size.height * 0.4;
    final double constrainedContainerHeight = containerHeight > maxContainerHeight ? maxContainerHeight : containerHeight;
    // Define the progress height with clamping to constrainedContainerHeight
    final double progressHeight = (goal > 0) ? (constrainedContainerHeight * progressPercentage).clamp(0.0, constrainedContainerHeight) : 0.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Text(
        //   label,
        //   style: GoogleFonts.openSans(
        //     color: Colors.white,
        //     fontSize: 18,
        //     fontWeight: FontWeight.bold,
        //   ),
        // ),
        SizedBox(height: 10),
        Stack(
          children: [
            // Background container
            Container(
              width: 71,
              height: constrainedContainerHeight,
              decoration: BoxDecoration(
                color: color.withOpacity(0.5),
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            // Progress bar
            Positioned(
              bottom: 0,
              child: Container(
                width: 70,
                height: progressHeight,
                decoration: BoxDecoration(
                  color: progressPercentage >= 1.0 ? Color(0xb6ffffff) : color,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.4),
                      offset: Offset(2, 2),
                      blurRadius: 4,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.only(left: 14.0),
          child: Text(
            '${(progressPercentage * 100).toStringAsFixed(1)}%',
            style: GoogleFonts.openSans(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }
}
