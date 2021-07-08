import 'package:get/get.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'dart:math';

class SpeechController extends GetxController {
  @override
  void onInit() {
    // TODO: implement onInit
    initialize();
    super.onInit();
  }

  SpeechToText speech = SpeechToText();

  List<LocaleName> _localeNames = [];
  String _currentLocaleId = '';
  var lastWords = ''.obs;
  String lastError = '';
  String lastStatus = '';
  var _ready = false.obs;
  void initialize() async {
    _ready.value = await speech.initialize(
        onStatus: statuslistener, onError: errorListener);

    // _hasSpeech = availbale;
    // speech.listen(
    //     onResult: resultListener,
    //     listenFor: Duration(seconds: 3),
    //     pauseFor: Duration(seconds: 1),
    //     partialResults: true,
    //     localeId: _currentLocaleId,
    //     cancelOnError: true,
    //     listenMode: ListenMode.confirmation);
  }

  int resultListened = 0;
  void statuslistener(String status) {}

  void errorListener(SpeechRecognitionError errorNotification) {
    print(errorNotification.errorMsg);
  }

  void resultListener(SpeechRecognitionResult result) {
    print("abeg no burst");
    lastWords.value = result.recognizedWords;
    // ++resultListened;
    // print('Result listener $resultListened');
    // lastWords = '${result.recognizedWords} - ${result.finalResult}';
  }

  start() {
    if (_ready.value) {
      startListenting();
    }
  }

  stop() {
    {
      if (!_listening.value) stopListening();
    }
  }

  startListenting() {
    print("listening...");
    speech.listen(onResult: (result) => resultListener(result));
    _listening.value = true;
  }

  void stopListening() {
    print("stoppinnggggg");
    speech.stop();
    _listening.value = false;
  }

  var _listening = false.obs;
}
