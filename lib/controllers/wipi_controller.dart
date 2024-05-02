import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
// import 'package:wipi/models/saved_connections.dart';

const String baseUrl = 'http://192.168.0.174/';
const String showConnections = '${baseUrl}rec_creds?show_connections';
const String showCredentials = '${baseUrl}rec_creds?show_credentials=';
const String sendCredentials = '${baseUrl}send_creds';

class WiPiController extends GetxController {
  final ssidTextController = TextEditingController();
  final passTextController = TextEditingController();
  final getx = GetConnect();
  final savedConnections = <String>[''].obs;
  final creds = <String, dynamic>{"default": "value"}.obs;
  final wifiInfo = ''.obs;
  String ssid = "";
  String pass = "";
  bool connected = false;

  void fetchSavedConnections() async {
    final response = await getx.get(showConnections);
    if (kDebugMode) {
      savedConnections.value =
          response.body['saved_connections'].cast<String>();
      wifiInfo.value = savedConnections[0];
    }
  }

  void fetchCredentials(String connection) async {
    final response = await getx.get("$showCredentials$connection");
    if (kDebugMode) {
      creds.value = response.body;
      print(creds);
    }
  }

  void postCredentials() async {
    print('Sending Credentials');
    final response =
        await getx.post(sendCredentials, {"SSID": ssid, "PASS": pass});
    if (kDebugMode) {
      if (response.body == "Connected") {
        connected = true;
      }
    }
  }
}
