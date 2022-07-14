import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  final StreamController<ConnectivityResult> _connectionStatusController =
      StreamController<ConnectivityResult>.broadcast();

  StreamSink<ConnectivityResult> get connectivityResultSink =>
      _connectionStatusController.sink;
  Stream<ConnectivityResult> get connectivityResultStream =>
      _connectionStatusController.stream;

  ConnectivityService() {
    checkConnection();
    Connectivity().onConnectivityChanged.listen((event) {
      _connectionStatusController.add(event);
    });
  }

  void checkConnection() async {
    ConnectivityResult connectivityResult =
        await Connectivity().checkConnectivity();
    _connectionStatusController.add(connectivityResult);
  }

  dispose() {
    _connectionStatusController.close();
  }
}
