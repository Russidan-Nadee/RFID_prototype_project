import 'dart:io';

void main() async {
  print('เริ่มสร้างโครงสร้างโฟลเดอร์สำหรับไมโครเซอร์วิส...');

  // กำหนดโฟลเดอร์รูทของโปรเจ็กต์
  final String projectRoot = Directory.current.path;
  print('โฟลเดอร์รูทของโปรเจ็กต์: $projectRoot');

  // สร้างโฟลเดอร์ระดับบนสุด (ถ้ายังไม่มี)
  await createFoldersIfNotExist([
    '$projectRoot/docker',
    '$projectRoot/kubernetes',
    '$projectRoot/config',
  ]);

  // ย้ายไฟล์ analysis_options.yaml และ devtools_options.yaml ไปที่ config (ถ้ามี)
  await moveFileIfExists(
    '$projectRoot/analysis_options.yaml',
    '$projectRoot/config/analysis_options.yaml',
  );
  await moveFileIfExists(
    '$projectRoot/devtools_options.yaml',
    '$projectRoot/config/devtools_options.yaml',
  );

  // สร้างโครงสร้างโฟลเดอร์ใน lib
  await createStructureInLib(projectRoot);

  print('สร้างโครงสร้างโฟลเดอร์เสร็จสมบูรณ์!');
}

Future<void> createFoldersIfNotExist(List<String> paths) async {
  for (var path in paths) {
    final dir = Directory(path);
    if (!await dir.exists()) {
      await dir.create(recursive: true);
      print('สร้างโฟลเดอร์: $path');
    } else {
      print('โฟลเดอร์มีอยู่แล้ว: $path');
    }
  }
}

Future<void> moveFileIfExists(String sourcePath, String destinationPath) async {
  final sourceFile = File(sourcePath);
  if (await sourceFile.exists()) {
    await sourceFile.copy(destinationPath);
    await sourceFile.delete();
    print('ย้ายไฟล์จาก $sourcePath ไปที่ $destinationPath');
  }
}

Future<void> createEmptyFile(String path) async {
  final file = File(path);
  if (!await file.exists()) {
    await file.create(recursive: true);
    print('สร้างไฟล์: $path');
  } else {
    print('ไฟล์มีอยู่แล้ว: $path');
  }
}

