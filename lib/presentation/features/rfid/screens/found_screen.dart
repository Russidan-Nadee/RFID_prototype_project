import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../domain/usecases/update_asset_usecase.dart';
import '../../../common_widgets/buttons/primary_button.dart';
import '../../../common_widgets/layouts/screen_container.dart';
import '../widgets/scan_result_display.dart';

class FoundScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Map arguments = ModalRoute.of(context)!.settings.arguments as Map;
    final String uid = arguments['uid'];
    final UpdateAssetUseCase updateAssetUseCase =
        context.read<UpdateAssetUseCase>();

    return ScreenContainer(
      appBar: AppBar(title: const Text('Asset Found')),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 24),

          // Success icon
          Icon(Icons.check_circle, color: Colors.green, size: 80),

          const SizedBox(height: 16),

          // Title
          const Text(
            'Asset Found!',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 8),

          // UID display
          Text(
            'UID: $uid',
            style: const TextStyle(fontSize: 18, color: Colors.grey),
          ),

          const SizedBox(height: 32),

          // Asset details
          ScanResultDisplay(uid: uid),

          const Spacer(),

          // Action buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: PrimaryButton(
                  text: 'Check In',
                  icon: Icons.check_circle_outline,
                  color: Colors.green,
                  onPressed: () async {
                    await updateAssetUseCase.execute(uid, 'Checked In');
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Asset checked in successfully'),
                      ),
                    );
                    Navigator.pop(context);
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: PrimaryButton(
                  text: 'Check Out',
                  icon: Icons.logout,
                  color: Colors.orange,
                  onPressed: () async {
                    await updateAssetUseCase.execute(uid, 'Checked Out');
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Asset checked out successfully'),
                      ),
                    );
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Back button
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
