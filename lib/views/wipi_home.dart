import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wipi/controllers/wipi_controller.dart';

class WiPiHome extends StatelessWidget {
  const WiPiHome({super.key});
  @override
  Widget build(BuildContext context) {
    final wipiController = Get.put(WiPiController());
    return const Placeholder();
  }
}
