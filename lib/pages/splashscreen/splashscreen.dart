import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:studygram/pages/update/updatehome.dart';
import 'package:studygram/utils/color_constants.dart';
import 'package:studygram/utils/widget_functions.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3)).then((value) async {
      Get.off(() => const UpdateHome());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(0),
        child: AppBar(
          elevation: 0,
          systemOverlayStyle: const SystemUiOverlayStyle(
            systemNavigationBarColor: Colors.black, // navigation bar color
            systemNavigationBarIconBrightness: Brightness.dark,
            statusBarColor: Colors.white,
            statusBarIconBrightness: Brightness.dark,
            // statusBarBrightness: Brightness.light
          ),
        ),
      ),
      body: Container(
        // decoration: BoxDecoration(
        // gradient: LinearGradient(
        //   begin: Alignment.bottomCenter,
        //   end: Alignment.topCenter,
        //   colors: [hexToColor("#2B65EC"), hexToColor("#00BFFF")],
        //   transform: const GradientRotation(9 * pi / 135),
        // ),
        // ),
        color: Colors.white,
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            addVerticalSpace(30),
            Column(
              children: [
                const Center(
                    child: Image(
                  image: AssetImage("assets/icon/logo.png"),
                  width: 100,
                )),
                addVerticalSpace(10),
                const Text(
                  "STUDYGRAM",
                  style: TextStyle(
                      fontWeight: FontWeight.w900,
                      color: Colors.black87,
                      fontSize: 18),
                )
              ],
            ),
            // addVerticalSpace(50),
            const Text(
              "Dream Of A World Without Supply",
              style:
                  TextStyle(fontWeight: FontWeight.w500, color: Colors.black),
            )
          ],
        )),
      ),
    );
  }
}

// class AppHome extends StatefulWidget {
//   const AppHome({super.key, required this.ownerid, required this.userid});

//   final String? ownerid;
//   final String? userid;

//   @override
//   State<AppHome> createState() => _AppHomeState();
// }

// class _AppHomeState extends State<AppHome> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: (widget.ownerid != null)
//           ? OwnerHomePage(currentIndex: 0)
//           : (widget.userid != null)
//               ? const UserHomePage()
//               : const ExitHome(),
//     );
//   }
// }
