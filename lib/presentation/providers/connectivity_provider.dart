import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../core/di/locator.dart';
import '../../core/network/connectivity_service.dart';

class ConnectivityProvider extends ChangeNotifier {
  final _svc = sl<ConnectivityService>();
  late final StreamSubscription _sub;

  bool _online = true;

  bool get online => _online;

  ConnectivityProvider() {
    _init();
  }

  Future<void> _init() async {
    _online = await _svc.isOnline();
    notifyListeners();
    _sub = _svc.onStatusChange.listen((v) {
      _online = v;
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }
}
