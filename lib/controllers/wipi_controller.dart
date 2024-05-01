import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
// import 'package:wipi/models/saved_connections.dart';

const String showConnections = 'http://192.168.0.174/api?show_connections';
const String showCredentials = 'http://192.168.0.174/api?show_credentials=';

class WiPiController extends GetxController {
  final getx = GetConnect();
  final savedConnections = <dynamic>[''].obs;
  final creds = <String, dynamic>{"": ""}.obs;
  void fetchSavedConnections() async {
    final response = await getx.get(showConnections);
    if (kDebugMode) {
      savedConnections.value = response.body['saved_connections'];
    }
  }

  void fetchCredentials() async {
    String connection = savedConnections[0];
    final response = await getx.get("$showCredentials$connection");
    if (kDebugMode) {
      creds.value = response.body;
      print(creds);
    }
  }
}
