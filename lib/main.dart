import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studygram/components/appbar/appbarmain.dart';
import 'package:studygram/components/sidebar/sidebar.dart';
import 'package:studygram/pages/splashscreen/splashscreen.dart';
import 'package:studygram/screens/community/community.dart';
import 'package:studygram/screens/home/home.dart';
import 'package:studygram/screens/notification/notificationsold.dart';
import 'package:studygram/screens/profile/complete_profile.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Just Pass',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MainPage extends StatefulWidget {
  MainPage({Key? key}) : super(key: key);
  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int currentIndex = 0;
  final screens = [
    Home(),
    CheckAuthCommunity(),
    Notificationsold(
      title: 'notification',
    ),
    CompleteProfile()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: NavDrawer(),
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(55),
        child: AppBarMain(),
      ),
      body: screens[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.white,
          currentIndex: currentIndex,
          onTap: (index) => setState(() => currentIndex = index),
          unselectedLabelStyle: const TextStyle(
            color: Colors.grey,
          ),
          selectedIconTheme: const IconThemeData(
            color: Colors.green,
          ),
          selectedLabelStyle: const TextStyle(
            color: Colors.green,
          ),
          unselectedIconTheme: const IconThemeData(
            color: Colors.grey,
          ),
          showSelectedLabels: true,
          type: BottomNavigationBarType.fixed,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Community'),
            BottomNavigationBarItem(
                icon: Icon(Icons.notifications_active), label: 'Notifications'),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.person,
                // color: Colors.red,
              ),
              label: 'Profile',
            ),
          ]),
    );
  }
}
