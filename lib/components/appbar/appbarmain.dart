import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:studygram/screens/profile/complete_profile.dart';
import 'package:studygram/screens/profile/profile.dart';

class AppBarMain extends StatelessWidget {
  const AppBarMain({super.key});

  @override 
  Widget build(BuildContext context) {
    return AppBar(
      systemOverlayStyle: const SystemUiOverlayStyle(
        // Status bar color
        statusBarColor: Colors.white,
        // Status bar brightness (optional)
        statusBarIconBrightness: Brightness.dark, // For Android (dark icons)
      ),
      backgroundColor: Colors.white,
      bottomOpacity: 0.0,
      elevation: 0.0,
      centerTitle: true,
      title: const Text(
        "Studygram",
        style: TextStyle(
            color: Colors.black, fontSize: 20, fontWeight: FontWeight.w800),
      ),
      actions: [
        IconButton(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          icon: const Icon(
            Icons.person,
            color: Colors.green,
          ),
          onPressed: () async {
            Get.to(const CompleteProfile());
          },
        ),
      ],
      iconTheme: const IconThemeData(color: Colors.green),
    );
  }
}
