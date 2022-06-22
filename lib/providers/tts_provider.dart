import 'dart:io';

import 'package:flutter_tts/flutter_tts.dart';

class KangaTTSProvider {
  FlutterTts? _flutterTts;

  double volume = 1.0;
  double pitch = 1.0;
  double rate = 0.5;

  void initTTS() async {
    _flutterTts = FlutterTts();
    if (Platform.isIOS) {
      await _flutterTts!.setSharedInstance(true);
    } else {
      await _flutterTts!.setSilence(2);
      await _flutterTts!.isLanguageInstalled("en-AU");
      await _flutterTts!.areLanguagesInstalled(["en-AU", "en-US"]);
      await _flutterTts!.setQueueMode(1);
      await _flutterTts!.getMaxSpeechInputLength;
    }
    await _flutterTts!
        .setIosAudioCategory(IosTextToSpeechAudioCategory.playAndRecord, [
      IosTextToSpeechAudioCategoryOptions.allowBluetooth,
      IosTextToSpeechAudioCategoryOptions.allowBluetoothA2DP,
      IosTextToSpeechAudioCategoryOptions.mixWithOthers
    ]);
  }

  Future speak(String voiceText) async {
    await _flutterTts!.setVolume(volume);
    await _flutterTts!.setSpeechRate(rate);
    await _flutterTts!.setPitch(pitch);

    if (voiceText != null) {
      if (voiceText.isNotEmpty) {
        await _flutterTts!.awaitSpeakCompletion(true);
        await _flutterTts!.speak(voiceText);
      }
    }
  }

  Future stop() async {
    await _flutterTts!.stop();
  }

  static KangaTTSProvider of() {
    return KangaTTSProvider()..initTTS();
  }
}
