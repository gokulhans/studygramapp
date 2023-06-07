import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
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

  @override
  void initState() {
    super.initState();
    fetchData(); // Fetch data from API when the widget is initialized
    fetchCourseData();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                addVerticalSpace(20),
                Center(
                  child: Text(
                    'Complete Profile',
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        color: Colors.green),
                  ),
                ),
                addVerticalSpace(20),
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
                        await pref.setString('university', selectedTagName);
                        await pref.setString('course', selectedCourseName);
                        await pref.setString('coursename', selectedCourse);
                        await pref.setString('universityname', selectedTag);
                        await pref.setBool('user', true);
                        Get.to(() => MainPage());
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Text(
                          'Continue',
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
