import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gorev_calisma/controllers/task_controller.dart';
import 'package:gorev_calisma/models/task_model.dart';

class TaskWidget extends StatelessWidget {
  final Task task;
  final TaskController controller = Get.find(); // Get controller instance

  TaskWidget({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: ListTile(
        title: Text(task.title, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(task.description),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Durumu değiştirme butonu
            IconButton(
              icon: Icon(
                task.status ? Icons.check_circle : Icons.cancel,
                color: task.status ? Colors.green : Colors.red,
              ),
              onPressed: () {
                // Durumu değiştirmek için toggle
                controller.toggleTaskStatus(task.id, !task.status);
              },
            ),
            // Düzenleme butonu
            IconButton(
              icon: Icon(Icons.edit, color: const Color.fromARGB(255, 186, 47, 214)),
              onPressed: () {
                _showEditTaskDialog(context, task);
              },
            ),
            // Silme butonu
            IconButton(
              icon: Icon(Icons.delete, color: Colors.black),
              onPressed: () {
                // Görevi silmek için
                controller.deleteTask(task.id);
              },
            ),
          ],
        ),
      ),
    );
  }

  // Görev düzenleme için dialog
  void _showEditTaskDialog(BuildContext context, Task task) {
    final titleController = TextEditingController(text: task.title);
    final descriptionController = TextEditingController(text: task.description);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Görev Düzenle"),
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
                // Görevi güncelle
                controller.updateTask(
                  task.id,
                  titleController.text,
                  descriptionController.text,
                );
                Navigator.pop(context); // Dialog'u kapat
              },
              child: const Text("Kaydet"),
            ),
          ],
        );
      },
    );
  }
}