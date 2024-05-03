import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wipi/controllers/wipi_controller.dart';

class WiPiHome extends StatelessWidget {
  const WiPiHome({super.key});
  @override
  Widget build(BuildContext context) {
    final wipiController = Get.put(WiPiController());
    return Center(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(10),
        ),
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.all(10),
        width: 333,
        height: 333,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Obx(
                  () => Theme(
                    data: Theme.of(context).copyWith(
                      canvasColor: Colors.grey[900],
                    ),
                    child: DropdownButton(
                      hint: const Text(
                        'Choose SSID',
                      ),
                      onChanged: (newValue) {
                        wipiController.wifiInfo(newValue);
                      },
                      value: wipiController.wifiInfo.value,
                      items:
                          wipiController.savedConnections.map((selectedType) {
                        return DropdownMenuItem(
                            value: selectedType,
                            child: Text(
                              style: const TextStyle(
                                color: Colors.white,
                              ),
                              selectedType,
                            ),
                            onTap: () => wipiController.fetchCredentials(
                                wipiController.wifiInfo.value));
                      }).toList(),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  width: 50,
                  height: 50,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.grey[900],
                    ),
                    onPressed: () => wipiController.fetchSavedConnections(),
                    child: const Icon(
                      Icons.refresh,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            Container(
              margin: const EdgeInsets.all(7),
              padding: const EdgeInsets.all(5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueGrey[700],
                    ),
                    onPressed: () {
                      Get.defaultDialog(
                        titlePadding: const EdgeInsets.all(33),
                        backgroundColor: Colors.grey[900],
                        titleStyle: const TextStyle(
                          color: Colors.white,
                        ),
                        title: "Enter SSID and password",
                        content: Column(
                          children: [
                            TextField(
                              style: const TextStyle(color: Colors.white),
                              decoration: const InputDecoration(
                                hintText: 'SSID',
                                hintStyle: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              controller: wipiController.ssidTextController,
                            ),
                            TextField(
                              style: const TextStyle(color: Colors.white),
                              decoration: const InputDecoration(
                                hintText: 'password',
                                hintStyle: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
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
                    child: const Row(
                      children: [
                        Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 17,
                        ),
                      ],
                    ),
                  ),
                  Obx(
                    () => ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: wipiController.deleteColor.value,
                      ),
                      onPressed: () => wipiController
                          .removeCredentials(wipiController.wifiInfo.value),
                      child: const Icon(Icons.delete, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            Obx(
              () => Text(
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                  wipiController.creds.toString()),
            ),
          ],
        ),
      ),
    );
  }
}
