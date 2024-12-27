import 'dart:convert';
import 'package:get/get.dart';
import 'package:gorev_calisma/api_service.dart';
import 'package:gorev_calisma/models/task_model.dart';
import 'package:gorev_calisma/connectiviyt.dart';
import 'package:gorev_calisma/screens/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TaskController extends GetxController {
  var isLoading = false.obs;
  var tasks = <Task>[].obs; // Tüm görevleri tutar
  var filteredTasks = <Task>[].obs; // Filtrelenmiş görevleri tutar
  final ApiService apiService = ApiService();
  final ConnectivityService connectivityService = ConnectivityService();

  @override
  void onInit() {
    super.onInit();
    fetchTasks(); // Başlangıçta görevleri al
  }

  // Görevleri API'den al
  Future<void> fetchTasks() async {
    isLoading(true);
    if (await connectivityService.isConnected()) {
      try {
        // API'den görevleri al
        tasks.value = await ApiService.fetchTasks();
        filteredTasks.value = tasks; // İlk başta tüm görevler gösterilsin
        saveTasksLocally(tasks); // API'den alınan görevleri yerel veritabanına kaydet

        // Loglama: API'den alınan görevler
        print("API'den alınan görevler: ${tasks.length} görev bulundu.");
      } catch (e) {
        print('Error fetching tasks: $e');
      }
    } else {
      print('No internet connection');
      loadTasksLocally(); // İnternet yoksa yerel görevleri yükle
    }
    isLoading(false);
  }

  // Yeni görev ekle (offline destekli)
  Future<void> addTask(Task task) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> taskList = prefs.getStringList('tasks') ?? [];

    // Yeni görevi yerel olarak kaydet
    taskList.add(jsonEncode(task.toJson())); // JSON formatında kaydet
    await prefs.setStringList('tasks', taskList);

    // Verileri tekrar yerel olarak yükle
    loadTasksLocally();

    // Loglama: Kaydedilen görevleri kontrol edelim
    print("Yeni görev yerel olarak kaydedildi: ${task.toJson()}");

    // İnternete bağlandığında görevleri senkronize et
    if (await connectivityService.isConnected()) {
      await ApiService.addTask(task);
      fetchTasks(); // Güncel listeyi tekrar çek
    }
  }

  // Yerel görevleri yükle
  void loadTasksLocally() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> taskList = prefs.getStringList('tasks') ?? [];

    if (taskList.isEmpty) {
      print("Yerel görevler bulunamadı.");
    } else {
      // JSON verilerini task nesnelerine çevir
      tasks.value = taskList.map((taskString) {
        final taskJson = jsonDecode(taskString); // JSON stringini Map'e çevir
        return Task.fromJson(taskJson); // Task nesnesine dönüştür
      }).toList();

      // Loglama: Yüklenen görevler
      print("Yerel görevler yüklendi: ${tasks.length} görev bulundu.");
    }

    filteredTasks.value = tasks;
  }

  // Yerel görevleri kaydet
  void saveTasksLocally(List<Task> taskList) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> taskStringList = taskList.map((task) => jsonEncode(task.toJson())).toList();
    await prefs.setStringList('tasks', taskStringList);
  }

  // Görev durumunu değiştir
  Future<void> toggleTaskStatus(String taskId, bool status) async {
    final task = tasks.firstWhere((task) => task.id == taskId);
    task.status = status;
    await ApiService.updateTask(task);
    fetchTasks(); // Güncel listeyi tekrar çek
  }

  // Görev güncelle
  Future<void> updateTask(String taskId, String newTitle, String newDescription) async {
    final task = tasks.firstWhere((task) => task.id == taskId);
    task.title = newTitle;
    task.description = newDescription;
    await ApiService.updateTask(task);
    fetchTasks(); // Güncel listeyi tekrar çek
  }

  // Görev sil
  Future<void> deleteTask(String taskId) async {
    await ApiService.deleteTask(taskId);
    fetchTasks(); // Güncel listeyi tekrar çek
  }

  // Filtreyi uygula
  void applyFilter(String status) {
    if (status == FilterStatus.all) {
      filteredTasks.value = tasks; // Tüm görevleri göster
    } else if (status == FilterStatus.done) {
      filteredTasks.value = tasks.where((task) => task.status == true).toList(); // Tamamlanan görevler
    } else if (status == FilterStatus.notDone) {
      filteredTasks.value = tasks.where((task) => task.status == false).toList(); // Tamamlanmayan görevler
    }

    // Loglama: Uygulanan filtreyi kontrol edelim
    print("Filtre uygulandı: ${filteredTasks.length} görev bulundu.");
  }

  // Senkronizasyon işlemi: İnternet geri geldiğinde yerel görevleri sunucuya gönder
  Future<void> syncOfflineTasks() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> taskList = prefs.getStringList('tasks') ?? [];

    for (var taskString in taskList) {
      Task task = Task.fromJson(jsonDecode(taskString)); // JSON'dan Task nesnesine dönüştür
      await ApiService.addTask(task); // Her bir görevi sunucuya gönder
    }

    // Senkronize edilen görevleri yerel veritabanından sil
    await prefs.remove('tasks');
    fetchTasks(); // Güncel görevleri çek
  }
}