import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';

class GlobalConnectivity {
  GlobalConnectivity._();
  static final GlobalConnectivity globalConnectivity = GlobalConnectivity._();

  final Connectivity _conn = Connectivity();
  final ValueNotifier<bool> online = ValueNotifier<bool>(true);

  StreamSubscription<List<ConnectivityResult>>? _sub;

  Future<void> init() async {
    final first = await _conn.checkConnectivity();
    online.value = first != ConnectivityResult.none;

    _sub = _conn.onConnectivityChanged.listen((results) {
      final result = results.isNotEmpty ? results.first : ConnectivityResult.none;
      final isOnline = result != ConnectivityResult.none;
      if (online.value != isOnline) online.value = isOnline;
    });
  }

  void dispose() => _sub?.cancel();
}
