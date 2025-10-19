// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TaskModelImpl _$$TaskModelImplFromJson(Map<String, dynamic> json) =>
    _$TaskModelImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      dueAt: json['dueAt'] == null
          ? null
          : DateTime.parse(json['dueAt'] as String),
      lat: (json['lat'] as num).toDouble(),
      lng: (json['lng'] as num).toDouble(),
      assigneeId: json['assigneeId'] as String,
      status: $enumDecodeNullable(_$TaskStatusEnumMap, json['status']) ??
          TaskStatus.pending,
      checkInAt: json['checkInAt'] == null
          ? null
          : DateTime.parse(json['checkInAt'] as String),
      completedAt: json['completedAt'] == null
          ? null
          : DateTime.parse(json['completedAt'] as String),
      isDirty: json['isDirty'] as bool? ?? false,
      isDeleted: json['isDeleted'] as bool? ?? false,
    );

Map<String, dynamic> _$$TaskModelImplToJson(_$TaskModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'dueAt': instance.dueAt?.toIso8601String(),
      'lat': instance.lat,
      'lng': instance.lng,
      'assigneeId': instance.assigneeId,
      'status': _$TaskStatusEnumMap[instance.status]!,
      'checkInAt': instance.checkInAt?.toIso8601String(),
      'completedAt': instance.completedAt?.toIso8601String(),
      'isDirty': instance.isDirty,
      'isDeleted': instance.isDeleted,
    };

const _$TaskStatusEnumMap = {
  TaskStatus.pending: 'pending',
  TaskStatus.inProgress: 'inProgress',
  TaskStatus.completed: 'completed',
};
