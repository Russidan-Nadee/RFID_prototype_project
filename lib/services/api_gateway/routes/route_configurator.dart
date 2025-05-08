import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

class RouteConfigurator {
  final Router _router;

  RouteConfigurator(this._router);

  // แก้ไขให้รองรับ Future<Response> Function(Request) สำหรับทุกเมธอด
  void get(String path, Future<Response> Function(Request) handler) {
    _router.get(path, handler);
  }

  void post(String path, Future<Response> Function(Request) handler) {
    _router.post(path, handler);
  }

  void put(String path, Future<Response> Function(Request) handler) {
    _router.put(path, handler);
  }

  void delete(String path, Future<Response> Function(Request) handler) {
    _router.delete(path, handler);
  }
}
