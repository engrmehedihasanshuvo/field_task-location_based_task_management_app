import 'package:flutter/foundation.dart';
import '../../core/di/locator.dart';
import '../../domain/entities/task_entity.dart';
import '../../domain/usecases/get_tasks.dart';

class TaskListProvider extends ChangeNotifier {
  final _getTasks = GetTasks(sl());
  final List<TaskEntity> _items = [];

  List<TaskEntity> get items => List.unmodifiable(_items);
  bool _loading = false;

  bool get loading => _loading;
  bool _hasMore = true;

  bool get hasMore => _hasMore;
  int _page = 1;
  String _search = '';

  Future<void> refresh({String search = ''}) async {
    _items.clear();
    _page = 1;
    _hasMore = true;
    _search = search;
    await loadMore(isFirstTime: false);
  }

  Future<void> loadMore({bool isFirstTime = true}) async {
    if (_loading || !_hasMore) return;
    _loading = true;
    final res = await _getTasks(page: _page, limit: 20, search: _search);
    _items.addAll(res);
    _hasMore = res.length == 20;
    _page++;
    _loading = false;
    notifyListeners();
  }
}
