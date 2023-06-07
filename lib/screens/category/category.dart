import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:studygram/screens/files/file.dart';
import 'package:studygram/screens/video/videolist.dart';
import 'package:studygram/utils/constants.dart';

class Category extends StatelessWidget {
  const Category({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Category'),
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
    final response = await http.get(Uri.parse('${apidomain}category'));
    // print({
    //   "${apidomain}category/${argumentData['university']}/${argumentData['course']}/${argumentData['semester']}"
    // });
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      List<Map<String, dynamic>> categorys = data
          .map((item) => {
                '_id': item['_id'],
                'categoryname': item['categoryname'],
                'fcategoryname': item['fcategoryname'],
              })
          .toList();
      return categorys;
    } else {
      throw Exception('Failed to fetch categorys');
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
              List<Map<String, dynamic>> categorys = snapshot.data!;
              if (categorys.isEmpty) {
                return Center(child: const Text('No Category available.'));
              }
              return Container(
                padding: const EdgeInsets.only(
                  left: 12,
                  right: 12,
                  top: 12,
                ),
                child: Column(
                  children: [
                    Container(
                      height: 60,
                      margin: const EdgeInsets.only(
                        left: 12,
                        right: 12,
                        top: 6,
                        bottom: 6,
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
                        child: TextButton(
                            child: const Text(
                              "Videos",
                              // "English",
                              style: TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16),
                            ),
                            onPressed: () {
                              Get.to(
                                  () => const Videolist(
                                        title: "",
                                      ),
                                  arguments: {
                                    'university': argumentData['university'],
                                    'course': argumentData['course'],
                                    'semester': argumentData['semester'],
                                    'subject': argumentData['subject'],
                                    'module': argumentData['module'],
                                  });
                            }),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          itemCount: categorys.length,
                          itemBuilder: (context, i) {
                            return Container(
                              height: 60,
                              margin: const EdgeInsets.only(
                                left: 12,
                                right: 12,
                                top: 6,
                                bottom: 6,
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
                                child: TextButton(
                                    child: Text(
                                      categorys[i]['categoryname'],
                                      // "English",
                                      style: const TextStyle(
                                          color: Colors.green,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16),
                                    ),
                                    onPressed: () {
                                      Get.to(
                                          () => const File(
                                                title: "",
                                              ),
                                          arguments: {
                                            'university':
                                                argumentData['university'],
                                            'course': argumentData['course'],
                                            'semester':
                                                argumentData['semester'],
                                            'subject': argumentData['subject'],
                                            'module': argumentData['module'],
                                            'category': categorys[i]
                                                ['fcategoryname'],
                                          });
                                    }),
                              ),
                            );
                          }),
                    ),
                  ],
                ),
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
