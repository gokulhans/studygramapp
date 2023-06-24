import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:studygram/components/appbar/appbarmain.dart';
import 'package:studygram/pages/splashscreen/splashscreen.dart';
import 'package:studygram/pages/update/updatehome.dart';
import 'package:studygram/utils/widget_functions.dart';

class InternetHome extends StatefulWidget {
  const InternetHome({Key? key}) : super(key: key);

  @override
  State<InternetHome> createState() => _InternetHomeState();
}

class _InternetHomeState extends State<InternetHome> {
  bool ActiveConnection = false;
  String T = "";
  Future CheckUserConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          ActiveConnection = true;
          T = "Turn on the data and Continue";
        });
      }
    } on SocketException catch (_) {
      setState(() {
        ActiveConnection = false;
        T = "Turn on the data and Continue";
      });
    }
  }

  @override
  void initState() {
    CheckUserConnection();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (ActiveConnection) {
      return UpdateHome();
    } else if (!ActiveConnection) {
      return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(55),
          child: AppBar(
            systemOverlayStyle: const SystemUiOverlayStyle(
              // Status bar color
              statusBarColor: Colors.white,
              // Status bar brightness (optional)
              statusBarIconBrightness:
                  Brightness.dark, // For Android (dark icons)
            ),
            backgroundColor: Colors.white,
            bottomOpacity: 0.0,
            elevation: 0.0,
            centerTitle: true,
            title: const Text(
              "Studygram",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w800),
            ),
          ),
        ),
        body: Container(
          color: Colors.white,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("No Active Internet Connection"),
                addVerticalSpace(10),
                Text("Turn on the data and Continue"),
                addVerticalSpace(10),
                OutlinedButton(
                    onPressed: () {
                      Get.off(() => const SplashScreen());
                    },
                    child: const Text("Continue"))
              ],
            ),
          ),
        ),
      );
    } else {
      return Container(color: Colors.white);
    }
  }
}
