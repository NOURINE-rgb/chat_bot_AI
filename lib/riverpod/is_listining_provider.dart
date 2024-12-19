import 'package:flutter_riverpod/flutter_riverpod.dart';

class SpeechTextNotifier extends StateNotifier<bool> {
  SpeechTextNotifier() : super(false);
  bool isListining(bool value) {
    print('in riverpos package this the value $value ********************');
    state = value;
    return value;
  }
}

final isListiningProvider = StateNotifierProvider<SpeechTextNotifier, bool>(
  (ref) => SpeechTextNotifier(),
);
