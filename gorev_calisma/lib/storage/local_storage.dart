import 'package:gorev_calisma/models/task_model.dart';
import 'package:hive/hive.dart';


class LocalStorage {
  static late Box<Task> _taskBox;

  // Hive veritabanını başlat
  static Future<void> init() async {
    _taskBox = await Hive.openBox<Task>('tasks');
  }

  // Görevleri yerelden al
  static List<Task> getTasks() {
    return _taskBox.values.toList();
  }

  // Görev ekle
  static Future<void> addTask(Task task) async {
    await _taskBox.put(task.id, task);
  }

  // Görev güncelle
  static Future<void> updateTask(Task task) async {
    await _taskBox.put(task.id, task);
  }

  // Görev sil
  static Future<void> deleteTask(String taskId) async {
    await _taskBox.delete(taskId);
  }

  // Görevleri temizle (senkronize edildikten sonra)
  static Future<void> clearTasks() async {
    await _taskBox.clear();
  }
}