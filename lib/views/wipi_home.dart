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
        children: [
          ElevatedButton(
            onPressed: () => wipiController.fetchSavedConnections(),
            child: const Text('Call'),
          ),
          Obx(() => Text(wipiController.savedConnections[0])),
          ElevatedButton(
            onPressed: () => wipiController.fetchCredentials(wipiController.savedConnections[0]),
            child: const Text('Creds'),
          ),
          Obx(() => Text(wipiController.creds.toString()))
        ],
      ),
    );
  }
}
