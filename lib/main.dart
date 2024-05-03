import 'package:flutter/material.dart';
import 'package:wipi/views/wipi_home.dart';
import 'package:get/get.dart';

void main() => runApp(const GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.black,
        // appBar: AppBar(
        //   title: const Placeholder(),
        // ),
        body: SafeArea(child: WiPiHome()),
      ),
    ));
