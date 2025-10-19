import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  final Connectivity _conn = Connectivity();
  final _controller = StreamController<bool>.broadcast();

  Stream<bool> get onStatusChange => _controller.stream;

  ConnectivityService() {
    _bootstrap();
    _conn.onConnectivityChanged.listen((result) async {
      final online = result != ConnectivityResult.none;
      _controller.add(online);
    });
  }

  Future<void> _bootstrap() async {
    final r = await _conn.checkConnectivity();
    _controller.add(r != ConnectivityResult.none);
  }

  Future<bool> isOnline() async {
    final r = await _conn.checkConnectivity();
    return r != ConnectivityResult.none;
  }

  void dispose() {
    _controller.close();
  }
}
