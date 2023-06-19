import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
// import 'package:image_picker/image_picker.dart';
import 'package:studygram/screens/category/category.dart';
import 'package:studygram/utils/constants.dart';
import 'package:cloudinary/cloudinary.dart';
import 'dart:io';

class Contribute extends StatefulWidget {
  @override
  _ContributeState createState() => _ContributeState();
}

class _ContributeState extends State<Contribute> {
  // Sample data fetched from backend

  void initState() {
    super.initState();
    fetchUniversityData(); // Fetch data from API when the widget is initialized
    fetchCourseData();
    fetchSemesterData();
    fetchCategoryData();
    fetchModuleData();
  }

  List<String> universities = [];
  List<String> courses = [];
  List<String> semesters = [];
  List<String> subjects = [];
  List<String> modules = [];
  List<String> categories = [];

  String selectedUniversity = 'select-university';
  String selectedCourse = 'select-course';
  String selectedSemester = 'select-semester';
  String selectedSubject = 'select-subject';
  String selectedModule = 'select-module';
  String selectedCategory = 'select-category';

  void fetchUniversityData() async {
    try {
      final response = await http.get(Uri.parse('${apidomain}university'));
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body) as List<dynamic>;
        List<String> fetchedUniversities = jsonData
            .map<String>((data) => data['funiname'].toString())
            .toList();
        fetchedUniversities.insert(0, 'select-university');
        print(fetchedUniversities[0]);
        setState(() {
          universities = fetchedUniversities;
        });
      } else {
        print('Failed to fetch university data. Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Failed to fetch university data. Error: $e');
    }
  }

  void fetchCourseData() async {
    try {
      final response = await http.get(Uri.parse('${apidomain}course'));
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body) as List<dynamic>;
        List<String> fetchedCourses = jsonData
            .map<String>((data) => data['fcoursename'].toString())
            .toList();
        fetchedCourses.insert(0, 'select-course');
        setState(() {
          courses = fetchedCourses;
        });
      } else {
        print('Failed to fetch course data. Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Failed to fetch course data. Error: $e');
    }
  }

  void fetchSemesterData() async {
    try {
      final response = await http.get(Uri.parse('${apidomain}semester'));
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body) as List<dynamic>;
        List<String> fetchedSemesters = jsonData
            .map<String>((data) => data['fsemestername'].toString())
            .toList();
        fetchedSemesters.insert(0, 'select-semester');
        setState(() {
          semesters = fetchedSemesters;
        });
      } else {
        print('Failed to fetch semester data. Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Failed to fetch semester data. Error: $e');
    }
  }

  void fetchSubjectData() async {
    try {
      final response = await http.get(Uri.parse(
          '${apidomain}subject/${selectedUniversity}/${selectedCourse}/${selectedSemester}/'));
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body) as List<dynamic>;
        List<String> fetchedSubjects = jsonData
            .map<String>((data) => data['fsubjectname'].toString())
            .toList();
        fetchedSubjects.insert(0, 'select-subject');
        setState(() {
          subjects = fetchedSubjects;
        });
      } else {
        print('Failed to fetch subject data. Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Failed to fetch subject data. Error: $e');
    }
  }

  void fetchModuleData() async {
    try {
      final response = await http.get(Uri.parse(
          '${apidomain}module/${selectedUniversity}/${selectedCourse}/${selectedSemester}/${selectedSubject}'));
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body) as List<dynamic>;
        List<String> fetchedModules = jsonData
            .map<String>((data) => data['fmodulename'].toString())
            .toList();
        fetchedModules.insert(0, 'select-module');
        setState(() {
          modules = fetchedModules;
        });
      } else {
        print('Failed to fetch module data. Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Failed to fetch module data. Error: $e');
    }
  }

  void fetchCategoryData() async {
    try {
      final response = await http.get(Uri.parse('${apidomain}category'));
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body) as List<dynamic>;
        List<String> fetchedCategories = jsonData
            .map<String>((data) => data['fcategoryname'].toString())
            .toList();
        fetchedCategories.insert(0, 'select-category');
        setState(() {
          categories = fetchedCategories;
        });
      } else {
        print('Failed to fetch category data. Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Failed to fetch category data. Error: $e');
    }
  }

  String imglink = "https://via.placeholder.com/1920x1080/eee?text=Store-Image";
  File? _imageFile;

  void _selectImage() async {
    // final pickedFile = await ImagePicker()
    //     .pickImage(source: ImageSource.gallery, imageQuality: 30);
    // if (pickedFile != null) {
    //   setState(() {
    //     _imageFile = File(pickedFile.path);
    //     print(_imageFile);
    //   });
    //   _uploadImage();
    // } else {
      print('error');
    // }
  }

  void _uploadImage() async {
    final now = DateTime.now();
    final timestamp = now.microsecondsSinceEpoch;
    final random = '${DateTime.now().millisecondsSinceEpoch}${now.microsecond}';
    final publicId = 'service_image_$timestamp$random';
    // if (_imageFile != null) {
    //   final response = await cloudinary.upload(
    //       file: _imageFile!.path,
    //       fileBytes: _imageFile!.readAsBytesSync(),
    //       resourceType: CloudinaryResourceType.image,
    //       folder: "serviceimages",
    //       fileName: publicId,
    //       progressCallback: (count, total) {
    //         print('Uploading image from file with progress: $count/$total');
    //       });
    //   if (response.isSuccessful) {
    //     print('Get your image from with ${response.secureUrl}');
    //     setState(() {
    //       imglink = response.secureUrl!;
    //     });
    //   }
    //   // shop.img = imglink;
    //   print(_imageFile);
    // } else {
    //   print('error');
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Contribute Page'),
      // ),
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
                child: Padding(
              padding: const EdgeInsets.only(bottom: 24.0),
              child: Text(
                'Contribute',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
              ),
            )),
            DropdownButtonFormField<String>(
              value: selectedUniversity,
              onChanged: (value) {
                setState(() {
                  selectedUniversity = value!;
                  fetchSubjectData();
                });
              },
              items: universities.map((university) {
                return DropdownMenuItem<String>(
                  value: university,
                  child: Text(
                    university,
                    style: TextStyle(fontSize: 16),
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              }).toList(),
              hint: Text('Select University'),
            ),
            SizedBox(height: 16.0),
            DropdownButtonFormField<String>(
              value: selectedCourse,
              onChanged: (value) {
                setState(() {
                  selectedCourse = value!;
                  fetchSubjectData();
                });
              },
              items: courses.map((course) {
                return DropdownMenuItem<String>(
                  value: course,
                  child: Text(
                    course,
                    style: TextStyle(fontSize: 16),
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              }).toList(),
              hint: Text('Select Course'),
            ),
            SizedBox(height: 16.0),
            DropdownButtonFormField<String>(
              value: selectedSemester,
              onChanged: (value) {
                setState(() {
                  selectedSemester = value!;
                  fetchSubjectData();
                });
              },
              items: semesters.map((semester) {
                return DropdownMenuItem<String>(
                  value: semester,
                  child: Text(
                    semester,
                    style: TextStyle(fontSize: 16),
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              }).toList(),
              hint: Text('Select Semester'),
            ),
            SizedBox(height: 16.0),
            DropdownButtonFormField<String>(
              value: selectedSubject,
              onChanged: (value) {
                setState(() {
                  selectedSubject = value!;
                  fetchSubjectData();
                });
              },
              items: subjects.map((subject) {
                return DropdownMenuItem<String>(
                  value: subject,
                  child: Text(
                    subject,
                    style: TextStyle(fontSize: 14),
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              }).toList(),
              hint: Text('Select Subject'),
            ),
            SizedBox(height: 16.0),
            DropdownButtonFormField<String>(
              value: selectedModule,
              onChanged: (value) {
                setState(() {
                  selectedModule = value!;
                  fetchSubjectData();
                });
              },
              items: modules.map((module) {
                return DropdownMenuItem<String>(
                  value: module,
                  child: Text(
                    module,
                    style: TextStyle(fontSize: 16),
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              }).toList(),
              hint: Text('Select Module'),
            ),
            SizedBox(height: 16.0),
            DropdownButtonFormField<String>(
              value: selectedCategory,
              onChanged: (value) {
                setState(() {
                  selectedCategory = value!;
                  fetchSubjectData();
                });
              },
              items: categories.map((category) {
                return DropdownMenuItem<String>(
                  value: category,
                  child: Text(
                    category,
                    style: TextStyle(fontSize: 16),
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              }).toList(),
              hint: Text('Select Category'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                _selectImage();
              },
              child: Text('Upload Document'),
            ),
          ],
        ),
      ),
    );
  }
}
