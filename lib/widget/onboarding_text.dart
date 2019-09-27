import 'package:flutter/material.dart';

class OnboardingText extends StatelessWidget {
  final String text;

  const OnboardingText(
    this.text, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Text(
        text,
        textAlign: TextAlign.center,
        textScaleFactor: 0.9,
      ),
    );
  }
}
