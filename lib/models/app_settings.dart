import 'package:flutter/foundation.dart';

class AppSettings extends ChangeNotifier {
  bool enableConfetti = true;

  void toggleConfetti() {
    enableConfetti = !enableConfetti;
    notifyListeners();
  }
}
