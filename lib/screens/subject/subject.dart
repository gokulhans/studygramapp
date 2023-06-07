import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:studygram/screens/category/category.dart';
import 'package:http/http.dart' as http;
import 'package:studygram/screens/module/module.dart';
import 'package:studygram/screens/subject/subject.dart';
import 'package:studygram/screens/subject/subject.dart';
import 'package:studygram/screens/subject/subject.dart';
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
    final response = await http.get(Uri.parse(
        '${apidomain}subject/${argumentData['university']}/${argumentData['course']}/${argumentData['semester']}'));
    // print({
    //   "${apidomain}subject/${argumentData['university']}/${argumentData['course']}/${argumentData['semester']}"
    // });
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
              return const Center(
                child: SpinKitCircle(
                  size: 80,
                  color: Colors.green,
                ),
              );
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
                                subjects[i]['subjectname'],
                                // "English",
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,),
                              ),
                              onPressed: () {
                                Get.to(
                                    () => const Module(
                                          title: "",
                                        ),
                                    arguments: {
                                      'university': argumentData['university'],
                                      'course': argumentData['course'],
                                      'semester': argumentData['semester'],
                                      'subject': subjects[i]['fsubjectname'],
                                    });
                              }),
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
