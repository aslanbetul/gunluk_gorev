import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  // Bağlantı durumu kontrolü
  Future<bool> isConnected() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }

  // Bağlantı durumu değiştiğinde dinleme
  Stream<List<ConnectivityResult>> get connectivityStream => Connectivity().onConnectivityChanged;
}
