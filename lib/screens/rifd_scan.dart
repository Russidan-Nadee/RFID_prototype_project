import 'package:flutter/material.dart';

class rifd_scan extends StatefulWidget {
  const rifd_scan({super.key});

  @override
  State<rifd_scan> createState() => _rifd_scanState();
}

class _rifd_scanState extends State<rifd_scan> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _uidController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _brandController = TextEditingController();
  final TextEditingController _departmentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("RFID Scan Reader")),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: _uidController,
              decoration: const InputDecoration(
                label: Text("UID", style: TextStyle(fontSize: 20)),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter UID';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _categoryController,
              decoration: const InputDecoration(
                label: Text("Category", style: TextStyle(fontSize: 20)),
              ),
            ),
            TextFormField(
              controller: _brandController,
              decoration: const InputDecoration(
                label: Text("Brand", style: TextStyle(fontSize: 20)),
              ),
            ),
            TextFormField(
              controller: _departmentController,
              decoration: const InputDecoration(
                label: Text("Department", style: TextStyle(fontSize: 20)),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {},
              child: const Text('Save', style: TextStyle(fontSize: 20)),
            ),
          ],
        ),
      ),
    );
  }
}
