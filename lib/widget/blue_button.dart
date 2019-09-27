import 'package:flutter/material.dart';
import 'package:health_app/constants/app_colors.dart';

class BlueButton extends StatelessWidget {
  final String text;
  final VoidCallback action;

  const BlueButton(
    this.text,
    this.action, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: action,
      child: Container(
        height: 40,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Image.asset("assets/blue_button_left_side.png"),
            Expanded(
              child: Container(
                alignment: Alignment.center,
                height: 40,
                color: AppColors.BLUE,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    text,
                    style: TextStyle(color: AppColors.WHITE),
                  ),
                ),
              ),
            ),
            Image.asset("assets/blue_button_right_side.png"),
          ],
        ),
      ),
    );
  }
}
