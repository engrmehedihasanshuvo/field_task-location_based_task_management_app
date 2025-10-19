import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:neos_coder/domain/entities/task_entity.dart';

part 'task_model.freezed.dart';
part 'task_model.g.dart';

@freezed
class TaskModel with _$TaskModel {
  const factory TaskModel({
    required String id,
    required String title,
    String? description,
    DateTime? dueAt,
    required double lat,
    required double lng,
    required String assigneeId,
    @Default(TaskStatus.pending) TaskStatus status,
    DateTime? checkInAt,
    DateTime? completedAt,
    @Default(false) bool isDirty,
    @Default(false) bool isDeleted,
  }) = _TaskModel;

  factory TaskModel.fromJson(Map<String, dynamic> json) => _$TaskModelFromJson(json);
}

extension TaskModelMapper on TaskModel {
  TaskEntity toEntity() => TaskEntity(
        id: id,
        title: title,
        description: description,
        dueAt: dueAt,
        lat: lat,
        lng: lng,
        assigneeId: assigneeId,
        status: status,
        checkInAt: checkInAt,
        completedAt: completedAt,
      );
}

extension TaskEntityMapper on TaskEntity {
  TaskModel toModel() => TaskModel(
        id: id,
        title: title,
        description: description,
        dueAt: dueAt,
        lat: lat,
        lng: lng,
        assigneeId: assigneeId,
        status: status,
        checkInAt: checkInAt,
        completedAt: completedAt,
      );
}
