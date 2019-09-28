import 'package:flutter/material.dart';
import 'package:health_app/constants/app_colors.dart';

class HeaderText extends StatelessWidget {
  final String _text;
  final Color color;

  const HeaderText(
    this._text, {
    Key key,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Text(
        _text,
        textAlign: TextAlign.center,
        textScaleFactor: 1.5,
        style: TextStyle(
          color: color ?? AppColors.BLUE,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
