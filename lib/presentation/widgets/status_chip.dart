import 'package:flutter/material.dart';

import '../../domain/entities/task_entity.dart';

class StatusChip extends StatelessWidget {
  final TaskStatus status;

  const StatusChip({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final (label, color) = switch (status) {
      TaskStatus.pending => ('Pending', Colors.orange),
      TaskStatus.inProgress => ('In progress', Colors.blue),
      TaskStatus.completed => ('Done', Colors.green),
    };
    return Chip(label: Text(label), backgroundColor: color.withOpacity(.12));
  }
}
