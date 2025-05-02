import 'package:flutter/material.dart';
import '../../../common_widgets/buttons/primary_button.dart';
import '../../../common_widgets/layouts/screen_container.dart';

class NotFoundScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Map arguments = ModalRoute.of(context)!.settings.arguments as Map;
    final String uid = arguments['uid'];

    return ScreenContainer(
      appBar: AppBar(title: const Text('Asset Not Found')),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Not found icon
          Icon(Icons.error_outline, color: Colors.red, size: 80),

          const SizedBox(height: 16),

          // Title
          const Text(
            'Asset Not Found',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 8),

          // UID display
          Text(
            'UID: $uid',
            style: const TextStyle(fontSize: 18, color: Colors.grey),
          ),

          const SizedBox(height: 32),

          // Info text
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              'The scanned asset was not found in the database. Would you like to register this asset?',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
          ),

          const SizedBox(height: 32),

          // Action buttons
          PrimaryButton(
            text: 'Register New Asset',
            icon: Icons.add_circle_outline,
            onPressed: () {
              // Navigate to register asset screen
            },
          ),

          const SizedBox(height: 16),

          OutlinedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Back to Scan'),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size.fromHeight(50),
            ),
          ),
        ],
      ),
    );
  }
}
