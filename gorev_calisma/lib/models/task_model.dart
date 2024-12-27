class Task {
  String id; // Görevin benzersiz ID'si
  String title; // Görevin başlığı
  String description; // Görevin açıklaması
  bool status; // Görev tamamlandı mı?
  int taskDate; // Görevin oluşturulduğu tarih (timestamp formatında)

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.taskDate,
  });

  // JSON'dan Task nesnesine dönüştürme
  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'] ?? '',  // id alanı null olamaz, varsayılan boş string
      title: json['title'] ?? '',  // title alanı null olamaz, varsayılan boş string
      description: json['description'] ?? '',  // description alanı null olamaz, varsayılan boş string
      status: json['status'] is bool ? json['status'] : false,  // status için boolean kontrolü
      taskDate: json['taskDate'] != null ? json['taskDate'] : 0,  // taskDate null kontrolü ve varsayılan değer
    );
  }

  // Task nesnesini JSON'a dönüştürme
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'status': status,
      'taskDate': taskDate,
    };
  }
}

