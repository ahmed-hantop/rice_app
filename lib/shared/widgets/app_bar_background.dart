import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rice_delivery/generated/assets.dart';

class AppBarBackground extends StatelessWidget {
  const AppBarBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) {
        return LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          // colors: [Color(0xFFFDC110), Color(0xFFFFD045)],
          colors: [
            Colors.white.withValues(alpha: 0.03),
            Colors.white.withValues(alpha: 0.7),
          ],
        ).createShader(bounds);
      },
      blendMode: BlendMode.srcIn,
      child: SvgPicture.asset(
        Assets.svgAppBarBackground,
        fit: BoxFit.cover,
        width: double.infinity,
        alignment: Alignment.bottomCenter,
      ),
    );
  }
}
