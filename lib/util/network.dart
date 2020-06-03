import 'package:connectivity/connectivity.dart';

final Connectivity _connectivity = Connectivity();

Future<bool> isConnected() async {
  final result = await _connectivity.checkConnectivity();
  return result != ConnectivityResult.none;
}
