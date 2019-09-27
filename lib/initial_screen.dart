import 'package:flutter/material.dart';
import 'package:health_app/widget/header_text.dart';

import 'bloc/preferences_provider.dart';
import 'main_screen.dart';
import 'onboarding_screen.dart';

class InitialScreen extends StatefulWidget {
  final PreferencesProvider preferencesProvider;

  const InitialScreen({Key key, this.preferencesProvider}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _InitialScreenState();
  }
}

class _InitialScreenState extends State<InitialScreen> {
  PreferencesProvider preferencesProvider;
  NavigatorObserver navigatorObserver;
  @override
  void initState() {
    super.initState();
    if (widget.preferencesProvider == null) {
      preferencesProvider = new PreferencesProvider();
    } else {
      preferencesProvider = widget.preferencesProvider;
    }
    _initRedirect();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 6,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 50.0),
              child: Image.asset("assets/logo_with_letters.png"),
            ),
          ),
          Expanded(
            flex: 4,
            child: HeaderText(
              "Предотвращение профессональных заболеваний",
            ),
          )
        ],
      ),
    );
  }

  void _initRedirect() async {
    await Future.delayed(Duration(seconds: 1));
    if (await preferencesProvider.getFirstRunFinished()) {
      _openMainScreen();
    } else {
      await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => OnboardingScreen()),
      );
      _openMainScreen();
    }
  }

  void _openMainScreen() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => MainScreen()),
    );
  }
}
