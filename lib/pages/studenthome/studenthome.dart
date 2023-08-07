import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:studygram/components/appbar/appbarwithback.dart';
import 'package:studygram/components/indicator/progress_indicator.dart';
import 'package:studygram/components/sidebar/sidebar.dart';
import 'package:studygram/screens/category/category.dart';
import 'package:studygram/screens/course/course.dart';
import 'package:studygram/screens/semester/semester.dart';
import 'package:studygram/screens/university/university.dart';
import 'package:studygram/utils/constants.dart';
import 'package:http/http.dart' as http;
import 'package:studygram/utils/widget_functions.dart';

class StudentHome extends StatelessWidget {
  const StudentHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          "JustPass",
          style: TextStyle(
              color: Colors.black, fontSize: 18, fontWeight: FontWeight.w800),
        ),
        iconTheme: IconThemeData(color: Colors.green),
      ),
      body: Container(color: Colors.white, child: const StudentHomePage()),
    );
  }
}

class StudentHomePage extends StatefulWidget {
  const StudentHomePage({Key? key}) : super(key: key);
  @override
  State<StudentHomePage> createState() => _StudentHomePageState();
}

class _StudentHomePageState extends State<StudentHomePage> {
  List<Map<String, String>> courses = [];
  String selectedCourse = "";
  String selectedCourseName = "";

  List<Map<String, String>> university = [];
  String selectedUniversity = "";
  String selectedUniversityName = "";

  List<Map<String, String>> semesters = [];
  String selectedSemester = "";
  String selectedSemesterName = "";

  List<Map<String, String>> categories = [];
  String selectedCategory = "";
  String selectedCategoryName = "";

  String useruniversity = "";
  String usercourse = "";
  bool isCompletedProfile = false;

  bool isLoading = true;

