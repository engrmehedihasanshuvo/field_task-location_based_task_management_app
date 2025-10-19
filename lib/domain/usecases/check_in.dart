import '../entities/task_entity.dart';
import '../repositories/task_repository.dart';

class CheckIn {
  final TaskRepository repo;

  CheckIn(this.repo);

  Future<TaskEntity> call(String id, DateTime at) => repo.checkIn(id, at);
}
