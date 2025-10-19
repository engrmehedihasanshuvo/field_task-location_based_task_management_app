import '../core/di/locator.dart';
import '../core/network/connectivity_service.dart';
import '../domain/repositories/task_repository.dart';

class SyncService {
  final _repo = sl<TaskRepository>();
  final _conn = sl<ConnectivityService>();

  Future<void> trySync() async {
    if (await _conn.isOnline()) {
      await _repo.sync();
    }
  }
}
