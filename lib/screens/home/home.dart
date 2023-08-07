import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:studygram/components/indicator/progress_indicator.dart';
import 'package:studygram/components/sidebar/sidebar.dart';
import 'package:studygram/screens/category/category.dart';
import 'package:studygram/screens/course/course.dart';
import 'package:studygram/screens/profile/complete_profile.dart';
import 'package:studygram/screens/semester/semester.dart';
import 'package:studygram/screens/subject/subject.dart';
import 'package:studygram/screens/university/university.dart';
import 'package:studygram/screens/video/videolist.dart';
import 'package:studygram/utils/constants.dart';
import 'package:http/http.dart' as http;
import 'package:studygram/utils/widget_functions.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(color: Colors.white, child: const HomePage()),
      drawer: NavDrawer(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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

  List<Map<String, String>> subjects = [];
  String selectedSubject = "";
  String selectedSubjectname = "";

  String useruniversity = "";
  String usercourse = "";
  String usersemester = "";
  bool isCompletedProfile = false;

  bool isLoading = true;

  void onload() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    useruniversity = prefs.getString('university')!;
    usercourse = prefs.getString('course')!;
    usersemester = prefs.getString('semester')!;
    isCompletedProfile = prefs.getBool('completeprofile')!;
    print({useruniversity, usercourse, usersemester, isCompletedProfile});
    fetchSubjectData();
  }

  @override
  void initState() {
    super.initState();
    fetchCategoryData();
    onload();
  }

  Future<void> fetchSubjectData() async {
    try {
      final response = await http.get(Uri.parse(
          '${apidomain}videosubject/${useruniversity}/${usercourse}/${usersemester}'));
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body) as List<dynamic>;
        print(jsonData);
        setState(() {
          subjects = jsonData
              .map<Map<String, String>>((data) => {
                    '_id': data['_id'],
                    'subjectname': data['subjectname'].toString(),
                    'fsubjectname': data['fsubjectname'].toString(),
                  })
              .toList();
          isLoading = false;
          print(subjects);
        });
      } else {
        print('Failed to fetch data. Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Failed to fetch data. Error: $e');
    }
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
              physics:
                  BouncingScrollPhysics(), // Add BouncingScrollPhysics here
              child: Column(
                children: [
                  SizedBox(
                    height: 200,
                    child: CarouselSlider(
                      items: [
                        InkWell(
                          onTap: () {},
                          child: Container(
                            height: 180,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0),
                              image: const DecorationImage(
                                image: NetworkImage(
                                    "https://outq.vercel.app/image1.jpg"),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {},
                          child: Container(
                            height: 180,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0),
                              image: const DecorationImage(
                                image: NetworkImage(
                                    "https://outq.vercel.app/image2.jpg"),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {},
                          child: Container(
                            height: 180,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0),
                              image: const DecorationImage(
                                image: NetworkImage(
                                    "https://outq.vercel.app/image3.jpg"),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ],
                      options: CarouselOptions(
                        height: 180.0,
                        enlargeCenterPage: true,
                        autoPlay: true,
                        aspectRatio: 16 / 9,
                        autoPlayCurve: Curves.fastOutSlowIn,
                        enableInfiniteScroll: true,
                        autoPlayAnimationDuration:
                            const Duration(milliseconds: 800),
                        viewportFraction: 0.8,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Category",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        TextButton(
                          onPressed: () async {
                            // SharedPreferences prefs =
                            //     await SharedPreferences.getInstance();
                            // String? university = prefs.getString('university');
                            // String? course = prefs.getString('course');
                            // Get.to(
                            //     () => const Category(
                            //           title: "",
                            //         ),
                            //     arguments: {
                            //       'university': university,
                            //       'course': course,
                            //     });
                          },
                          child: const Text(
                            "",
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
                      crossAxisCount: 4, // Number of columns in the grid
                      mainAxisSpacing: 0, // Spacing between rows
                      crossAxisSpacing: 0, // Spacing between columns
                      childAspectRatio: 0.9, // Aspect ratio of each grid item
                    ),
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      return TextButton(
                        onPressed: () async {
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          String? university = prefs.getString('university');
                          String? course = prefs.getString('course');
                          String? semester = prefs.getString('semester');
                          Get.to(
                              () => const Subject(
                                    title: "",
                                  ),
                              arguments: {
                                'university': university,
                                'course': course,
                                'semester': semester,
                                'category': categories[index]['fcategoryname'],
                              });
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: 48,
                              width: 48,
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
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(100.0),
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
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "My Course",
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        TextButton(
                          onPressed: () async {
                            // SharedPreferences prefs =
                            //     await SharedPreferences.getInstance();
                            // String? university = prefs.getString('university');
                            // String? course = prefs.getString('course');
                            // Get.to(
                            //   () => const Semester(
                            //     title: 'semester',
                            //   ),
                            //   arguments: {
                            //     'university': university,
                            //     'course': course,
                            //   },
                            // );
                          },
                          child: const Text(
                            "",
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
                  ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: subjects.length,
                    itemBuilder: (context, index) {
                      return TextButton(
                        onPressed: () async {
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          String? university = prefs.getString('university');
                          String? course = prefs.getString('course');
                          String? semester = prefs.getString('semester');
                          Get.to(
                              () => const Videolist(
                                    title: "",
                                  ),
                              arguments: {
                                'university': university,
                                'course': course,
                                'semester': semester,
                                'subject': subjects[index]['fsubjectname'],
                                'category': 'videos',
                              });
                        },
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
                                          Icons.video_collection,
                                          color: Colors.green,
                                          size: 26,
                                        ),
                                      )),
                                ),
                                title: Text(
                                  subjects[index]['subjectname']!,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15,
                                  ),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        // Add any other desired widgets here
                                        Text("${usersemester}"),
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
                      );
                    },
                  ),
                  addVerticalSpace(10)
                ],
              ),
            ));
  }
}
