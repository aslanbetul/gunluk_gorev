import 'package:hive/hive.dart';
import 'task_model.dart';

class TaskAdapter extends TypeAdapter<Task> {
  @override
  final int typeId = 0;

  @override
  Task read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };

    return Task(
      id: fields[0] as String,
      title: fields[1] as String,
      description: fields[2] as String,
      status: fields[3] as bool,
      taskDate: fields[4] as int,
    );
  }

  @override
  void write(BinaryWriter writer, Task obj) {
    writer
      ..writeByte(5)  // 5 alan olduğunu belirtiyoruz (id, title, description, status, taskDate)
      ..writeByte(0)  // ID
      ..write(obj.id)
      ..writeByte(1)  // Title
      ..write(obj.title)
      ..writeByte(2)  // Description
      ..write(obj.description)
      ..writeByte(3)  // Status
      ..write(obj.status)
      ..writeByte(4)  // TaskDate
      ..write(obj.taskDate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TaskAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
