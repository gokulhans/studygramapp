import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:studygram/components/indicator/progress_indicator.dart';
import 'package:studygram/components/sidebar/sidebar.dart';
import 'package:http/http.dart' as http;
import 'package:studygram/main.dart';
import 'package:studygram/utils/constants.dart';
import 'package:studygram/utils/widget_functions.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CompleteProfile extends StatefulWidget {
  const CompleteProfile({super.key});

  @override
  State<CompleteProfile> createState() => _CompleteProfileState();
}

class _CompleteProfileState extends State<CompleteProfile> {
  List<Map<String, String>> tags = []; // Empty initial tags list
  String selectedTag = "";
  String selectedTagName = "";
  List<Map<String, String>> courses = [];
  String selectedCourse = "";
  String selectedCourseName = "";
  List<Map<String, String>> semesters = [];
  String selectedSemester = "";
  String selectedSemesterName = "";
  String UserName = "";
  bool loading = true;

  @override
  void initState() {
    super.initState();
    onload();
    fetchData();
  }

  void onload() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String University = await pref.getString('universityname')!;
    String Course = await pref.getString('coursename')!;
    String Semester = await pref.getString('semestername')!;
    String Universityid = await pref.getString('university')!;
    String Courseid = await pref.getString('course')!;
    String Semesterid = await pref.getString('semester')!;
    bool IsProfileCompletd = await pref.getBool('completeprofile')!;
    if (IsProfileCompletd) {
      fetchCourseData(University);
      fetchSemesterData();
    }
    setState(() {
      selectedTag = University;
      selectedCourse = Course;
      selectedSemester = Semester;
      selectedTagName = Universityid;
      selectedCourseName = Courseid;
      selectedSemesterName = Semesterid;
    });
  }

  Future<void> fetchData() async {
    try {
      final response = await http.get(Uri.parse('${apidomain}university'));
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body) as List<dynamic>;
        print(jsonData);
        setState(() {
          tags = jsonData
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

  Future<void> fetchCourseData(selectedUniversityName) async {
    try {
      final response = await http
          .get(Uri.parse('${apidomain}course/${selectedUniversityName}'));
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
        loading = false;
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
        print('Failed to fetch Semester data. Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Failed to fetch Semester data. Error: $e');
    }
  }

  void handleTagSelection(String selectedTag, String selectedTagName) {
    setState(() {
      this.selectedTag = selectedTag;
      this.selectedTagName = selectedTagName;
    });

    final selectedTagData = tags.firstWhere(
      (tag) => tag['uniname'] == selectedTag,
    );
    print('Selected funiname: ${selectedTagData['funiname']}');
  }

  void handleCourseSelection(String selectedCourse, String selectedCourseName) {
    setState(() {
      this.selectedCourse = selectedCourse;
      this.selectedCourseName = selectedCourseName;
    });

    final selectedCourseData = courses.firstWhere(
      (course) => course['coursename'] == selectedCourse,
    );
    print('Selected Course code: ${selectedCourseData['fcoursename']}');
  }

  void handleSemesterSelection(
      String selectedSemester, String selectedSemesterName) {
    setState(() {
      this.selectedSemester = selectedSemester;
      this.selectedSemesterName = selectedSemesterName;
    });

    final selectedSemesterData = semesters.firstWhere(
      (semester) => semester['semestername'] == selectedSemester,
    );
    print('Selected Semester code: ${selectedSemesterData['fsemestername']}');
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: loading
          ? LoadingIndicator(
              progress: 100,
            )
          : Scaffold(
              backgroundColor: Colors.white,
              // appBar: AppBar(
              //   systemOverlayStyle: const SystemUiOverlayStyle(
              //     // Status bar color
              //     statusBarColor: Colors.white,
              //     // Status bar brightness (optional)
              //     statusBarIconBrightness: Brightness.dark, // For Android (dark icons)
              //   ),
              //   backgroundColor: Colors.white,
              //   bottomOpacity: 0.0,
              //   elevation: 0.0,
              //   centerTitle: true,
              //   title: const Text(
              //     "Studygram",
              //     style: TextStyle(
              //         color: Colors.black87, fontSize: 20, fontWeight: FontWeight.w700),
              //   ),
              // ),
              body: Center(
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 20, right: 20, bottom: 20, top: 10),
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        addVerticalSpace(10),
                        Center(
                          child: Text(
                            'Complete Profile',
                            style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w900,
                                color: Colors.green),
                          ),
                        ),
                        // addVerticalSpace(20),
                        // Text(
                        //   'Name:',
                        //   style: TextStyle(
                        //     fontSize: 20,
                        //     fontWeight: FontWeight.bold,
                        //   ),
                        // ),
                        // SizedBox(height: 24),
                        // TextFormField(
                        //   initialValue: "",
                        //   // //controller: nameController,
                        //   onChanged: (val) {
                        //     UserName = val;
                        //   },
                        //   decoration: InputDecoration(
                        //       labelText: UserName,
                        //       labelStyle: TextStyle(
                        //           fontFamily: 'Montserrat',
                        //           fontWeight: FontWeight.bold,
                        //           color: Colors.grey),
                        //       focusedBorder: UnderlineInputBorder(
                        //           borderSide: BorderSide(color: Colors.green))),
                        // ),
                        SizedBox(height: 20),
                        Text(
                          'Select University:',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 24),
                        Wrap(
                          spacing: 8.0,
                          runSpacing: 4.0,
                          children: tags.map((tag) {
                            final String tagText = tag['uniname']!;
                            final String selectedTagName = tag['funiname']!;
                            return ChoiceChip(
                              label: Text(
                                tagText,
                                style: TextStyle(
                                  color: selectedTag == tagText
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                              selected: selectedTag == tagText,
                              selectedColor: Colors.green,
                              onSelected: (isSelected) {
                                fetchCourseData(selectedTagName);
                                handleTagSelection(tagText, selectedTagName);
                              },
                            );
                          }).toList(),
                        ),
                        SizedBox(height: 24),
                        Text(
                          'Select Course:',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 24),
                        Wrap(
                          spacing: 8.0,
                          runSpacing: 2.0,
                          children: courses.map((course) {
                            final String courseName = course['coursename']!;
                            final String fcourseName = course['fcoursename']!;
                            return ChoiceChip(
                              label: Text(
                                courseName,
                                style: TextStyle(
                                  color: selectedCourse == courseName
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                              selected: selectedCourse == courseName,
                              selectedColor: Colors.green,
                              onSelected: (isSelected) {
                                handleCourseSelection(courseName, fcourseName);
                                fetchSemesterData();
                              },
                            );
                          }).toList(),
                        ),
                        SizedBox(height: 24),
                        Text(
                          'Select Semester:',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 24),
                        Wrap(
                          spacing: 8.0,
                          runSpacing: 2.0,
                          children: semesters.map((semester) {
                            final String semesterName =
                                semester['semestername']!;
                            final String fsemesterName =
                                semester['fsemestername']!;
                            return ChoiceChip(
                              label: Text(
                                semesterName,
                                style: TextStyle(
                                  color: selectedSemester == semesterName
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                              selected: selectedSemester == semesterName,
                              selectedColor: Colors.green,
                              onSelected: (isSelected) {
                                handleSemesterSelection(
                                    semesterName, fsemesterName);
                              },
                            );
                          }).toList(),
                        ),
                        SizedBox(height: 16),
                        Center(
                          child: Container(
                            width: 150,
                            height: 40,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: ElevatedButton(
                              onPressed: () async {
                                print({selectedTagName, selectedCourseName});
                                SharedPreferences pref =
                                    await SharedPreferences.getInstance();
                                await pref.setString(
                                    'university', selectedTagName);
                                await pref.setString(
                                    'course', selectedCourseName);
                                await pref.setString(
                                    'semester', selectedSemesterName);
                                await pref.setString(
                                    'coursename', selectedCourse);
                                await pref.setString(
                                    'universityname', selectedTag);
                                await pref.setString(
                                    'semestername', selectedSemester);
                                // await pref.setString('username', UserName);
                                await pref.setBool('completeprofile', true);
                                var msgclr = Colors.green[400];
                                String msg = "Success";
                                String msgdesc = "Profile Saved Successfully";
                                Get.snackbar(
                                  msg,
                                  msgdesc,
                                  icon: const Icon(Icons.person,
                                      color: Colors.white),
                                  snackPosition: SnackPosition.BOTTOM,
                                  backgroundColor: msgclr,
                                  borderRadius: 12,
                                  margin: const EdgeInsets.all(15),
                                  colorText: Colors.white,
                                  duration: const Duration(seconds: 3),
                                  isDismissible: true,
                                  dismissDirection: DismissDirection.horizontal,
                                  forwardAnimationCurve: Curves.bounceIn,
                                );
                                Get.offAll(() => MainPage());
                              },
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Text(
                                  'Save',
                                  style: TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        addVerticalSpace(20)
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
