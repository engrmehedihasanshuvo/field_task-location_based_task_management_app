import '../entities/task_entity.dart';
import '../repositories/task_repository.dart';

class GetTasks {
  final TaskRepository repo;

  GetTasks(this.repo);

  Future<List<TaskEntity>> call({int page = 1, int limit = 20, String? search}) => repo.getTasks(page: page, limit: limit, search: search);
}
