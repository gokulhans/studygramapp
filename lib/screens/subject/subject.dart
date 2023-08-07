import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:studygram/components/indicator/progress_indicator.dart';
import 'package:studygram/screens/files/file.dart';
import 'package:studygram/screens/module/module.dart';
import 'package:studygram/screens/video/videolist.dart';
import 'package:studygram/utils/constants.dart';

class Subject extends StatelessWidget {
  const Subject({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Subject'),
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
    SharedPreferences pref = await SharedPreferences.getInstance();
    var university = await pref.getString('university');
    final response;
    if (argumentData['category'] == 'videos') {
      response = await http.get(Uri.parse(
          '${apidomain}videosubject/${university}/${argumentData['course']}/${argumentData['semester']}'));
    } else {
      response = await http.get(Uri.parse(
          '${apidomain}subject/${university}/${argumentData['course']}/${argumentData['semester']}'));
    }
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      List<Map<String, dynamic>> subjects = data
          .map((item) => {
                '_id': item['_id'],
                'subjectname': item['subjectname'],
                'fsubjectname': item['fsubjectname'],
              })
          .toList();
      return subjects;
    } else {
      throw Exception('Failed to fetch subjects');
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
              return LoadingIndicator(progress: 100);
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (snapshot.hasData) {
              List<Map<String, dynamic>> subjects = snapshot.data!;
              if (subjects.isEmpty) {
                return Center(child: const Text('No Subject available.'));
              }
              return Container(
                padding: const EdgeInsets.only(
                  left: 12,
                  right: 12,
                  top: 12,
                ),
                child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: subjects.length,
                    itemBuilder: (context, i) {
                      return TextButton(
                          child: Container(
                            margin: const EdgeInsets.only(left: 3, right: 3),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.shade300,
                                  offset: Offset(0.5, 0.5),
                                  blurRadius: 1,
                                  spreadRadius: 0.3,
                                ),
                                // BoxShadow(
                                //   color: Colors.grey,
                                //   offset: Offset(-1, -1),
                                //   blurRadius: 2,
                                //   spreadRadius: 0.3,
                                // ),
                              ],
                            ),
                            child: Column(
                              children: [
                                ListTile(
                                  contentPadding: const EdgeInsets.only(
                                      left: 10, right: 5, top: 5, bottom: 5),
                                  leading: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Container(
                                        width: 40,
                                        child: Center(
                                          child: Icon(
                                            argumentData['category'] == 'videos'
                                                ? Icons.video_collection
                                                : Icons.file_copy,
                                            color: Colors.green,
                                            size: 26,
                                          ),
                                        )),
                                  ),
                                  title: Text(
                                    subjects[i]['subjectname']!,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15,
                                    ),
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          // Add any other desired widgets here
                                          Text("${argumentData["semester"]}"),
                                        ],
                                      ),
                                    ],
                                  ),
                                  trailing: Icon(
                                    Icons.arrow_forward,
                                    color: Colors.green,
                                    size: 24.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          onPressed: () {
                            if (argumentData['category'] == 'videos') {
                              Get.to(
                                  () => const Videolist(
                                        title: "",
                                      ),
                                  arguments: {
                                    'university': argumentData['university'],
                                    'course': argumentData['course'],
                                    'semester': argumentData['semester'],
                                    'subject': subjects[i]['fsubjectname'],
                                    // 'module': argumentData['module'],
                                    'category': argumentData['category'],
                                  });
                            } else {
                              Get.to(
                                  () => const File(
                                        title: "",
                                      ),
                                  arguments: {
                                    'university': argumentData['university'],
                                    'course': argumentData['course'],
                                    'semester': argumentData['semester'],
                                    'subject': subjects[i]['fsubjectname'],
                                    // 'module': argumentData['module'],
                                    'category': argumentData['category'],
                                  });
                            }
                          });
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
