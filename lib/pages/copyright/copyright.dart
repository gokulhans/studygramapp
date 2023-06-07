import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class Copyright extends StatelessWidget {
  const Copyright({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
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
          "Copyright",
          style: TextStyle(
              color: Colors.black, fontSize: 20, fontWeight: FontWeight.w800),
        ),
        iconTheme: const IconThemeData(color: Colors.green),
      ),
      body: Column(
        children: [
          Container(
            height: 250,
            color: Colors.white,
            padding: const EdgeInsets.only(
              left: 30,
              right: 10,
            ),
            child: const Center(
              child: Text(
                'All contents provided on this app is shared from internet sources. Not owned by us. Have any issue on any content contact us. Most of the files and videos taken from following websites.',
                style: TextStyle(
                  color: Colors.green,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  fontStyle: FontStyle.normal,
                ),
              ),
            ),
          ),
          SizedBox(
              height: 400,
              child: Container(
                color: Colors.white,
                child: ListView(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.copyright),
                      title: const Text('peekaycicscollege.in'),
                      onTap: () async {
                        var url = "https://peekaycicscollege.in/";
                        if (await canLaunchUrl(Uri.parse(url))) {
                          await launchUrl(Uri.parse(url),
                              mode: LaunchMode.externalNonBrowserApplication);
                        } else {
                          throw 'Could not launch $url';
                        }
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.copyright),
                      title: const Text('studynotes.in'),
                      onTap: () async {
                        var url = "https://studynotes.in/";
                        if (await canLaunchUrl(Uri.parse(url))) {
                          await launchUrl(Uri.parse(url),
                              mode: LaunchMode.externalNonBrowserApplication);
                        } else {
                          throw 'Could not launch $url';
                        }
                      },
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}
