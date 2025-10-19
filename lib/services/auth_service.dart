import 'package:flutter/foundation.dart';

class AuthService extends ChangeNotifier {
  String? _userId;

  String? get userId => _userId;

  void bootstrap() {
    _userId = 'agent-123';
    notifyListeners();
  } // TODO: plug real auth
}
