import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
// import 'package:wipi/models/saved_connections.dart';

const String baseUrl = 'http://192.168.0.174/';
const String showConnections = '${baseUrl}rec_creds?show_connections';
const String showCredentials = '${baseUrl}rec_creds?show_credentials=';
const String sendCredentials = '${baseUrl}send_creds';

class WiPiController extends GetxController {
  final getx = GetConnect();
  final savedConnections = <dynamic>[''].obs;
  final creds = <String, dynamic>{"default": "value"}.obs;
  void fetchSavedConnections() async {
    final response = await getx.get(showConnections);
    if (kDebugMode) {
      savedConnections.value = response.body['saved_connections'];
    }
  }

  void fetchCredentials(String connection) async {
    final response = await getx.get("$showCredentials$connection");
    if (kDebugMode) {
      creds.value = response.body;
      print(creds);
    }
  }

  void postCredentials(data) async {
    final response = await getx.post(sendCredentials, data);
    if (kDebugMode) {
      print(response.body);
    }
  }
}
