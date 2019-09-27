import 'package:flutter/material.dart';
import 'package:health_app/widget/blue_button.dart';
import 'package:health_app/widget/header_text.dart';
import 'package:page_indicator/page_indicator.dart';

import 'constants/app_colors.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _OnboardingScreenState();
  }
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  static const _HORIZONTAL_PADDING = 30.0;
  static const _TOP_PROPORTION = 4;
  static const _BOTTOM_PROPORTION = 6;

  final PageController controller = new PageController();
  bool isFinalButton = false;
  int pageIndex = 0;

  @override
  Widget build(BuildContext context) {
    controller.addListener(_onPageChange);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.WHITE,
          leading: Container(),
          actions: <Widget>[
            Container(),
          ],
          title: Padding(
            padding: EdgeInsets.fromLTRB(0, 8.0, 40, 8.0),
            child: Center(
              child: Image.asset("assets/logo_with_letters.png"),
            ),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.fromLTRB(12.0, 60.0, 12.0, 40.0),
          child: PageIndicatorContainer(
            child: PageView(
              physics: new AlwaysScrollableScrollPhysics(),
              children: <Widget>[
                _firstPage,
                _secondPage,
                _thirdPage,
              ],
              controller: controller,
            ),
            align: IndicatorAlign.bottom,
            length: 3,
            indicatorSpace: 10.0,
            padding: const EdgeInsets.all(10),
            indicatorColor: AppColors.BLUE,
            indicatorSelectorColor: AppColors.GREEN,
            shape: IndicatorShape.circle(size: 6),
          ),
        ));
  }

  void _onPageChange() {
    if (controller.page > 2.6) {
      setState(() {
        pageIndex = controller.page.round();
        isFinalButton = true;
      });
    } else {
      setState(() {
        pageIndex = controller.page.round();
        isFinalButton = false;
      });
    }
  }

  Widget get _firstPage => Padding(
        padding: EdgeInsets.symmetric(horizontal: _HORIZONTAL_PADDING),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              flex: _TOP_PROPORTION,
              child: Center(
                child: Image.asset("assets/track_pose.png"),
              ),
            ),
            Expanded(
              flex: _BOTTOM_PROPORTION,
              child: Column(
                children: <Widget>[
                  HeaderText(
                    "Следим за позой",
                  ),
                  BlueButton(
                    "ДАЛЕЕ",
                    _showNextPage,
                  )
                ],
              ),
            )
          ],
        ),
      );

  Widget get _secondPage => Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Expanded(
            flex: _TOP_PROPORTION,
            child: Center(
              child: Image.asset("assets/track_co2.png"),
            ),
          ),
          Expanded(
            flex: _BOTTOM_PROPORTION,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: _HORIZONTAL_PADDING),
              child: Column(
                children: <Widget>[
                  HeaderText("Следим за средой"),
                  BlueButton(
                    "ДАЛЕЕ",
                    _showNextPage,
                  )
                ],
              ),
            ),
          ),
        ],
      );

  Widget get _thirdPage => Padding(
        padding: EdgeInsets.symmetric(horizontal: _HORIZONTAL_PADDING),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              flex: _TOP_PROPORTION,
              child: Center(
                child: Image.asset("assets/track_light.png"),
              ),
            ),
            Expanded(
              flex: _BOTTOM_PROPORTION,
              child: Column(
                children: <Widget>[
                  HeaderText("Следим за освещением"),
                  BlueButton(
                    "ДАЛЕЕ",
                    () {
                      Navigator.of(context).pop();
                    },
                  )
                ],
              ),
            )
          ],
        ),
      );

  void _showNextPage() {
    controller.nextPage(
        duration: Duration(milliseconds: 300), curve: Curves.decelerate);
  }
}
