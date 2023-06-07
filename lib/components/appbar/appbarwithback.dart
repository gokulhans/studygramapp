import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppBarWithBack extends StatelessWidget {
  var title;
  AppBarWithBack({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: Colors.green,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
  }
}
