import "dart:io";

import "package:cherry_peaked_docs/cherry_peaked_docs.dart";
import "package:flutter/material.dart";
import "package:permission_handler/permission_handler.dart";

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<File> files = [];

  Future<void> _onButtonPressed() async {
    final cameraPermission = await Permission.camera.request();

    if (!cameraPermission.isGranted) {
      await openAppSettings();
      return;
    }

    final result = await CherryPeakedDocs.startScanning();

    setState(() {
      files = result.files;
    });
  }

  @override
  Widget build(final BuildContext context) {
    final colorScheme = ColorScheme.fromSeed(seedColor: const Color(0xFFF93161));

    final scanButton = TextButton(onPressed: _onButtonPressed, child: const Text("Scan"));

    final appBar = AppBar(title: const Text("CherryPeakedDocs"), centerTitle: false, actions: [scanButton]);

    final scrollView = Scrollbar(
      child: ListView.separated(
        itemCount: files.length,
        itemBuilder: (final context, final index) => Image.file(files[index], height: 300),
        separatorBuilder: (final context, final index) => const SizedBox.square(dimension: 20),
      ),
    );

    return MaterialApp(
      theme: ThemeData.from(colorScheme: colorScheme),
      home: Scaffold(appBar: appBar, body: scrollView),
    );
  }
}
