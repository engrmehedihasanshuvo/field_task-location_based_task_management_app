import 'package:flutter/material.dart';
import 'package:neos_coder/presentation/pages/create_task_page.dart';
import 'package:provider/provider.dart';

import '../../main.dart';
import '../providers/task_list_provider.dart';
import '../widgets/task_card.dart';
import 'task_detail_page.dart';

class TasksPage extends StatefulWidget {
  const TasksPage({super.key});

  @override
  State<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> with RouteAware {
  final _controller = ScrollController();
  final _search = TextEditingController();

  @override
  void initState() {
    super.initState();
    final p = context.read<TaskListProvider>();
    p.refresh();
    _controller.addListener(() {
      if (_controller.position.pixels >= _controller.position.maxScrollExtent - 200) {
        p.loadMore();
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    appRouteObserver.subscribe(this, ModalRoute.of(context)! as PageRoute);
  }

  @override
  void didPopNext() {
    context.read<TaskListProvider>().refresh(search: _search.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Today’s Tasks'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(64),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: TextField(
              controller: _search,
              decoration: InputDecoration(
                hintText: 'Search by title…',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
              onSubmitted: (v) => context.read<TaskListProvider>().refresh(search: v),
            ),
          ),
        ),
      ),
      body: Consumer<TaskListProvider>(
        builder: (_, p, __) => RefreshIndicator(
          onRefresh: () => p.refresh(search: _search.text),
          child: ListView.separated(
            controller: _controller,
            physics: BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
            itemCount: p.items.length + (p.hasMore ? 1 : 0),
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (_, i) {
              if (i >= p.items.length) {
                return const Center(child: Padding(padding: EdgeInsets.all(16), child: CircularProgressIndicator()));
              }
              final t = p.items[i];
              return TaskCard(
                task: t,
                onTap: () async {
                  final changed = await Navigator.push(context, MaterialPageRoute(builder: (_) => TaskDetailPage(task: t)));
                  if (changed == true && context.mounted) {
                    await context.read<TaskListProvider>().refresh(search: _search.text);
                  }
                },
              );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final changed = await Navigator.push(context, MaterialPageRoute(builder: (_) => const CreateTaskPage()));
          if (changed == true && context.mounted) {
            await context.read<TaskListProvider>().refresh(search: _search.text);
          }
        },
        icon: const Icon(Icons.add),
        label: const Text('New Task'),
      ),
    );
  }
}
