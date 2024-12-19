import 'package:chat_boot/riverpod/is_listining_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

// class SpeechToTextHelper {
//   SpeechTextNotifier({required this.msg});
//   final string msg;
//   final stt.SpeechToText _speech = stt.SpeechToText();
//   String _transcription = "";

//   Future<void> initSpeech(WidgetRef ref) async {
//     bool available = await _speech.initialize(
//       onError: (val) => print('Error: $val'),
//       onStatus: (val) {
//         if (val == 'done') {
//           ref.read(isListiningProvider.notifier).isListining(false);
//         } else {
//           ref.read(isListiningProvider.notifier).isListining(true);
//         }
//       },
//     );
//     if (available) {
//       print('Speech-to-text initialized! *********************');
//     } else {
//       print('Speech recognition unavailable. **************************');
//     }
//   }

//   void startListening(Function(String) onResult, WidgetRef ref) {
//     // ref.read(isListiningProvider.notifier).isListining(true);
//     _speech.listen(
//       onResult: (val) {
//         _transcription = val.recognizedWords;
//         onResult(_transcription);
//       },
//     );
//   }

//   void stopListening(WidgetRef ref) {
//     _speech.stop();
//     // ref.read(isListiningProvider.notifier).isListining(false);
//   }

//   String get transcription => _transcription;
// }

class MySpeechToText {
  MySpeechToText({
    required this.ref,
  });
  final WidgetRef ref;
  final stt.SpeechToText _speech = stt.SpeechToText();
  String _transcription = "";

  Future<void> initSpeech() async {
    bool available = await _speech.initialize(
      onError: (val) => print('Error: $val'),
      onStatus: (val) {
        if (val == 'done') {
          ref.read(isListiningProvider.notifier).isListining(false);
        } else {
          ref.read(isListiningProvider.notifier).isListining(true);
        }
      },
    );
    if (available) {
      print('Speech-to-text initialized! *********************');
    } else {
      print('Speech recognition unavailable. **************************');
    }
  }

  void startListening(Function(String) onResult) {
    // ref.read(isListiningProvider.notifier).isListining(true);
    _speech.listen(
      onResult: (val) {
        _transcription = val.recognizedWords;
        onResult(_transcription);
      },
    );
  }

  void stopListening() {
    _speech.stop();
    // ref.read(isListiningProvider.notifier).isListining(false);
  }

  String get transcription => _transcription;
}