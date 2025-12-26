import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  final _connectivity = Connectivity();
  Stream<ConnectivityResult> watch() => _connectivity.onConnectivityChanged.map((list) => list.first);
  Future<ConnectivityResult> current() async {
    final list = await _connectivity.checkConnectivity();
    return list.first;
  }
}
