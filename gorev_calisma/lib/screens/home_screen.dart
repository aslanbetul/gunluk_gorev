import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gorev_calisma/controllers/task_controller.dart';
import 'package:gorev_calisma/models/task_model.dart';
import 'package:gorev_calisma/widgets/task_widget.dart';

class HomeScreen extends StatelessWidget {
  final TaskController controller = Get.put(TaskController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("GÖREV YÖNETİMİM"),
        actions: [
          // Sağ üst köşede filtreleme menüsü
          PopupMenuButton<String>(
            onSelected: (String status) {
              controller.applyFilter(status); // Seçilen filtreyi uygula
            },
            itemBuilder: (BuildContext context) => [
              PopupMenuItem(
                value: FilterStatus.all,
                child: Row(
                  children: const [
                    Icon(Icons.all_inclusive, color: Colors.black),
                    SizedBox(width: 8),
                    Text("Tüm Görevler")
                  ],
                ),
              ),
              PopupMenuItem(
                value: FilterStatus.done,
                child: Row(
                  children: const [
                    Icon(Icons.check_circle, color: Colors.green),
                    SizedBox(width: 8),
                    Text("Tamamlananlar")
                  ],
                ),
              ),
              PopupMenuItem(
                value: FilterStatus.notDone,
                child: Row(
                  children: const [
                    Icon(Icons.cancel, color: Colors.red),
                    SizedBox(width: 8),
                    Text("Tamamlanmayanlar")
                  ],
                ),
              ),
            ],
          ),
          // Sağ üst köşede arama simgesi
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black),
            onPressed: () {
              showSearch(
                  context: context, delegate: TaskSearchDelegate(controller));
            },
          ),
        ],
      ),
      body: Obx(() {
        // Veriler yükleniyor ise gösterilen loading indicator
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        // Eğer görev listesi boşsa
        if (controller.filteredTasks.isEmpty) {
          return const Center(child: Text("Görev bulunmamaktadır"));
        }

        // Görev listesi varsa
        return ListView.builder(
          itemCount: controller.filteredTasks.length,
          itemBuilder: (context, index) {
            final task = controller.filteredTasks[index];
            return TaskWidget(task: task);
          },
        );
      }),
      floatingActionButton: Stack(
        children: [
          // Floating action button üzerinde yazı ve + simgesi
          Positioned(
            bottom: 10,
            right: 10,
            child: FloatingActionButton.extended(
              onPressed: () => _showAddTaskDialog(context),
              icon: const Icon(
                Icons.add
                 ),
              label: const Text("Yeni Görev Ekle",style: TextStyle(color: Colors.black),),
              backgroundColor: Colors.blue[100],
            ),
          ),
        ],
      ),
    );
  }

  // Yeni görev eklemek için dialog ekranı
  void _showAddTaskDialog(BuildContext context) {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Yeni Görev Ekle"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Başlık'),
              ),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: 'Açıklama'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Dialog'u kapat
              },
              child: const Text("İptal"),
            ),
            ElevatedButton(
              onPressed: () {
                // Yeni görev oluştur
                final newTask = Task(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  title: titleController.text,
                  description: descriptionController.text,
                  status: false, // Varsayılan olarak yapılmadı
                  taskDate: DateTime.now().millisecondsSinceEpoch,
                );

                controller.addTask(newTask);
                Navigator.pop(context); // Dialog'u kapat
              },
              child: const Text("Görev Ekle"),
            ),
          ],
        );
      },
    );
  }
}

class FilterStatus {
  static const String all = 'all';
  static const String done = 'done';
  static const String notDone = 'notDone';
}

class TaskSearchDelegate extends SearchDelegate {
  final TaskController controller;

  TaskSearchDelegate(this.controller);

  @override
  List<Widget> buildActions(BuildContext context) {
    // Arama işlemi yapılırken kullanıcı "X" ile temizleme işlemi yapabilir
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = ''; // Arama kutusunu temizler
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // Arama butonunun solunda "geri" butonu yer alır
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null); // Arama ekranını kapatır
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // Arama sonuçları: Arama yapılan kriterlere göre görevleri filtrele
    final results = controller.filteredTasks.where((task) {
      return task.title.toLowerCase().contains(query.toLowerCase()) ||
          task.description.toLowerCase().contains(query.toLowerCase());
    }).toList();

    // Arama sonuçlarını göster
    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final task = results[index];
        return TaskWidget(task: task);
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Arama başladığında gösterilecek öneriler yerine buildResults fonksiyonuna yönlendirme yapıyoruz
    return Container(); // Boş bir container döndürerek öneri listesini engelliyoruz
  }
}