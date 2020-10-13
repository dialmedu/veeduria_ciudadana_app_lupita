import 'package:flutter/material.dart';

class LButtons {
  static Widget buttonPrimary(
      String label, Function onTapCallback, BuildContext context) {
    return InkWell(
      onTap: onTapCallback,
      child: Container(
        width: MediaQuery.of(context).size.width - 50.0,
        height: 50.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25.0),
          color: Colors.greenAccent,
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
                color: Colors.white),
          ),
        ),
      ),
    );
  }
}
