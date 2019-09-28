import 'dart:async';

import 'package:dio/dio.dart';
import 'package:health_app/bloc/preferences_provider.dart';
import 'package:health_app/model/posture.dart';
import 'package:rxdart/rxdart.dart';

class StatusChecker {
  static const STATUS_URL = "https://23.101.74.30/mobile/check";

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
    _statusCheckerExecutor =
        new Timer.periodic(Duration(seconds: 30), _getDataFromServer);
  }

  void dispose() {
    _statusCheckerExecutor.cancel();
    _statusCheckerExecutor = null;
  }

  void _getDataFromServer(Timer timer) async {
    if (uid == null) {
      uid = await PreferencesProvider().getUid();
    }
    Response response;
    Dio dio = new Dio();
    response = await dio.get(STATUS_URL + "?id=$uid");
    print(response.data.toString());
  }
}
