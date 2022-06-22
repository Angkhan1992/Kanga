import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class KangaSTTProvider {
  SpeechToText _speechToText = SpeechToText();

  static KangaSTTProvider of() {
    return KangaSTTProvider()..init();
  }

  void init() {
    print('[VOICE] available ===> ${_speechToText.isAvailable}');
    if (!_speechToText.isAvailable) _speechToText.cancel();

    _speechToText.initialize(
      onStatus: (val) => print('[VOICE] status ===> $val'),
      onError: (val) => print(
        '[VOICE] error ===> $val',
      ),
      finalTimeout: Duration(minutes: 1),
    );
  }

  void start({
    required Function(SpeechRecognitionResult) onResult,
  }) async {
    await _speechToText.listen(
      onResult: onResult,
      cancelOnError: true,
      localeId: 'en_US',
    );
  }

  Future stop() async {
    await _speechToText.stop();
    return;
  }

  void dispose() {
    _speechToText.stop();
    _speechToText.cancel();
  }

  static Future<bool> checkPermission() async {
    var statusMicrophone = await Permission.microphone.status;
    var statusSpeech = await Permission.speech.status;
    if (!statusMicrophone.isGranted || !statusSpeech.isGranted) {
      Map<Permission, PermissionStatus> statuses = await [
        Permission.microphone,
        Permission.speech,
      ].request();
      if (statuses[Permission.microphone] == PermissionStatus.granted &&
          statuses[Permission.speech] == PermissionStatus.granted) {
        return true;
      }
    } else {
      return true;
    }
    return false;
  }
}

Future<bool> checkLibraryPermission() async {
  var statusPhoto = await Permission.photos.status;
  var statusCamera = await Permission.camera.status;
  var statusMicroPhone = await Permission.microphone.status;
  if (!statusPhoto.isGranted ||
      !statusCamera.isGranted ||
      !statusMicroPhone.isGranted) {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.photos,
      Permission.camera,
      Permission.microphone,
    ].request();
    print('[PERMISSION] ${statuses[Permission.photos]}');
    print('[PERMISSION] ${statuses[Permission.camera]}');
    if (statuses[Permission.photos] != PermissionStatus.denied &&
        statuses[Permission.camera] != PermissionStatus.denied &&
        statuses[Permission.microphone] != PermissionStatus.denied) {
      return true;
    } else {
      return true;
    }
  } else {
    return true;
  }
}
