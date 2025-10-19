import 'package:flutter/foundation.dart';
import 'package:neos_coder/core/utils/constants.dart';
import '../core/di/locator.dart';
import '../core/location/location_service.dart';

class AppLocationService extends ChangeNotifier {
  final _core = sl<LocationServiceCore>();

  Future<Map> withinRadius(double lat, double lng) async {
    try {
      final p = await _core.current();

      final d = _core.distanceMeters(lat, lng, p.latitude, p.longitude);
      d <= AppConstraints.checkRadiusMeters;
      return {'withinRadius': d <= AppConstraints.checkRadiusMeters, 'distanceMeters': d};
    } catch (e) {
      debugPrint('Location error: $e');
      return {'withinRadius': false, 'distanceMeters': double.infinity};
    }
  }
}