Future<void> createStructureInLib(String projectRoot) async {
  final libPath = '$projectRoot/lib';

  // สร้างไฟล์ main.dart ในโฟลเดอร์ lib หลัก
  await createEmptyFile('$libPath/main.dart');

  // โครงสร้างใน lib
  final structure = {
    'core': {
      'configuration': ['app_config.dart', 'environment.dart'],
      'constants': [
        'app_constants.dart',
        'api_constants.dart',
        'ui_constants.dart',
      ],
      'exceptions': ['app_exceptions.dart', 'error_handler.dart'],
      'utils': [
        'date_utils.dart',
        'string_utils.dart',
        'validation_utils.dart',
      ],
    },
    'features': {
      'assets': {
        'bloc': ['asset_bloc.dart', 'asset_event.dart', 'asset_state.dart'],
        'models': ['asset_view_model.dart'],
        'pages': ['view_assets_page.dart', 'asset_detail_page.dart'],
        'repositories': ['asset_repository.dart'],
        'widgets': ['asset_list_item.dart', 'asset_filter.dart'],
      },
      'dashboard': {
        'bloc': [
          'dashboard_bloc.dart',
          'dashboard_event.dart',
          'dashboard_state.dart',
        ],
        'models': ['dashboard_stats_model.dart'],
        'pages': ['dashboard_page.dart'],
        'repositories': ['dashboard_repository.dart'],
        'widgets': ['stat_card.dart', 'dashboard_header.dart'],
      },
      'export': {
        'bloc': ['export_bloc.dart', 'export_event.dart', 'export_state.dart'],
        'models': ['export_options_model.dart'],
        'pages': ['export_page.dart'],
        'repositories': ['export_repository.dart'],
        'widgets': ['column_selector.dart', 'export_button.dart'],
      },
      'rfid': {
        'bloc': ['rfid_bloc.dart', 'rfid_event.dart', 'rfid_state.dart'],
        'models': ['scan_result_model.dart'],
        'pages': [
          'scan_page.dart',
          'asset_found_page.dart',
          'asset_not_found_page.dart',
        ],
        'repositories': ['rfid_repository.dart'],
        'widgets': ['scan_button.dart', 'scan_result_card.dart'],
      },
      'search': {
        'bloc': ['search_bloc.dart', 'search_event.dart', 'search_state.dart'],
        'models': ['search_result_model.dart'],
        'pages': ['search_page.dart'],
        'repositories': ['search_repository.dart'],
        'widgets': ['search_bar.dart', 'search_result_item.dart'],
      },
    },
    'services': {
      'api_gateway': {
        'main.dart': null, // เพิ่มไฟล์ main.dart
        'controllers': ['api_controller.dart', 'auth_controller.dart'],
        'middleware': ['auth_middleware.dart', 'logging_middleware.dart'],
        'routes': ['api_routes.dart', 'route_configurator.dart'],
      },
      'asset_service': {
        'main.dart': null, // เพิ่มไฟล์ main.dart
        'api': {
          'controllers': ['asset_controller.dart'],
          'routes': ['asset_routes.dart'],
        },
        'data': {
          'datasources': {
            'local': ['asset_database.dart'],
            'remote': ['asset_api.dart'],
          },
          'models': ['asset_model.dart'],
          'repositories': ['asset_repository_impl.dart'],
        },
        'domain': {
          'entities': ['asset.dart'],
          'repositories': ['asset_repository.dart'],
          'usecases': [
            'get_assets_usecase.dart',
            'search_asset_usecase.dart',
            'update_asset_usecase.dart',
          ],
        },
      },
      'dashboard_service': {
        'main.dart': null, // เพิ่มไฟล์ main.dart
        'api': {
          'controllers': ['dashboard_controller.dart'],
          'routes': ['dashboard_routes.dart'],
        },
        'data': {
          'datasources': {
            'remote': ['asset_service_client.dart', 'rfid_service_client.dart'],
          },
          'models': ['dashboard_stats_model.dart'],
          'repositories': ['dashboard_repository_impl.dart'],
        },
        'domain': {
          'entities': ['dashboard_stats.dart'],
          'repositories': ['dashboard_repository.dart'],
          'usecases': ['get_dashboard_stats_usecase.dart'],
        },
      },
      'export_service': {
        'main.dart': null, // เพิ่มไฟล์ main.dart
        'api': {
          'controllers': ['export_controller.dart'],
          'routes': ['export_routes.dart'],
        },
        'data': {
          'datasources': {
            'local': ['export_database.dart'],
            'remote': ['asset_service_client.dart'],
          },
          'models': ['export_model.dart'],
          'repositories': ['export_repository_impl.dart'],
        },
        'domain': {
          'entities': ['export_record.dart'],
          'repositories': ['export_repository.dart'],
          'usecases': [
            'export_assets_usecase.dart',
            'get_export_history_usecase.dart', // เพิ่มไฟล์ get_export_history_usecase.dart
          ],
        },
      },
      'rfid_service': {
        'main.dart': null, // เพิ่มไฟล์ main.dart
        'api': {
          'controllers': ['rfid_controller.dart'],
          'routes': ['rfid_routes.dart'],
        },
        'data': {
          'datasources': {
            'local': ['rfid_device_interface.dart'],
            'remote': ['asset_service_client.dart'],
          },
          'models': ['rfid_scan_model.dart'],
          'repositories': ['rfid_repository_impl.dart'],
        },
        'domain': {
          'entities': ['rfid_scan.dart'],
          'repositories': ['rfid_repository.dart'],
          'usecases': [
            'scan_rfid_usecase.dart',
            'find_asset_by_uid_usecase.dart',
          ],
        },
      },
    },
    'shared': {
      'components': {
        'buttons': ['primary_button.dart', 'icon_button.dart'],
        'inputs': ['text_field.dart', 'search_field.dart'],
        'layout': ['app_scaffold.dart', 'bottom_navigation.dart'],
      },
      'models': ['api_response.dart', 'pagination_model.dart'],
      'utils': ['ui_utils.dart', 'theme_utils.dart'],
    },
  };

  // สร้างโฟลเดอร์และไฟล์ตามโครงสร้าง
  await _createStructureRecursive(libPath, structure);

  // สร้างไฟล์ docker-compose.yaml
  await createEmptyFile('$projectRoot/docker-compose.yaml');

  // สร้างไฟล์ Dockerfile สำหรับแต่ละบริการ
  for (var service in [
    'asset_service',
    'dashboard_service',
    'export_service',
    'rfid_service',
    'api_gateway',
  ]) {
    await createEmptyFile('$projectRoot/docker/$service.dockerfile');
  }

  // สร้างไฟล์ Kubernetes สำหรับแต่ละบริการ
  for (var service in [
    'asset_service',
    'dashboard_service',
    'export_service',
    'rfid_service',
    'api_gateway',
    'database',
  ]) {
    await createEmptyFile('$projectRoot/kubernetes/$service.yaml');
  }
}

Future<void> _createStructureRecursive(
  String basePath,
  Map<String, dynamic> structure,
) async {
  for (var key in structure.keys) {
    final path = '$basePath/$key';
    final value = structure[key];

    if (value is Map<String, dynamic>) {
      await createFoldersIfNotExist([path]);
      await _createStructureRecursive(path, value);
    } else if (value is List<String>) {
      await createFoldersIfNotExist([path]);
      for (var fileName in value) {
        await createEmptyFile('$path/$fileName');
      }
    } else if (key == 'main.dart' && value == null) {
      // สร้างไฟล์ main.dart สำหรับเซอร์วิส
      await createEmptyFile('$basePath/main.dart');
    }
  }
}
