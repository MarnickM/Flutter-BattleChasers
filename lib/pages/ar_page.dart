import 'dart:convert';
import 'package:battle_chasers/pages/achievements_page.dart';
import 'package:battle_chasers/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_unity_widget/flutter_unity_widget.dart';
import 'package:permission_handler/permission_handler.dart';
import '../database_helper.dart';

class ArPage extends StatefulWidget {
  const ArPage({super.key});

  @override
  State<ArPage> createState() => _ArPageState();
}

class _ArPageState extends State<ArPage> {
  UnityWidgetController? _unityWidgetController;
  bool _isCameraPermissionGranted = false;

  @override
  void initState() {
    super.initState();
    _checkCameraPermission();
  }

  Future<void> _checkCameraPermission() async {
    PermissionStatus status = await Permission.camera.status;
    if (!status.isGranted) {
      status = await Permission.camera.request();
    }

    if (status.isGranted) {
      setState(() {
        _isCameraPermissionGranted = true;
      });
    }
  }

  @override
  void dispose() {
    _unityWidgetController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isCameraPermissionGranted) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Enable camera'),
        ),
        body: const Center(
          child: Text('Camera permission is required to proceed.'),
        ),
      );
    }

    return Scaffold(
      body: UnityWidget(
        onUnityCreated: _onUnityCreated,
        onUnityMessage: onUnityMessage,
        useAndroidViewSurface: true,
      ),
    );
  }

  void _onUnityCreated(UnityWidgetController controller) {
    _unityWidgetController = controller;
    print('Unity widget initialized.');
  }

  void onUnityMessage(message) {
    try {
      Map<String, dynamic> decodedMessage = json.decode(message);

      if (decodedMessage.containsKey('score') &&
          decodedMessage.containsKey('killedDragons') &&
          decodedMessage.containsKey('count')) {
        int score = decodedMessage['score'];
        List<String> killedDragons =
            List<String>.from(decodedMessage['killedDragons']);
        int killCount = int.parse(decodedMessage['count']);

        _promptForName(score, killedDragons, killCount);
      }
    } catch (e) {
      print('Error parsing message from Unity: $e');
    }
  }

  void _promptForName(int score, List<String> killedDragons, int killCount) {
    TextEditingController nameController = TextEditingController();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Game Over!"),
          content: TextField(
            controller: nameController,
            decoration: const InputDecoration(labelText: "Enter your name"),
          ),
          actions: [
            // Submit Button
            TextButton(
              onPressed: () {
                String name = nameController.text.trim();
                if (name.isNotEmpty) {
                  _saveGameResult(name, score, killCount, killedDragons);
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Name cannot be empty!")),
                  );
                }
              },
              child: const Text("Submit"),
            ),
            // Navigate to HomePage Button
            TextButton(
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const HomePage()),
                  (Route<dynamic> route) => false,
                );
              },
              child: const Text("Go to Home"),
            ),
            // Navigate to AchievementsPage Button
            TextButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) => const AchievementsPage()),
                );
              },
              child: const Text("Achievements"),
            ),
          ],
        );
      },
    );
  }

  Future<void> _saveGameResult(
      String name, int score, int killCount, List<String> killedDragons) async {
    await DatabaseHelper.insertUser(name, score, killCount, killedDragons);
    print('Game result saved: $name, Score: $score, Kill Count: $killCount');
  }
}
