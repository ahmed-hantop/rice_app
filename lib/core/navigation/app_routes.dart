
import 'package:flutter/material.dart';

/// Legacy imperative navigation helpers (ported from thkel). Prefer GoRouter
/// for new code.
class AppRoutes {
  static void pushTo(
    BuildContext context,
    Widget page, {
    bool noAnimation = false,
  }) {
    final route =
        noAnimation
            ? MaterialPageRoute<void>(builder: (_) => page)
            : _buildRoute(page);
    Navigator.push(context, route);
  }

  static void pushReplacementTo(
    BuildContext context,
    Widget page, {
    bool noAnimation = false,
  }) {
    final route =
        noAnimation
            ? MaterialPageRoute<void>(builder: (_) => page)
            : _buildRoute(page);
    Navigator.pushReplacement(context, route);
  }

  static void pushAndRemoveAllPageTo(
    BuildContext context,
    Widget page, {
    bool noAnimation = false,
    bool removeProviderData = false,
  }) {
    if (removeProviderData) {
    //  unawaited(SharedPreferencesService.clearToken());
     // printInfo('Session cleared (pushAndRemoveAllPageTo)');
    }
    final route =
        noAnimation
            ? MaterialPageRoute<void>(builder: (_) => page)
            : _buildRoute(page);
    Navigator.pushAndRemoveUntil(context, route, (_) => false);
  }

  static PageRouteBuilder<void> _buildRoute(Widget page) {
    return PageRouteBuilder<void>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(-1, 0);
        const end = Offset.zero;
        const curve = Curves.linear;
        final tween = Tween(
          begin: begin,
          end: end,
        ).chain(CurveTween(curve: curve));
        return SlideTransition(position: animation.drive(tween), child: child);
      },
    );
  }
}
