import 'package:flutter/material.dart';

import 'constants/app_colors.dart';

class ExerciseScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.WHITE,
        title: Text(
          "Упражнения для глаз",
          style: TextStyle(color: AppColors.BLUE, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Image.asset("assets/exercise.png"),
      ),
    );
  }
}
