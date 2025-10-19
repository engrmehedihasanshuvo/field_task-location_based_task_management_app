import 'dart:async';
import 'package:neos_coder/domain/entities/task_entity.dart';
import '../model/task_model.dart';

class TaskRemoteDataSource {
  final List<TaskModel> _mockServer = [];

  TaskRemoteDataSource() {
    _mockServer.addAll([
      TaskModel(id: '1', title: 'Inspect Construction Site', description: 'Check worker attendance and materials.', lat: 23.7808, lng: 90.4071, assigneeId: 'agent-123'),
      TaskModel(id: '2', title: 'Deliver Client Report', description: 'Meet with client ABC.', lat: 23.7708, lng: 90.4000, assigneeId: 'agent-123'),
    ]);
  }

  Future<List<TaskModel>> fetch({int page = 1, int limit = 20, String? search}) async {
    await Future.delayed(const Duration(milliseconds: 600)); // fake latency
    var items = _mockServer;
    if (search != null && search.isNotEmpty) {
      items = items.where((e) => e.title.toLowerCase().contains(search.toLowerCase())).toList();
    }
    final start = (page - 1) * limit;
    final end = (start + limit) > items.length ? items.length : (start + limit);
    return items.sublist(start, end);
  }

  Future<TaskModel> create(TaskModel t) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _mockServer.add(t);
    return t;
  }

  Future<TaskModel> checkIn(String id, DateTime at) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final i = _mockServer.indexWhere((e) => e.id == id);
    if (i == -1) throw Exception('Task not found');
    final updated = _mockServer[i].copyWith(checkInAt: at);
    _mockServer[i] = updated;
    return updated;
  }

  Future<TaskModel> complete(String id, DateTime at) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final i = _mockServer.indexWhere((e) => e.id.toString() == id.toString());
    if (i == -1) throw Exception('Task not found');
    final updated = _mockServer[i].copyWith(completedAt: at, status: TaskStatus.completed);
    _mockServer[i] = updated;
    return updated;
  }
}
