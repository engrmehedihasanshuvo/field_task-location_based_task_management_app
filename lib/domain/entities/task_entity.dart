enum TaskStatus { pending, inProgress, completed }

class TaskEntity {
  final String id;
  final String title;
  final String? description;
  final DateTime? dueAt;
  final double lat, lng;
  final String assigneeId;
  final TaskStatus status;
  final DateTime? checkInAt;
  final DateTime? completedAt;

  const TaskEntity({
    required this.id,
    required this.title,
    this.description,
    this.dueAt,
    required this.lat,
    required this.lng,
    required this.assigneeId,
    this.status = TaskStatus.pending,
    this.checkInAt,
    this.completedAt,
  });
}
