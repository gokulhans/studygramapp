import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:studygram/utils/constants.dart';
import 'package:url_launcher/url_launcher.dart';

class Notificationsold extends StatelessWidget {
  const Notificationsold({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Sublist(title: title),
    );
  }
}

class Sublist extends StatefulWidget {
  const Sublist({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _SublistState createState() => _SublistState();
}

class _SublistState extends State<Sublist> {
  Future<List<Map<String, dynamic>>> fetchCourses() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String useruniversity = prefs.getString('universityname')!;
    final response = await http.get(Uri.parse('${apidomain}noti/${useruniversity}'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      List<Map<String, dynamic>> notificationsold = data
          .map((item) => {
                '_id': item['_id'],
                'title': item['title'],
                'desc': item['desc'],
                'university': item['university'],
                'link': item['link'],
              })
          .toList();
      return notificationsold;
    } else {
      throw Exception('Failed to fetch notificationsold');
    }
  }

  // var endpoint = widget.title;
  // var endpoint = 'Bca/Notificationsold-1';
  @override
  Widget build(BuildContext context) {
    var argumentData = Get.arguments;
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: fetchCourses(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: SpinKitCircle(
                  size: 80,
                  color: Colors.green,
                ),
              );
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (snapshot.hasData) {
              List<Map<String, dynamic>> notificationsold = snapshot.data!;
              if (notificationsold.isEmpty) {
                return Center(child: const Text('No Notificationsold available.'));
              }
              return Container(
                padding: const EdgeInsets.only(
                  left: 12,
                  right: 12,
                  top: 12,
                ),
                child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: notificationsold.length,
                    itemBuilder: (context, i) {
                      return Card(
                        elevation: 2,
                        child: ListTile(
                          leading: Container(
                            alignment: Alignment.center,
                            width: 48,
                            child: Icon(
                              Icons.notifications_active,
                              color: Colors.green,
                            ),
                          ),
                          title: Text(
                            notificationsold[i]['title'],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            notificationsold[i]['desc'],
                          ),
                          trailing: Icon(Icons.arrow_forward),
                          onTap: () async {
                            var url = notificationsold[i]['link'];
                            if (await canLaunchUrl(Uri.parse(url))) {
                              await launchUrl(Uri.parse(url),
                                  mode: LaunchMode.externalApplication);
                              print("launched");
                              //  await launch(url,
                              //   forceWebView: false, enableJavaScript: true);
                            } else {
                              throw 'Could not launch $url';
                            }
                            // Get.to(() => WebViewApp(link: 'null',));
                          },
                        ),
                      );
                    }),
              );
            } else {
              return const Center(
                  child: Text(
                'No Content is available right now',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                ),
              ));
            }
          },
        ),
      ),
    );
  }
}

// class NotificationCard extends StatelessWidget {
//   final IconData icon;
//   final String title;
//   final String description;

//   NotificationCard(
//       {required this.icon, required this.title, required this.description});

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       elevation: 2,
//       child: ListTile(
//         leading: Container(
//           alignment: Alignment.center,
//           width: 48,
//           child: Icon(
//             icon,
//             color: Colors.green,
//           ),
//         ),
//         title: Text(
//           title,
//           style: TextStyle(
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         subtitle: Text(description),
//         trailing: Icon(Icons.arrow_forward),
//         onTap: () {
//           // Handle notification card tap here
//         },
//       ),
//     );
//   }
// }
