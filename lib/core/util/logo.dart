import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_circular_text/circular_text.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Logo extends StatelessWidget {
  final double radius;

  const Logo({super.key, required this.radius});

  @override
  Widget build(BuildContext context) {
    const gap = 10;
    const buffer = 5;
    final textTheme = Theme.of(context).textTheme;

    return LayoutBuilder(
      builder: (context, constraints) {
        final outer = constraints.maxWidth / 2;
        final logoRadius = min(radius, outer - gap - buffer); // go with smaller option of the two

        return Center(
          child: SizedBox(
            width: (logoRadius + gap + buffer) * 2,
            height: (logoRadius + gap + buffer) * 2,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SvgPicture.asset(
                  'assets/logo.svg',
                  width: logoRadius * 2,
                  height: logoRadius * 2,
                ),
                CircularText(
                  children: [
                    TextItem(
                      text: Text(
                        "Local Fork".toUpperCase(),
                        style: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      space: 15,
                      startAngle: -90,
                      startAngleAlignment: StartAngleAlignment.center,
                      direction: CircularTextDirection.clockwise,
                    ),
                  ],
                  radius: logoRadius+gap,
                  position: CircularTextPosition.outside,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
