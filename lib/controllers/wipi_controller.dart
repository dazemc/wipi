import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:wipi/models/saved_connections.dart';

const String baseUrl = 'http://192.168.6.9/';
const String showConnections = '${baseUrl}rec_creds?show_connections';
const String showCredentials = '${baseUrl}rec_creds?show_credentials=';
const String deleteCredentials = '${baseUrl}rec_creds?delete_credentials=';
const String sendCredentials = '${baseUrl}send_creds';

class WiPiController extends GetxController {
  final ssidTextController = TextEditingController();
  final passTextController = TextEditingController();
  final getx = GetConnect();
  final savedConnections = <String>[''].obs;
  Map<String, Connection> displayConnections = <String, Connection>{};
  Map creds = <String, dynamic>{"": ""};
  final wifiInfo = ''.obs;
  final deleteColor = Colors.red[400].obs;
  String ssid = "";
  String pass = "";
  final displaySsid = "".obs;
  final displayPass = "".obs;
  final displayKeymgmt = "".obs;
  final displayIpAddr = "".obs;
  bool connected = false;

  void fetchSavedConnections() async {
    clearConnectionList();
    final response = await getx.get(showConnections);
    savedConnections.value = response.body['saved_connections'].cast<String>();
    wifiInfo.value = savedConnections[0];
    fetchCredentials(wifiInfo.value);
    getDeleteColor();
  }

  void fetchCredentials(connection) async {
    wifiInfo.value = connection;
    getDeleteColor();
    final response = await getx.get("$showCredentials${wifiInfo.value}");
    creds = response.body;
    if (kDebugMode) {
      print(creds);
    }
    for (String key in creds.keys) {
      displayConnections = {
        key: Connection(
          ssid: creds[key]["ssid"],
          keymgmt: creds[key]["key-mgmt"],
          psk: creds[key]["psk"],
          localip: creds[key]["local-ip"],
        ),
      };
    }
    displayCredentials();
  }

  void postCredentials() async {
    // print('Sending Credentials');
    await Future.delayed(const Duration(seconds: 10));
    final response =
        await getx.post(sendCredentials, {"SSID": ssid, "PASS": pass});
    if (kDebugMode) {
      print(response.body);
    }
    fetchSavedConnections();
  }

  void displayCredentials() {
    displaySsid.value = displayConnections[wifiInfo.value]!.ssid;
    displayKeymgmt.value = displayConnections[wifiInfo.value]!.keymgmt;
    displayPass.value = displayConnections[wifiInfo.value]!.psk;
    displayIpAddr.value = displayConnections[wifiInfo.value]!.localip;
  }

  void removeCredentials(connection) async {
    if (connection == "Hotspot") {
      return;
    }
    final response = await getx.get("$deleteCredentials$connection");
    clearConnectionList();
    fetchSavedConnections();
    if (response.body == "Deleted: $connection") {
      // print("Successfully deleted");
    }
  }

  void clearConnectionList() {
    wifiInfo.value = "";
    wifiInfo.refresh();
    savedConnections.value = [];
    savedConnections.refresh();
  }

  void getDeleteColor() {
    if (wifiInfo.value == "Hotspot") {
      deleteColor.value = Colors.grey[900];
    } else {
      deleteColor.value = Colors.red[400];
    }
  }
}
