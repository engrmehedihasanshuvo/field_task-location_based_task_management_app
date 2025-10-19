import '../entities/task_entity.dart';

abstract class TaskRepository {
  Future<List<TaskEntity>> getTasks({int page, int limit, String? search});

  Future<TaskEntity> createTask(TaskEntity t);

  Future<TaskEntity> checkIn(String id, DateTime at);

  Future<TaskEntity> complete(String id, DateTime at);

  Future<void> sync();
}
