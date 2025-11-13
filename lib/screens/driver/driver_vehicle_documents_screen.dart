// lib/screens/driver/driver_vehicle_documents_screen.dart
// Upload or view vehicle documents (placeholder UI)

import 'package:flutter/material.dart';

class DriverVehicleDocumentsScreen extends StatefulWidget {
  final Map<String, dynamic> user;
  const DriverVehicleDocumentsScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<DriverVehicleDocumentsScreen> createState() => _DriverVehicleDocumentsScreenState();
}

class _DriverVehicleDocumentsScreenState extends State<DriverVehicleDocumentsScreen> {
  bool uploading = false;
  // in production use `image_picker` or file_picker

  Future<void> _mockUpload(String name) async {
    setState(() => uploading = true);
    await Future.delayed(const Duration(seconds: 1));
    setState(() => uploading = false);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("$name файлыг байршууллаа")));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Тээврийн хэрэгслийн баримт")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ListTile(leading: const Icon(Icons.drive_eta), title: const Text("Тээврийн хэрэгслийн гэрчилгээ"), trailing: ElevatedButton(onPressed: () => _mockUpload("Гэрчилгээ"), child: const Text("Ап"),),),
            const Divider(),
            ListTile(leading: const Icon(Icons.badge), title: const Text("Жолоочийн үнэмлэх"), trailing: ElevatedButton(onPressed: () => _mockUpload("Жолоочийн үнэмлэх"), child: const Text("Ап"),),),
            const Divider(),
            ListTile(leading: const Icon(Icons.security), title: const Text("Даатгал"), trailing: ElevatedButton(onPressed: () => _mockUpload("Даатгал"), child: const Text("Ап"),),),
            const Spacer(),
            uploading ? const LinearProgressIndicator() : const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}