import 'package:dio/dio.dart';
import 'package:gorev_calisma/models/task_model.dart';

class ApiService {
  static final Dio _dio = Dio();
  static const String _baseUrl = 'https://671215e34eca2acdb5f706e5.mockapi.io/api/v1/tasks';

  // Tüm görevleri çek
  static Future<List<Task>> fetchTasks() async {
    final response = await _dio.get(_baseUrl);
    if (response.statusCode == 200) {
      List data = response.data;
      return data.map((task) => Task.fromJson(task)).toList();
    } else {
      throw Exception('Veri yüklenemedi');
    }
  }

  // Yeni görev oluştur
  static Future<void> addTask(Task task) async {
    final response = await _dio.post(_baseUrl, data: task.toJson());
    if (response.statusCode != 201) {
      throw Exception('Görev eklenemedi');
    }
  }

  // Görev güncelleme
  static Future<void> updateTask(Task task) async {
    final response = await _dio.put('$_baseUrl/${task.id}', data: task.toJson());
    if (response.statusCode != 200) {
      throw Exception('Görev güncellenemedi');
    }
  }

  // Görev silme
  static Future<void> deleteTask(String taskId) async {
    final response = await _dio.delete('$_baseUrl/$taskId');
    if (response.statusCode != 200) {
      throw Exception('Görev silinemedi');
    }
  }
}
