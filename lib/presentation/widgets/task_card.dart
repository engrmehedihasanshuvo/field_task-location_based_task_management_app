import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/task_entity.dart';
import 'status_chip.dart';

class TaskCard extends StatelessWidget {
  final TaskEntity task;
  final VoidCallback? onTap;

  const TaskCard({super.key, required this.task, this.onTap});

  @override
  Widget build(BuildContext context) {
    final due = task.dueAt != null ? DateFormat('MMM d, h:mm a').format(task.dueAt!) : 'No deadline';
    final icon = switch (task.status) {
      TaskStatus.completed => Icons.check,
      TaskStatus.inProgress => Icons.play_arrow,
      TaskStatus.pending => Icons.schedule,
    };
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Ink(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: const Offset(0, 4))],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              CircleAvatar(radius: 22, child: Icon(icon)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(task.title, style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 4),
                  Text(due, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey[700])),
                ]),
              ),
              StatusChip(status: task.status),
            ],
          ),
        ),
      ),
    );
  }
}
