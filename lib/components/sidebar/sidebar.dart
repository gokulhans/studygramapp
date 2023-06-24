import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:studygram/main.dart';
import 'package:studygram/pages/about/aboutus.dart';
import 'package:studygram/pages/copyright/copyright.dart';
import 'package:studygram/screens/auth/login/login.dart';
import 'package:studygram/utils/constants.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart' as launchtab;

class NavDrawer extends StatefulWidget {
  @override
  State<NavDrawer> createState() => _NavDrawerState();
}

class _NavDrawerState extends State<NavDrawer> {
  @override
  void initState() {
    onload();
  }

  bool isUser = false;
  void onload() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var user = await pref.getBool('user');
    if (user!) {
      setState(() {
        isUser = true;
      });
    } else {
      setState(() {
        isUser = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Center(
              child: Container(
                height: 100,
                width: 100,
                decoration: const BoxDecoration(
                    image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage('assets/logo.png'),
                )),
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.input),
            title: const Text('Welcome'),
            onTap: () {
              Navigator.of(context).pop();
            },
          ),
          ListTile(
            leading: const Icon(Icons.telegram),
            title: const Text('Telegram'),
            onTap: () async {
              var url = "https://t.me/studygramcu";
              if (await canLaunchUrl(Uri.parse(url))) {
                await launchUrl(Uri.parse(url),
                    mode: LaunchMode.externalNonBrowserApplication);
              } else {
                throw 'Could not launch $url';
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.whatsapp),
            title: const Text('Whatsapp'),
            onTap: () async {
              var url = "https://wa.me/message/5XWWJKY6UH5EG1";
              if (await canLaunchUrl(Uri.parse(url))) {
                await launchUrl(Uri.parse(url),
                    mode: LaunchMode.externalNonBrowserApplication);
              } else {
                throw 'Could not launch $url';
              }
            },
          ),
          ListTile(
            leading: const Icon(FontAwesomeIcons.instagram),
            title: const Text('Instagram'),
            onTap: () async {
              var url = "https://instagram.com/studygramcu?igshid=YmMyMTA2M2Y=";
              if (await canLaunchUrl(Uri.parse(url))) {
                await launchUrl(Uri.parse(url),
                    mode: LaunchMode.externalNonBrowserApplication);
              } else {
                throw 'Could not launch $url';
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.picture_as_pdf),
            title: const Text('Submit PDF'),
            onTap: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              var userid = prefs.getString('userid')!;
              var url = "${apidomain2}contribute/${userid}";
              await launchtab.launch(
                url,
                customTabsOption: launchtab.CustomTabsOption(
                  toolbarColor: Colors.green.shade300,
                  enableDefaultShare: true,
                  enableUrlBarHiding: true,
                  showPageTitle: true,
                  animation: launchtab.CustomTabsSystemAnimation.slideIn(),
                  extraCustomTabs: const <String>[
                    // ref. https://play.google.com/store/apps/details?id=org.mozilla.firefox
                    'org.mozilla.firefox',
                    // ref. https://play.google.com/store/apps/details?id=com.microsoft.emmx
                    'com.microsoft.emmx',
                    'com.android.chrome',
                  ],
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.video_camera_back),
            title: const Text('Submit Video'),
            onTap: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              var userid = prefs.getString('userid')!;
              var url = "${apidomain2}submitvideo/${userid}";
              await launchtab.launch(
                url,
                customTabsOption: launchtab.CustomTabsOption(
                  toolbarColor: Colors.green.shade300,
                  enableDefaultShare: true,
                  enableUrlBarHiding: true,
                  showPageTitle: true,
                  animation: launchtab.CustomTabsSystemAnimation.slideIn(),
                  extraCustomTabs: const <String>[
                    // ref. https://play.google.com/store/apps/details?id=org.mozilla.firefox
                    'org.mozilla.firefox',
                    // ref. https://play.google.com/store/apps/details?id=com.microsoft.emmx
                    'com.microsoft.emmx',
                    'com.android.chrome',
                  ],
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.copyright_sharp),
            title: const Text('Copyright'),
            onTap: () => {Get.to(const Copyright())},
          ),
          // ListTile(
          //   leading: Icon(Icons.favorite,color: Colors.red,),
          //   title: Text('Support Us',style: TextStyle(color: Colors.red,fontWeight: FontWeight.w900),),
          //   onTap: () => {Navigator.of(context).pushNamed('support')},
          // ),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('About Us'),
            onTap: () => {Get.to(const AboutPage())},
          ),
          ListTile(
            leading: const Icon(Icons.share),
            title: const Text('Share App'),
            onTap: () async {
              const message =
                  "Studygram is a place for calicut university students. Previous Year Question Papers ,Studymaterials,Video Classes are Available";
              const appurl =
                  "https://play.google.com/store/apps/details?id=com.outq.studygram";
              await Share.share("$message \n $appurl");
            },
          ),
          isUser
              ? ListTile(
                  leading: const Icon(Icons.output),
                  title: const Text('Logout'),
                  onTap: () async {
                    SharedPreferences pref =
                        await SharedPreferences.getInstance();
                    await pref.remove('user');
                    await pref.remove('username');
                    await pref.remove('userid');
                    Get.offAll(MainPage());
                  },
                )
              : ListTile(
                  leading: const Icon(FontAwesomeIcons.lock),
                  title: const Text('Login'),
                  onTap: () async {
                    Get.to(UserLoginPage());
                  },
                ),
        ],
      ),
    );
  }
}
