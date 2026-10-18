import 'package:flutter/material.dart';

/// Root navigator key for snackbars and services that need a [BuildContext]
/// without being under the widget tree (matches former thkel `myNavigatorKey`).
final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();
