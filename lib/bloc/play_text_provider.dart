import 'dart:async';

import 'package:flutter_tts/flutter_tts.dart';
import 'package:rxdart/rxdart.dart';

class PlayTextProvider {
  final BehaviorSubject<bool> _playController = new BehaviorSubject();
  Stream<bool> get playState => _playController.stream;

  final BehaviorSubject<int> _percentageController = new BehaviorSubject();
  Stream<int> get percentage => _percentageController.stream;

  final FlutterTts _flutterTts;

  List<String> _phrases = new List();
  int _phraseIndex;

  Future initialized;

  PlayTextProvider({FlutterTts tts}) : _flutterTts = tts ?? new FlutterTts() {
    initialized = _setupTts();
  }

  Future speak(String text) async {
    print("Text: $text");
    _divideTextToPhrases(text);
    _phraseIndex = 0;
    var result = await _flutterTts.speak(_phrases[_phraseIndex]);
    print("true");
    if (result == 1) _playController.add(true);
  }

  Future pause() async {
    var result = await _flutterTts.stop();
    print("false because of pause");
    if (result == 1) _playController.add(false);
  }

  Future resume() async {
    var result = await _flutterTts.speak(_phrases[_phraseIndex]);
    print("true");
    if (result == 1) _playController.add(true);
  }

  Future _setupTts() async {
    await _flutterTts.setLanguage("ru-RU");
    /*String selectedVoice = prefs.getString(SettingsBloc.VOICE_KEY);
    if (selectedVoice != null) {
      await _flutterTts.setVoice(selectedVoice);
    }*/
    print("Let's set completion handler");
    _flutterTts.setCompletionHandler(() {
      print("completion handler called");
      _checkForNextPhrase();
    });
    print("false after init");
    _playController.add(false);
  }

  void _checkForNextPhrase() {
    if (_phraseIndex + 1 < _phrases.length) {
      _phraseIndex += 1;
      _percentageController.add(_countPercent(_phraseIndex, _phrases.length));
      _flutterTts.speak(_phrases[_phraseIndex]);
    } else {
      print("false in checkForNextPhrase");
      _playController.add(false);
      _phrases.clear();
    }
  }

  void _divideTextToPhrases(String text) {
    _phrases.clear();
    _phrases = text.split(".");
    print("Phrases inside provider: $_phrases");
  }

  int _countPercent(int phraseIndex, int phrasesCount) {
    return ((phraseIndex + 1) / phrasesCount).round();
  }
}
