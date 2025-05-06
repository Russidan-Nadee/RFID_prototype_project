import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../common_widgets/buttons/primary_button.dart';
import '../../../common_widgets/layouts/screen_container.dart';
import '../../../common_widgets/inputs/text_input.dart';
import '../../../../domain/usecases/assets/create_asset_usecase.dart';

class NotFoundScreen extends StatefulWidget {
  final String uid;

  const NotFoundScreen({Key? key, required this.uid}) : super(key: key);

  @override
  State<NotFoundScreen> createState() => _NotFoundScreenState();
}

class _NotFoundScreenState extends State<NotFoundScreen> {
  final TextEditingController _assetIdController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _departmentController = TextEditingController();
  final TextEditingController _brandController = TextEditingController();

  bool _isCreating = false;

  @override
  void dispose() {
    _assetIdController.dispose();
    _categoryController.dispose();
    _departmentController.dispose();
    _brandController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenContainer(
      appBar: AppBar(title: const Text('Asset Not Found')),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // แสดงข้อความว่าไม่พบสินทรัพย์
            const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: Icon(
                  Icons.error_outline,
                  color: Colors.orange,
                  size: 64,
                ),
              ),
            ),

            Center(
              child: Text(
                'No asset found with UID: ${widget.uid}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange,
                ),
                textAlign: TextAlign.center,
              ),
            ),

            const SizedBox(height: 24),

            // คำอธิบาย
            const Text(
              'Would you like to register this as a new asset?',
              style: TextStyle(fontSize: 16),
            ),

            const SizedBox(height: 24),

            // ฟอร์มสร้างสินทรัพย์ใหม่
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'New Asset Information',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),

                    const SizedBox(height: 16),

                    // ช่องกรอกรหัสสินทรัพย์
                    TextInput(
                      controller: _assetIdController,
                      label: 'Asset ID',
                      hint: 'Enter asset ID',
                      prefixIcon: Icons.inventory,
                    ),

                    const SizedBox(height: 16),

                    // ช่องกรอกแบรนด์
                    TextInput(
                      controller: _brandController,
                      label: 'Brand',
                      hint: 'Enter brand',
                      prefixIcon: Icons.business,
                    ),

                    const SizedBox(height: 16),

                    // ช่องกรอกหมวดหมู่
                    TextInput(
                      controller: _categoryController,
                      label: 'Category',
                      hint: 'Enter category',
                      prefixIcon: Icons.category,
                    ),

                    const SizedBox(height: 16),

                    // ช่องกรอกแผนก
                    TextInput(
                      controller: _departmentController,
                      label: 'Department',
                      hint: 'Enter department',
                      prefixIcon: Icons.apartment,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // ปุ่มบันทึกสินทรัพย์ใหม่
            Center(
              child: PrimaryButton(
                text: 'Register New Asset',
                icon: Icons.add_circle_outline,
                isLoading: _isCreating,
                onPressed: _registerNewAsset,
              ),
            ),

            const SizedBox(height: 16),

            // ปุ่มกลับไปหน้าสแกน
            Center(
              child: TextButton(
                onPressed: () {
                  Navigator.of(
                    context,
                  ).popUntil((route) => route.settings.name == '/scanRfid');
                },
                child: const Text('Back to Scanner'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ฟังก์ชันบันทึกสินทรัพย์ใหม่
  Future<void> _registerNewAsset() async {
    // ตรวจสอบข้อมูลที่กรอก
    if (_assetIdController.text.isEmpty ||
        _categoryController.text.isEmpty ||
        _departmentController.text.isEmpty ||
        _brandController.text.isEmpty) {
      // แสดงข้อความเตือน
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all fields'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isCreating = true;
    });

    try {
      // สร้างสินทรัพย์ใหม่ในระบบโดยใช้ CreateAssetUseCase
      final createAssetUseCase = Provider.of<CreateAssetUseCase>(
        context,
        listen: false,
      );
      final newAsset = await createAssetUseCase.execute(
        id: _assetIdController.text,
        uid: widget.uid,
        category: _categoryController.text,
        brand: _brandController.text,
        department: _departmentController.text,
      );

      if (newAsset != null) {
        // แสดงข้อความว่าสร้างสำเร็จ
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('New asset registered successfully'),
            backgroundColor: Colors.green,
          ),
        );

        // กลับไปหน้าสแกน
        Navigator.of(
          context,
        ).popUntil((route) => route.settings.name == '/scanRfid');
      } else {
        // แสดงข้อความว่าเกิดข้อผิดพลาด
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to register new asset'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      // แสดงข้อความว่าเกิดข้อผิดพลาด
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isCreating = false;
      });
    }
  }
}
