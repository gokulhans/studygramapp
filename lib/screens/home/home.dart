import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:studygram/components/sidebar/sidebar.dart';
import 'package:studygram/screens/course/course.dart';
import 'package:studygram/screens/semester/semester.dart';
import 'package:studygram/screens/university/university.dart';
import 'package:studygram/utils/constants.dart';
import 'package:studygram/utils/sizes.dart';
import 'package:http/http.dart' as http;
import 'package:studygram/utils/widget_functions.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(color: Colors.white, child: const MainPage()),
      drawer: NavDrawer(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);
  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  List<Map<String, String>> courses = [];
  String selectedCourse = "";
  String selectedCourseName = "";

  List<Map<String, String>> university = [];
  String selectedUniversity = "";
  String selectedUniversityName = "";

  List<Map<String, String>> semesters = [];
  String selectedSemester = "";
  String selectedSemesterName = "";

  String useruniversity = "";
  String usercourse = "";

  void onload() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    useruniversity = prefs.getString('universityname')!;
    usercourse = prefs.getString('coursename')!;
  }

  @override
  void initState() {
    super.initState();
    fetchCourseData();
    fetchUniversityData();
    fetchSemesterData();
    onload();
  }

  Future<void> fetchUniversityData() async {
    try {
      final response = await http.get(Uri.parse('${apidomain}university'));
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body) as List<dynamic>;
        print(jsonData);
        setState(() {
          university = jsonData
              .map<Map<String, String>>((data) => {
                    'uniname': data['uniname'].toString(),
                    'funiname': data['funiname'].toString(),
                  })
              .toList();
        });
      } else {
        print('Failed to fetch data. Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Failed to fetch data. Error: $e');
    }
  }

  Future<void> fetchCourseData() async {
    try {
      final response = await http.get(Uri.parse('${apidomain}course'));
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body) as List<dynamic>;
        print(jsonData);
        setState(() {
          courses = jsonData
              .map<Map<String, String>>((data) => {
                    'coursename': data['coursename'].toString(),
                    'fcoursename': data['fcoursename'].toString(),
                  })
              .toList();
        });
      } else {
        print('Failed to fetch course data. Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Failed to fetch course data. Error: $e');
    }
  }

  Future<void> fetchSemesterData() async {
    try {
      final response = await http.get(Uri.parse('${apidomain}semester'));
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body) as List<dynamic>;
        print(jsonData);
        setState(() {
          semesters = jsonData
              .map<Map<String, String>>((data) => {
                    'semestername': data['semestername'].toString(),
                    'fsemestername': data['fsemestername'].toString(),
                  })
              .toList();
        });
      } else {
        print('Failed to fetch semester data. Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Failed to fetch semester data. Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              Container(
                color: Colors.white,
                child: Column(children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "All Universities",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const University(
                                        title: 'University',
                                      )),
                            );
                          },
                          child: const Text(
                            "View All",
                            style: TextStyle(
                              color: Colors.orange,
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  GridView.builder(
                    shrinkWrap: true, // Add this property
                    physics:
                        const NeverScrollableScrollPhysics(), // Add this property
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4, // Number of columns in the grid
                      // mainAxisSpacing: 5.0, // Spacing between rows
                      // crossAxisSpacing: 5.0, // Spacing between columns
                      childAspectRatio: 1, // Aspect ratio of each grid item
                    ),
                    itemCount: university.length,
                    itemBuilder: (context, index) {
                      return TextButton(
                        onPressed: () async {
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          String? university = prefs.getString('university');
                          Get.to(() => const Semester(title: "title"),
                              arguments: {
                                'university': university,
                              });
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                                height: 64,
                                width: 64,
                                decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.05),
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
                                    child: Text(
                                  convertName(university[index]['uniname']!),
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w900,
                                      fontSize: 14),
                                ))),
                            // Text(
                            //   university[index]['uniname']!,
                            //   style: TextStyle(
                            //       fontSize: 10, fontWeight: FontWeight.w700),
                            //   textAlign: TextAlign.center,
                            // )
                          ],
                        ),
                      );
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          useruniversity,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        TextButton(
                          onPressed: () async {
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            String? university = prefs.getString('university');
                            Get.to(
                              () => const Course(
                                title: 'Course',
                              ),
                              arguments: {
                                'university': university,
                              },
                            );
                          },
                          child: const Text(
                            "View All",
                            style: TextStyle(
                              color: Colors.orange,
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GridView.builder(
                      shrinkWrap: true, // Add this property
                      physics:
                          const NeverScrollableScrollPhysics(), // Add this property
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4, // Number of columns in the grid
                        // mainAxisSpacing: 10.0, // Spacing between rows
                        // crossAxisSpacing: 10.0, // Spacing between columns
                        childAspectRatio: 1.0, // Aspect ratio of each grid item
                      ),
                      itemCount: courses.length,
                      itemBuilder: (context, index) {
                        return TextButton(
                          onPressed: () async {
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            String? university = prefs.getString('university');
                            String? course = prefs.getString('course');
                            Get.to(() => const Semester(title: "title"),
                                arguments: {
                                  'university': university,
                                  'course': courses[index]['fcoursename']
                                });
                          },
                          child: Column(
                            children: <Widget>[
                              Container(
                                  height: 64,
                                  width: 64,
                                  decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.05),
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
                                      child: Text(
                                    convertName(courses[index]['coursename']!),
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w900,
                                        fontSize: 14),
                                  ))),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          usercourse,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        TextButton(
                          onPressed: () async {
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            String? university = prefs.getString('university');
                            String? course = prefs.getString('course');
                            Get.to(
                              () => const Semester(
                                title: 'semester',
                              ),
                              arguments: {
                                'university': university,
                                'course': course,
                              },
                            );
                          },
                          child: const Text(
                            "View All",
                            style: TextStyle(
                              color: Colors.orange,
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GridView.builder(
                      shrinkWrap: true, // Add this property
                      physics:
                          const NeverScrollableScrollPhysics(), // Add this property
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4, // Number of columns in the grid
                        mainAxisSpacing: 0, // Spacing between rows
                        crossAxisSpacing: 0, // Spacing between columns
                        childAspectRatio: 1, // Aspect ratio of each grid item
                      ),
                      itemCount: semesters.length,
                      itemBuilder: (context, index) {
                        return TextButton(
                          onPressed: () async {
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            String? university = prefs.getString('university');
                            String? course = prefs.getString('course');
                            Get.to(() => const Semester(title: "title"),
                                arguments: {
                                  'university': university,
                                  'course': course,
                                  'semester': semesters[index]
                                      ['fsemestername']!,
                                });
                          },
                          child: Column(
                            children: <Widget>[
                              Container(
                                  height: 64,
                                  width: 64,
                                  decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.05),
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
                                      child: Text(
                                    convertName(
                                        semesters[index]['semestername']!),
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w900,
                                        fontSize: 14),
                                  ))),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 4,
                  )
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
