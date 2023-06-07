import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListViewBuilder(),
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
          "Studygram",
          style: TextStyle(
              color: Colors.black, fontSize: 20, fontWeight: FontWeight.w800),
        ),
        iconTheme: IconThemeData(color: Colors.green),
      ),
    );
  }
}

class ListViewBuilder extends StatelessWidget {
  const ListViewBuilder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<String> appdata = [
      'App Name',
      'App Version',
      'Developed by',
      'Spacial Thanks'
    ];
    List<String> devdata = ['Studygram', 'V 1.0.0', 'gbroz', 'Fayiz'];
    List<String> linkdata = [
      'https://play.google.com/store/apps/details?id=com.gbroz.studygram',
      '',
      'https://www.instagram.com/gbrozdev/',
      'https://www.instagram.com/fe_y_z_/'
    ];

    return Column(
      children: [
        Container(
          height: 300,
          color: Colors.white,
          padding: const EdgeInsets.only(top: 10),
          child: FutureBuilder(
              // future: getAboutus(),
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.data == null) {
                  return const Center(
                    child: SpinKitCircle(
                      size: 80,
                      color: Colors.green,
                    ),
                  );
                } else {
                  return Container(
                      padding: const EdgeInsets.only(
                        left: 12,
                        right: 12,
                        top: 16,
                      ),
                      child: ListView.builder(
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, i) {
                            return ListTile(
                                contentPadding:
                                    const EdgeInsets.only(left: 50, right: 50),
                                trailing: TextButton(
                                  onPressed: () async {
                                    var url = snapshot.data[i].link;
                                    if (await canLaunchUrl(Uri.parse(url))) {
                                      await launchUrl(Uri.parse(url),
                                          mode: LaunchMode
                                              .externalNonBrowserApplication);
                                    } else {
                                      throw 'Could not launch $url';
                                    }
                                  },
                                  child: Text(
                                    snapshot.data[i].value,
                                    style: const TextStyle(
                                        color: Colors.green,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w800),
                                  ),
                                ),
                                title: Text(snapshot.data[i].key,
                                    style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w800)));
                          }));
                }
              }),
        ),
        Expanded(
          child: Center(
            child: Container(
              // height: 300,
              color: Colors.white,
              padding: const EdgeInsets.only(
                left: 30,
                right: 0,
              ),
              child: const Center(
                child: SingleChildScrollView(
                  child: Text(
                    'We offers study material for university studies. \n\nWhat You can find here ? \nPrevious question papers \nVideo Classes \nSyllabus \nPDF books \nTime tables \nProject \nResults \n\nHave any doubts, message us..',
                    style: TextStyle(
                      color: Colors.green,
                      // textStyle: Theme.of(context).textTheme.headline4,
                      fontSize: 16,
                      // fontWeight: FontWeight.w600,
                      fontStyle: FontStyle.normal,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
