import 'package:flutter/material.dart';
import 'package:health_app/bloc/preferences_provider.dart';
import 'package:health_app/widget/header_text.dart';
import 'package:health_app/widget/setting_widget.dart';

class SettingsPart extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SettingsPartState();
  }
}

class _SettingsPartState extends State<SettingsPart> {
  bool _humidityInform = true;
  bool _co2Inform = true;
  bool _lightInform = true;
  Duration _frequencyValue = Duration(seconds: 30);

  @override
  void initState() {
    super.initState();
    _loadSavedValues();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        HeaderText("Settings"),
        SettingWidget(
          _humidityInform,
          (newValue) {
            PreferencesProvider().saveHumiditySetting(newValue);
            setState(() {
              _humidityInform = newValue;
            });
          },
          "Информировать об отклонениях влажности",
        ),
        SettingWidget(
          _co2Inform,
          (newValue) {
            PreferencesProvider().saveCO2Setting(newValue);
            setState(() {
              _co2Inform = newValue;
            });
          },
          "Информировать о качестве воздуха",
        ),
        SettingWidget(
          _lightInform,
          (newValue) {
            PreferencesProvider().saveLightSetting(newValue);
            setState(() {
              _lightInform = newValue;
            });
          },
          "Информировать об уровне освещенности",
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            children: <Widget>[
              Text("Частота информирования"),
              DropdownButton<Duration>(
                items: PreferencesProvider.frequencyOptions
                    .map((description, value) {
                      return MapEntry(
                          description,
                          DropdownMenuItem<Duration>(
                            value: value,
                            child: Text(description),
                          ));
                    })
                    .values
                    .toList(),
                value: _frequencyValue,
                onChanged: (newValue) {
                  setState(() {
                    _frequencyValue = newValue;
                  });
                },
              )
            ],
          ),
        ),
      ],
    );
  }

  void _loadSavedValues() async {
    PreferencesProvider preferencesProvider = new PreferencesProvider();
    _humidityInform = await preferencesProvider.getHumiditySetting();
    _lightInform = await preferencesProvider.getLightSetting();
    _co2Inform = await preferencesProvider.getCO2Setting();
    _frequencyValue = await preferencesProvider.getFrequencySetting();
    setState(() {});
  }
}
