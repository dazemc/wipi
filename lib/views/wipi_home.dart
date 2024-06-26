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
        margin: const EdgeInsets.all(20),
        padding: const EdgeInsets.all(20),
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
                        style: TextStyle(
                          color: Colors.white,
                        ),
                        'Cannot find device',
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
                            onTap: () =>
                                wipiController.fetchCredentials(selectedType));
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
            const SizedBox(
              height: 80,
            ),
            Obx(
              () => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  children: [
                    Card(
                      color: Colors.black,
                      child: Container(
                        margin: const EdgeInsets.all(0),
                        child: ListTile(
                          tileColor: Colors.grey[800],
                          title: Text(
                              style: const TextStyle(color: Colors.white),
                              wipiController.displaySsid.value),
                          leading: const Text(
                              style: TextStyle(color: Colors.white), "ssid: "),
                        ),
                      ),
                    ),
                    Card(
                      color: Colors.black,
                      child: Container(
                        margin: const EdgeInsets.all(0),
                        child: ListTile(
                          shape: const RoundedRectangleBorder(),
                          tileColor: Colors.grey[800],
                          title: Text(
                              style: const TextStyle(color: Colors.white),
                              wipiController.displayPass.value),
                          leading: const Text(
                              style: TextStyle(color: Colors.white), "psk: "),
                        ),
                      ),
                    ),
                    Card(
                      color: Colors.black,
                      child: Container(
                        margin: const EdgeInsets.all(0),
                        child: ListTile(
                          shape: const RoundedRectangleBorder(),
                          tileColor: Colors.grey[800],
                          title: Text(
                              style: const TextStyle(color: Colors.white),
                              wipiController.displayKeymgmt.value),
                          leading: const Text(
                              style: TextStyle(color: Colors.white),
                              "key-mgmt: "),
                        ),
                      ),
                    ),
                    Card(
                      color: Colors.black,
                      child: Container(
                        margin: const EdgeInsets.all(0),
                        child: ListTile(
                          shape: const RoundedRectangleBorder(),
                          tileColor: Colors.grey[800],
                          title: Text(
                              style: const TextStyle(color: Colors.white),
                              wipiController.displayIpAddr.value),
                          leading: const Text(
                              style: TextStyle(color: Colors.white), "local_ip: "),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
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
                        contentPadding: const EdgeInsets.all(20),
                        backgroundColor: Colors.grey[900],
                        title: "",
                        content: Column(
                          children: [
                            TextField(
                              style: const TextStyle(color: Colors.white),
                              decoration: const InputDecoration(
                                hintText: 'SSID',
                                hintStyle: TextStyle(
                                  color: Colors.white,
                                  fontStyle: FontStyle.italic,
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
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                              controller: wipiController.passTextController,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blueGrey[700],
                              ),
                              onPressed: () {
                                wipiController.ssid =
                                    wipiController.ssidTextController.text;
                                wipiController.pass =
                                    wipiController.passTextController.text;
                                wipiController.postCredentials();
                                Get.back(closeOverlays: true);
                              },
                              child: const Text(
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                  "Send"),
                            ),
                          ],
                        ),
                      );
                    },
                    child: const Icon(
                      Icons.add,
                      color: Colors.white,
                      size: 26,
                    ),
                  ),
                  const SizedBox(
                    width: 100,
                    height: 160,
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
          ],
        ),
      ),
    );
  }
}
