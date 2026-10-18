import 'package:flutter/material.dart';

enum StepEnabling { sequential, individual, all }

class StepperModel {
  int? index;
  bool enabled;
  IconData? icon, activeIcon, finishIcon;

  StepperModel({
    this.index,
    required this.enabled,
    this.icon,
    this.activeIcon,
    this.finishIcon,
  });
}
