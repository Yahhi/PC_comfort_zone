import 'package:flutter/material.dart';

class SettingWidget extends StatelessWidget {
  final bool value;
  final String text;
  final ValueChanged<bool> onChange;

  const SettingWidget(
    this.value,
    this.onChange,
    this.text, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Text(text),
          ),
          Switch(
            value: value,
            onChanged: onChange,
          )
        ],
      ),
    );
  }
}
