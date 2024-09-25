import 'package:flutter/material.dart';

class UIHelper{
  static Positioned buildFloatingBox(double top, double left, double size) {
    return Positioned(
      top: top,
      left: left,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}