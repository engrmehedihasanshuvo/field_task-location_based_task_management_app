import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import '../model/task_model.dart';
import '../../domain/entities/task_entity.dart';

class TaskLocalDataSource {
  Database? _db;

  Future<void> init() async {
    final dir = await getApplicationDocumentsDirectory();
    _db = await openDatabase(
      p.join(dir.path, 'field_task.db'),
      version: 1,
      onCreate: (db, _) async {
        await db.execute('''
          CREATE TABLE tasks(
            id TEXT PRIMARY KEY,
            title TEXT,
            description TEXT,
            dueAt TEXT,
            lat REAL, lng REAL,
            assigneeId TEXT,
            status INTEGER,
            checkInAt TEXT,
            completedAt TEXT,
            isDirty INTEGER,
            isDeleted INTEGER
          )
        ''');
      },
    );
  }

  Future<void> upsert(TaskModel t) async {
    await _db!.insert('tasks', _encode(t), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<TaskModel>> list({int page = 1, int limit = 20, String? search}) async {
    final offset = (page - 1) * limit;
    final where = (search?.isNotEmpty ?? false) ? 'WHERE title LIKE ?' : '';
    final args = (search?.isNotEmpty ?? false) ? ['%$search%'] : [];
    final rows = await _db!.rawQuery(
      'SELECT * FROM tasks $where ORDER BY dueAt ASC LIMIT ? OFFSET ?',
      [...args, limit, offset],
    );
    return rows.map(_decode).toList();
  }

  Future<TaskModel?> getById(String id) async {
    final rows = await _db!.query('tasks', where: 'id=?', whereArgs: [id], limit: 1);
    if (rows.isEmpty) return null;
    return _decode(rows.first);
  }

  Future<List<TaskModel>> dirty() async {
    final rows = await _db!.query('tasks', where: 'isDirty=1 OR isDeleted=1');
    return rows.map(_decode).toList();
  }

  Map<String, Object?> _encode(TaskModel t) => {
        'id': t.id,
        'title': t.title,
        'description': t.description,
        'dueAt': t.dueAt?.toIso8601String(),
        'lat': t.lat,
        'lng': t.lng,
        'assigneeId': t.assigneeId,
        'status': t.status.index,
        'checkInAt': t.checkInAt?.toIso8601String(),
        'completedAt': t.completedAt?.toIso8601String(),
        'isDirty': t.isDirty ? 1 : 0,
        'isDeleted': t.isDeleted ? 1 : 0,
      };

  TaskModel _decode(Map<String, Object?> m) => TaskModel(
        id: m['id'] as String,
        title: m['title'] as String,
        description: m['description'] as String?,
        dueAt: (m['dueAt'] as String?) != null ? DateTime.parse(m['dueAt'] as String) : null,
        lat: (m['lat'] as num).toDouble(),
        lng: (m['lng'] as num).toDouble(),
        assigneeId: m['assigneeId'] as String,
        status: TaskStatus.values[m['status'] as int],
        checkInAt: (m['checkInAt'] as String?) != null ? DateTime.parse(m['checkInAt'] as String) : null,
        completedAt: (m['completedAt'] as String?) != null ? DateTime.parse(m['completedAt'] as String) : null,
        isDirty: (m['isDirty'] as int) == 1,
        isDeleted: (m['isDeleted'] as int) == 1,
      );
}
