import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'bloc/storage_provider.dart';
import 'constants/app_colors.dart';
import 'initial_screen.dart';

void main() {
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) async {
    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
  MyApp({
    Key key,
  }) : super(key: key) {
    StorageProvider();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HOLD',
      theme: ThemeData(
        fontFamily: 'Arimo',
        primaryColor: AppColors.BLUE,
        canvasColor: AppColors.BACKGROUND,
      ),
      home: InitialScreen(),
    );
  }
}
