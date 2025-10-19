import '../entities/task_entity.dart';
import '../repositories/task_repository.dart';

class CompleteTask {
  final TaskRepository repo;

  CompleteTask(this.repo);

  Future<TaskEntity> call(String id, DateTime at) => repo.complete(id, at);
}