  void onload() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    useruniversity = prefs.getString('universityname')!;
    usercourse = prefs.getString('coursename')!;
    isCompletedProfile = prefs.getBool('completedprofile')!;
  }

  @override
  void initState() {
    super.initState();
    fetchCourseData();
    fetchUniversityData();
    // fetchSemesterData();
    fetchCategoryData();
    onload();
  }

  Future<void> fetchCategoryData() async {
    try {
      final response = await http.get(Uri.parse('${apidomain}category'));
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body) as List<dynamic>;
        print(jsonData);
        setState(() {
          categories = jsonData
              .map<Map<String, String>>((data) => {
                    'categoryname': data['categoryname'].toString(),
                    'fcategoryname': data['fcategoryname'].toString(),
                    'image': data['image'].toString(),
                  })
              .toList();
          isLoading = false;
        });
      } else {
        print('Failed to fetch data. Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Failed to fetch data. Error: $e');
    }
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
                    'image': data['image'].toString(),
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
                    'image': data['image'].toString(),
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
    return isLoading
        ? LoadingIndicator(
            progress: null,
          )
        : Scaffold(
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
                        isCompletedProfile
                            ? Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
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
                                                  builder: (context) =>
                                                      const University(
                                                        title: 'University',
                                                      )),
                                            );
                                          },
                                          child: const Text(
                                            "View All",
                                            style: TextStyle(
                                              color: Colors.green,
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
                                      crossAxisCount:
                                          4, // Number of columns in the grid
                                      // mainAxisSpacing: 5.0, // Spacing between rows
                                      // crossAxisSpacing: 5.0, // Spacing between columns
                                      childAspectRatio:
                                          0.8, // Aspect ratio of each grid item
                                    ),
                                    itemCount: university.length,
                                    itemBuilder: (context, index) {
                                      return TextButton(
                                        onPressed: () async {
                                          Get.to(
                                              const Course(
                                                title: "",
                                              ),
                                              arguments: {
                                                'university': university[index]
                                                    ['funiname']!,
                                              });
                                        },
                                        child: Column(
                                          children: [
                                            Container(
                                              height: 64,
                                              width: 64,
                                              decoration: BoxDecoration(
                                                  color: Colors.black
                                                      .withOpacity(0.05),
                                                  borderRadius:
                                                      BorderRadius.circular(50),
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
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          100.0),
                                                  child: Image(
                                                      width: 64,
                                                      height: 64,
                                                      fit: BoxFit.cover,
                                                      image: NetworkImage(
                                                          university[index]
                                                              ['image']!)),
                                                ),
                                              ),
                                            ),
                                            addVerticalSpace(5),
                                            Text(
                                              university[index]['uniname']!,
                                              textAlign: TextAlign.center,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              // convertName(categories[index]['categoryname']!),
                                              style: const TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w900,
                                                  fontSize: 12),
                                            )
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                ],
                              )
                            : Container(),
                        // Padding(
                        //   padding: const EdgeInsets.symmetric(horizontal: 20),
                        //   child: Row(
                        //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //     children: [
                        //       Text(
                        //         usercourse,
                        //         style: const TextStyle(
                        //           fontSize: 20,
                        //           fontWeight: FontWeight.w700,
                        //         ),
                        //       ),
                        //       TextButton(
                        //         onPressed: () async {
                        //           SharedPreferences prefs =
                        //               await SharedPreferences.getInstance();
                        //           String? university = prefs.getString('university');
                        //           String? course = prefs.getString('course');
                        //           Get.to(
                        //             () => const Semester(
                        //               title: 'semester',
                        //             ),
                        //             arguments: {
                        //               'university': university,
                        //               'course': course,
                        //             },
                        //           );
                        //         },
                        //         child: const Text(
                        //           "View All",
                        //           style: TextStyle(
                        //             color: Colors.green,
                        //             fontSize: 14,
                        //             fontWeight: FontWeight.w700,
                        //           ),
                        //         ),
                        //       ),
                        //     ],
                        //   ),
                        // ),
                        // Padding(
                        //   padding: const EdgeInsets.all(8.0),
                        //   child: GridView.builder(
                        //     shrinkWrap: true, // Add this property
                        //     physics:
                        //         const NeverScrollableScrollPhysics(), // Add this property
                        //     gridDelegate:
                        //         const SliverGridDelegateWithFixedCrossAxisCount(
                        //       crossAxisCount: 4, // Number of columns in the grid
                        //       mainAxisSpacing: 0, // Spacing between rows
                        //       crossAxisSpacing: 0, // Spacing between columns
                        //       childAspectRatio: 1, // Aspect ratio of each grid item
                        //     ),
                        //     itemCount: semesters.length,
                        //     itemBuilder: (context, index) {
                        //       return TextButton(
                        //         onPressed: () async {
                        //           SharedPreferences prefs =
                        //               await SharedPreferences.getInstance();
                        //           String? university = prefs.getString('university');
                        //           String? course = prefs.getString('course');
                        //           Get.to(() => const Subject(title: "title"),
                        //               arguments: {
                        //                 'university': university,
                        //                 'course': course,
                        //                 'semester': semesters[index]
                        //                     ['fsemestername']!,
                        //               });
                        //         },
                        //         child: Column(
                        //           children: <Widget>[
                        //             Container(
                        //                 height: 64,
                        //                 width: 64,
                        //                 decoration: BoxDecoration(
                        //                     color: Colors.black.withOpacity(0.05),
                        //                     borderRadius: BorderRadius.circular(50),
                        //                     boxShadow: const [
                        //                       // Shadow for top-left corner
                        //                       BoxShadow(
                        //                         color: Colors.grey,
                        //                         offset: Offset(1, 1),
                        //                         blurRadius: 2,
                        //                         spreadRadius: 0.3,
                        //                       ),
                        //                       // Shadow for bottom-right corner
                        //                       BoxShadow(
                        //                         color: Colors.white,
                        //                         offset: Offset(-1, -1),
                        //                         blurRadius: 1,
                        //                         spreadRadius: 3,
                        //                       ),
                        //                     ]),
                        //                 child: Center(
                        //                     child: Text(
                        //                   convertName(
                        //                       semesters[index]['semestername']!),
                        //                   style: const TextStyle(
                        //                       color: Colors.black,
                        //                       fontWeight: FontWeight.w900,
                        //                       fontSize: 14),
                        //                 ))),
                        //           ],
                        //         ),
                        //       );
                        //     },
                        //   ),
                        // ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Select Category",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              TextButton(
                                onPressed: () async {
                                  SharedPreferences prefs =
                                      await SharedPreferences.getInstance();
                                  String? university =
                                      prefs.getString('university');
                                  String? course = prefs.getString('course');
                                  Get.to(
                                      () => const Category(
                                            title: "",
                                          ),
                                      arguments: {
                                        'university': university,
                                        'course': course,
                                      });
                                },
                                child: const Text(
                                  "View All",
                                  style: TextStyle(
                                    color: Colors.green,
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
                              crossAxisCount:
                                  4, // Number of columns in the grid
                              mainAxisSpacing: 0, // Spacing between rows
                              crossAxisSpacing: 0, // Spacing between columns
                              childAspectRatio:
                                  0.8, // Aspect ratio of each grid item
                            ),
                            itemCount: categories.length,
                            itemBuilder: (context, index) {
                              return TextButton(
                                onPressed: () async {
                                  SharedPreferences prefs =
                                      await SharedPreferences.getInstance();
                                  String? university =
                                      prefs.getString('university');
                                  String? course = prefs.getString('course');
                                  Get.to(
                                      () => const Semester(
                                            title: "",
                                          ),
                                      arguments: {
                                        'university': university,
                                        'course': course,
                                        'category': categories[index]
                                            ['fcategoryname']!,
                                      });
                                },
                                child: Column(
                                  children: [
                                    Container(
                                      height: 48,
                                      width: 48,
                                      decoration: BoxDecoration(
                                          color: Colors.black.withOpacity(0.05),
                                          borderRadius:
                                              BorderRadius.circular(50),
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
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(100.0),
                                          child: Image(
                                              width: 48,
                                              height: 48,
                                              fit: BoxFit.cover,
                                              image: NetworkImage(
                                                  categories[index]['image']!)),
                                        ),
                                      ),
                                    ),
                                    addVerticalSpace(10),
                                    Text(
                                      categories[index]['categoryname']!,
                                      textAlign: TextAlign.center,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      // convertName(categories[index]['categoryname']!),
                                      style: TextStyle(
                                          color: Colors.grey.shade800,
                                          fontWeight: FontWeight.w900,
                                          fontSize: 10),
                                    )
                                  ],
                                ),
                              );
                            },
                          ),
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
                                  String? university =
                                      prefs.getString('university');
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
                                    color: Colors.green,
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
                              crossAxisCount:
                                  4, // Number of columns in the grid
                              mainAxisSpacing: 0, // Spacing between rows
                              crossAxisSpacing: 0, // Spacing between columns
                              childAspectRatio:
                                  0.8, // Aspect ratio of each grid item
                            ),
                            itemCount: courses.length,
                            itemBuilder: (context, index) {
                              return TextButton(
                                onPressed: () async {
                                  SharedPreferences prefs =
                                      await SharedPreferences.getInstance();
                                  String? university =
                                      prefs.getString('university');
                                  Get.to(
                                      () => const Category(
                                            title: "",
                                          ),
                                      arguments: {
                                        'university': university,
                                        'course': courses[index]['fcoursename']
                                      });
                                },
                                child: Column(
                                  children: [
                                    Container(
                                      height: 48,
                                      width: 48,
                                      decoration: BoxDecoration(
                                          color: Colors.black.withOpacity(0.05),
                                          borderRadius:
                                              BorderRadius.circular(50),
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
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(100.0),
                                          child: Image(
                                              width: 48,
                                              height: 48,
                                              fit: BoxFit.cover,
                                              image: NetworkImage(
                                                  courses[index]['image']!)),
                                        ),
                                      ),
                                    ),
                                    addVerticalSpace(10),
                                    Text(
                                      courses[index]['coursename']!,
                                      textAlign: TextAlign.center,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      // convertName(categories[index]['categoryname']!),
                                      style: TextStyle(
                                          color: Colors.grey.shade800,
                                          fontWeight: FontWeight.w900,
                                          fontSize: 10),
                                    )
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
