import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wipi/controllers/wipi_controller.dart';

class WiPiHome extends StatelessWidget {
  const WiPiHome({super.key});
  @override
  Widget build(BuildContext context) {
    final wipiController = Get.put(WiPiController());
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ElevatedButton(
            onPressed: () => wipiController.fetchSavedConnections(),
            child: const Text('Get Saved Connections'),
          ),
          Obx(() => DropdownButton(
                hint: const Text(
                  'Choose SSID',
                ),
                onChanged: (newValue) {
                  wipiController.wifiInfo(newValue);
                },
                value: wipiController.wifiInfo.value,
                items: wipiController.savedConnections.map((selectedType) {
                  return DropdownMenuItem(
                    value: selectedType,
                    child: Text(
                      selectedType,
                    ),
                  );
                }).toList(),
              )),
          ElevatedButton(
            onPressed: () => wipiController
                .fetchCredentials(wipiController.wifiInfo.value),
            child: const Text('Creds'),
          ),
          Obx(() => Text(wipiController.creds.toString())),
          ElevatedButton(
            onPressed: () {
              Get.defaultDialog(
                title: "Enter SSID and password below",
                content: Column(
                  children: [
                    TextField(
                      decoration: const InputDecoration(hintText: 'SSID'),
                      controller: wipiController.ssidTextController,
                    ),
                    TextField(
                      decoration: const InputDecoration(hintText: 'password'),
                      controller: wipiController.passTextController,
                    ),
                    ElevatedButton(
                        onPressed: () {
                          wipiController.ssid =
                              wipiController.ssidTextController.text;
                          wipiController.pass =
                              wipiController.passTextController.text;
                          wipiController.postCredentials();
                          Get.back(closeOverlays: true);
                        },
                        child: const Text("Send"))
                  ],
                ),
              );
            },
            child: const Text("Send Wifi"),
          ),
        ],
      ),
    );
  }
}
