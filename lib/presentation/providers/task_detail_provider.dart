import 'package:flutter/foundation.dart';
import 'package:neos_coder/core/location/location_service.dart';
import 'package:neos_coder/core/utils/constants.dart';
import '../../core/di/locator.dart';
import '../../domain/entities/task_entity.dart';
import '../../domain/usecases/check_in.dart';
import '../../domain/usecases/complete_task.dart';
import '../../services/location_service.dart';

class TaskDetailProvider extends ChangeNotifier {
  final _checkIn = CheckIn(sl());
  final _complete = CompleteTask(sl());
  final _loc = AppLocationService();

  TaskEntity? task;
  bool withinRadius = false;
  double distance = 0.0;

  Future<void> setTask(TaskEntity t) async {
    task = t;
    withinRadius = (await _loc.withinRadius(t.lat, t.lng))['withinRadius'];
    distance = (await _loc.withinRadius(t.lat, t.lng))['distanceMeters'];
    notifyListeners();
  }

  Future<void> doCheckIn() async {
    if (task == null) return;
    task = await _checkIn(task!.id, DateTime.now());
    withinRadius = (await _loc.withinRadius(task!.lat, task!.lng))['withinRadius'];
    notifyListeners();
  }

  Future<void> complete(String currentUserId) async {
    if (task == null) return;
    if (task!.assigneeId != currentUserId) {
      throw Exception('Only the assigned agent can complete this task.');
    }
    if (!withinRadius) {
      throw Exception('Please move within 100m of the task location.');
    }
    task = await _complete(task!.id, DateTime.now());
    notifyListeners();
  }

  final _core = sl<LocationServiceCore>();

  void updateDistance(double taskLat, double taskLng, double userLat, double userLng) async {
    try {
      final p = await _core.current();
      final d = _core.distanceMeters(taskLat, taskLng, p.latitude, p.longitude);
      distance = d;
      withinRadius = d <= AppConstraints.checkRadiusMeters;
      notifyListeners();
    } catch (e) {
      debugPrint('Location error: $e');
    }
  }
}
