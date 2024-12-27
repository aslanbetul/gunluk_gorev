import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:gorev_calisma/screens/home_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false, // "Debug" etiketi kaldırıldı
      title: 'Görev Yönetimi',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}
