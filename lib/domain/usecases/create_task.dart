import '../repositories/task_repository.dart';
import '../entities/task_entity.dart';

class CreateTask {
  final TaskRepository repo;

  CreateTask(this.repo);

  Future<TaskEntity> call(TaskEntity t) => repo.createTask(t);
}
