import 'package:flutter/material.dart';
import 'package:studygram/components/appbar/appbarwithback.dart';

class MyProfile extends StatelessWidget {
  const MyProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(55),
        child: AppBarWithBack(
          title: "MyProfile",
        ),
      ),
      body: const Center(child: Text(" MyProfile")),
    );
  }
}
