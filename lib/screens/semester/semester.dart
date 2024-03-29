import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:studygram/screens/category/category.dart';
import 'package:http/http.dart' as http;
import 'package:studygram/screens/semester/semester.dart';
import 'package:studygram/screens/semester/semester.dart';
import 'package:studygram/screens/subject/subject.dart';
import 'package:studygram/utils/constants.dart';

class Semester extends StatelessWidget {
  const Semester({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Semester'),
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
  Future<List<Map<String, dynamic>>> fetchCourses() async {
    final response = await http.get(Uri.parse('${apidomain}semester'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      List<Map<String, dynamic>> semesters = data
          .map((item) => {
                '_id': item['_id'],
                'semestername': item['semestername'],
                'fsemestername': item['fsemestername'],
              })
          .toList();
      return semesters;
    } else {
      throw Exception('Failed to fetch semesters');
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
              List<Map<String, dynamic>> semesters = snapshot.data!;
              if (semesters.isEmpty) {
                return Center(child: const Text('No Semester available.'));
              }
              return Container(
                padding: const EdgeInsets.only(
                  left: 12,
                  right: 12,
                  top: 12,
                ),
                child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: semesters.length,
                    itemBuilder: (context, i) {
                      return Container(
                        height: 60,
                        width: MediaQuery.of(context).size.width / 2 - 18,
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
                                semesters[i]['semestername'],
                                // "English",
                                style: const TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16),
                              ),
                              onPressed: () async {
                                SharedPreferences pref =
                                    await SharedPreferences.getInstance();
                                var university =
                                    await pref.getString('university');
                                Get.to(
                                    () => const Subject(
                                          title: "",
                                        ),
                                    arguments: {
                                      'university': university,
                                      'course': argumentData['course'],
                                      'category': argumentData['category'],
                                      'semester': semesters[i]['fsemestername'],
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
