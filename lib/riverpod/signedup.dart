import 'package:flutter_riverpod/flutter_riverpod.dart';

class SignedUpNotifier extends StateNotifier<bool> {
  SignedUpNotifier() : super(false);
  bool changeMode(bool value) {
    print("$state ****************** from riverpod");
    state = value;
    print("$state **************** from riverpod");
    return state;
  }
}

final signedUpProvider = StateNotifierProvider<SignedUpNotifier, bool>(
  (ref) => SignedUpNotifier(),
);
