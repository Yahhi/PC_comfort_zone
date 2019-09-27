import 'package:flutter/material.dart';
import 'package:health_app/constants/app_colors.dart';
import 'package:health_app/widget/header_text.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final PageController controller = new PageController(initialPage: 1);
  bool _profileSelected = false;
  bool _settingsSelected = false;

  @override
  void initState() {
    controller.addListener(_onPageChange);
    super.initState();
  }

  @override
  void dispose() {
    controller.removeListener(_onPageChange);
    super.dispose();
  }

  void _onPageChange() {
    if (controller.page > 1.6) {
      setState(() {
        _settingsSelected = true;
        _profileSelected = false;
      });
    } else {
      setState(() {
        _settingsSelected = false;
      });
      if (controller.page < 0.5) {
        setState(() {
          _profileSelected = true;
        });
      } else {
        setState(() {
          _profileSelected = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.WHITE,
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.settings,
              color: _profileSelected ? AppColors.GREEN : AppColors.BLUE,
            ),
            onPressed: _showSettings,
          ),
        ],
        leading: IconButton(
          icon: Icon(
            Icons.accessibility,
            color: _settingsSelected ? AppColors.GREEN : AppColors.BLUE,
          ),
          onPressed: _showProfile,
        ),
      ),
      body: PageView(
        controller: controller,
        children: <Widget>[_profile, _main, _settings],
      ),
    );
  }

  Widget _profile = Column(
    children: <Widget>[
      HeaderText("Profile"),
    ],
  );

  Widget _main = Stack();

  Widget _settings = Column(
    children: <Widget>[
      HeaderText("Settings"),
    ],
  );

  void _showSettings() {
    controller.jumpToPage(2);
  }

  void _showProfile() {
    controller.jumpToPage(0);
  }
}
