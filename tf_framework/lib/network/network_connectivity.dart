
import 'package:connectivity_plus/connectivity_plus.dart';

class NetworkConnectivity {
  static Future<bool> getConnectivityStatus() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      return false;
    } else {
      return true;
    }
  }
}
