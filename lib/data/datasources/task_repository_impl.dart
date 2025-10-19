import '../../core/network/connectivity_service.dart';
import '../../domain/entities/task_entity.dart';
import '../../domain/repositories/task_repository.dart';
import '../datasources/task_local_ds.dart';
import '../datasources/task_remote_ds.dart';
import '../model/task_model.dart';

class TaskRepositoryImpl implements TaskRepository {
  final TaskRemoteDataSource remote;
  final TaskLocalDataSource local;
  final ConnectivityService connectivity;

  TaskRepositoryImpl({required this.remote, required this.local, required this.connectivity});

  @override
  Future<List<TaskEntity>> getTasks({
    int page = 1,
    int limit = 20,
    String? search,
  }) async {
    if (await connectivity.isOnline()) {
      final remoteItems = await remote.fetch(page: page, limit: limit, search: search);
      for (final t in remoteItems) {
        await local.upsert(t.copyWith(isDirty: false));
      }
    }

    final offline = await local.list(page: page, limit: limit, search: search);
    return offline.map((m) => m.toEntity()).toList();
  }

  @override
  Future<TaskEntity> createTask(TaskEntity t) async {
    final model = t.toModel().copyWith(isDirty: true);
    await local.upsert(model); // local-first

    if (await connectivity.isOnline()) {
      final created = await remote.create(t.toModel());
      await local.upsert(created.copyWith(isDirty: false));
      return created.toEntity();
    }
    return model.toEntity();
  }

  @override
  Future<TaskEntity> checkIn(String id, DateTime at) async {
    final current = await local.getById(id);
    if (current == null) {
      throw Exception('Task not found locally: $id');
    }

    final updated = current.copyWith(
      checkInAt: at,
      status: TaskStatus.inProgress,
      isDirty: true,
    );
    await local.upsert(updated);

    if (await connectivity.isOnline()) {
      final server = await remote.checkIn(id, at);
      await local.upsert(server.copyWith(isDirty: false));
      return server.toEntity();
    }
    return updated.toEntity();
  }

  @override
  Future<TaskEntity> complete(String id, DateTime at) async {
    final current = await local.getById(id);
    if (current == null) {
      throw Exception('Task not found locally: $id');
    }

    final updated = current.copyWith(
      completedAt: at,
      status: TaskStatus.completed,
      isDirty: true,
    );
    await local.upsert(updated);

    if (await connectivity.isOnline()) {
      final server = await remote.complete(id, at);
      await local.upsert(server.copyWith(isDirty: false));
      return server.toEntity();
    }
    return updated.toEntity();
  }

  @override
  Future<void> sync() async {
    if (!await connectivity.isOnline()) return;
    final dirty = await local.dirty();

    for (final t in dirty) {
      if (t.completedAt != null && t.status == TaskStatus.completed) {
        await remote.complete(t.id, t.completedAt!);
      } else if (t.checkInAt != null && t.status == TaskStatus.inProgress) {
        await remote.checkIn(t.id, t.checkInAt!);
      } else {
        await remote.create(t);
      }
      await local.upsert(t.copyWith(isDirty: false));
    }
  }
}
