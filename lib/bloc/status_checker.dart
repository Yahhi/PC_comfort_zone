import 'dart:async';

import 'package:dio/dio.dart';
import 'package:health_app/bloc/play_text_provider.dart';
import 'package:health_app/bloc/preferences_provider.dart';
import 'package:health_app/bloc/storage_provider.dart';
import 'package:health_app/model/posture.dart';
import 'package:rxdart/rxdart.dart';

class StatusChecker {
  static const STATUS_URL = "http://23.101.74.30/mobile/check";

  static StatusChecker _instance;
  Timer _statusCheckerExecutor;

  final BehaviorSubject<Postage> _postageController = new BehaviorSubject();
  Stream<Postage> get postage => _postageController.stream;

  final BehaviorSubject<bool> _lightController = new BehaviorSubject();
  Stream<bool> get light => _lightController.stream;

  final BehaviorSubject<int> _airController = new BehaviorSubject();
  Stream<int> get airQuality => _airController.stream;

  final BehaviorSubject<int> _temperatureController = new BehaviorSubject();
  Stream<int> get temperature => _temperatureController.stream;

  factory StatusChecker() {
    if (_instance == null) {
      _instance = StatusChecker._();
    }
    return _instance;
  }
  String uid;

  StatusChecker._() {
    resumeConnections();
  }

  void dispose() {
    _statusCheckerExecutor.cancel();
    _statusCheckerExecutor = null;
  }

  void _getDataFromServer(Timer timer) async {
    print("let's get data from server");
    PreferencesProvider preferencesProvider = PreferencesProvider();
    if (uid == null) {
      uid = await preferencesProvider.getUid();
      print("id is $uid");
    }
    Response response;
    Dio dio = new Dio();
    response = await dio.get(STATUS_URL + "?id=$uid");
    print(response.data.toString());

    // {"status":"ok","angleSummary":{"type":"left","level":1},"details":{"humidity":26.23,"temperature":28.18,"co2":848,"lux":170}}
    Map<String, dynamic> map = response.data;
    Map<String, dynamic> subMapPosture = map["angleSummary"];
    Postage p = Postage(subMapPosture["type"], subMapPosture["level"]);

    Map<String, dynamic> subMap = map["details"];
    double humidity = subMap["humidity"];
    double temperature = subMap["temperature"];
    int co2 = subMap["co2"];
    int lux = subMap["lux"];

    String textToRead = "";
    if (co2 > 1000 && await preferencesProvider.getCO2Setting()) {
      textToRead += "Пора проветрить комнату. ";
    }
    if (humidity < 45 && await preferencesProvider.getHumiditySetting()) {
      textToRead += "Воздух слишком сухой, надо включить увлажнитель. ";
    }
    if (lux < 300 && await preferencesProvider.getLightSetting()) {
      textToRead += "Включите дополнительное освещение. ";
    }
    String postureMessage = p.getCorrectingMessage();
    if (postureMessage != null && postureMessage.isNotEmpty) {
      textToRead += postureMessage;
    }

    int qualityVisible = ((1300 - co2) / 6).round();
    if (qualityVisible < 0) {
      qualityVisible = 0;
    }
    if (qualityVisible > 100) {
      qualityVisible = 100;
    }
    _airController.add(qualityVisible);
    _temperatureController.add(temperature.round());
    _lightController.add(lux >= 300);
    _postageController.add(p);
    if (textToRead != null) {
      PlayTextProvider().speak(textToRead);
    }
    StorageProvider storageProvider = StorageProvider();
    await storageProvider.initializationDone;
    storageProvider.insertPostageIndex(p.getPostageIndex());
  }

  void cancelConnections() {
    _statusCheckerExecutor.cancel();
    _statusCheckerExecutor = null;
  }

  void resumeConnections() {
    _statusCheckerExecutor =
        new Timer.periodic(Duration(seconds: 30), _getDataFromServer);
    _getDataFromServer(null);
  }
}
