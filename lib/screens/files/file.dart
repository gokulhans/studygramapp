import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:studygram/screens/category/category.dart';
import 'package:http/http.dart' as http;
import 'package:studygram/screens/files/webview.dart';
import 'package:studygram/utils/constants.dart';
import 'package:url_launcher/url_launcher.dart';

class File extends StatelessWidget {
  const File({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Document'),
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.green,
          statusBarIconBrightness: Brightness.dark,
        ),
      ),
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
  var argumentData = Get.arguments;
  Future<List<Map<String, dynamic>>> fetchCourses() async {
    final response = await http.get(Uri.parse(
        '${apidomain}doc/${argumentData['university']}/${argumentData['course']}/${argumentData['semester']}/${argumentData['subject']}/all-module/${argumentData['category']}'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      List<Map<String, dynamic>> docs = data
          .map((item) => {
                '_id': item['_id'],
                'docname': item['docname'],
                'fdocname': item['fdocname'],
                'doclink': item['doclink']
              })
          .toList();
      return docs;
    } else {
      throw Exception('Failed to fetch docs');
    }
  }

  // var endpoint = widget.title;
  // var endpoint = 'Bca/Semester-1';
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
              List<Map<String, dynamic>> docs = snapshot.data!;
              if (docs.isEmpty) {
                return Center(child: const Text('No Docs available.'));
              }
              return Container(
                padding: const EdgeInsets.only(
                  left: 12,
                  right: 12,
                  top: 12,
                ),
                child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: docs.length,
                    itemBuilder: (context, i) {
                      return TextButton(
                        onPressed: () async {
                          var url = docs[i]['doclink'];
                          if (await canLaunchUrl(Uri.parse(url))) {
                            await launchUrl(Uri.parse(url),
                                mode: LaunchMode.externalApplication);
                            print("launched");
                            //  await launch(url,
                            //   forceWebView: false, enableJavaScript: true);
                          } else {
                            throw 'Could not launch $url';
                          }
                          // Get.to(() => const WebViewApp());
                        },
                        child: Container(
                          height: 60,
                          margin: const EdgeInsets.only(
                            left: 12,
                            right: 12,
                          ),
                          decoration: BoxDecoration(
                              color: Colors.white30,
                              borderRadius: BorderRadius.circular(50),
                              boxShadow: const [
                                // Shadow for top-left corner
                                BoxShadow(
                                  color: Colors.grey,
                                  offset: Offset(1, 1),
                                  blurRadius: 2,
                                  spreadRadius: 0.3,
                                ),
                                // Shadow for bottom-right corner
                                BoxShadow(
                                  color: Colors.white,
                                  offset: Offset(-1, -1),
                                  blurRadius: 1,
                                  spreadRadius: 3,
                                ),
                              ]),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  // snapshot.data[i].name,
                                  docs[i]['docname'],
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w800,
                                      fontSize: 14),
                                ),
                                IconButton(
                                  onPressed: () {},
                                  icon: const Icon(
                                    Icons.download,
                                    size: 18,
                                  ),
                                ),
                              ],
                            ),
                          ),
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
