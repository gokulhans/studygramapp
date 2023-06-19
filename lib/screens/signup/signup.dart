import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:studygram/models/usermodel.dart';
import 'package:studygram/screens/community/community.dart';
import 'package:studygram/screens/login/login.dart';
import 'package:studygram/utils/color_constants.dart';
import 'package:studygram/utils/constants.dart';
import 'package:studygram/utils/sizes.dart';
import 'package:studygram/utils/text_strings.dart';
import 'package:studygram/utils/widget_functions.dart';

bool isLoading = false;

class UserSignUpPage extends StatefulWidget {
  const UserSignUpPage({super.key});
  @override
  State<UserSignUpPage> createState() => _UserSignUpPageState();
}

// TextEditingController nameController = TextEditingController(text: '');
// TextEditingController emailController = TextEditingController(text: '');
// TextEditingController pswdController = TextEditingController(text: '');

UserSignUpModel users = UserSignUpModel('', '', '', '', '', '');

class _UserSignUpPageState extends State<UserSignUpPage> {
  Future signup_save(BuildContext context) async {
    // print({users.name, users.email, users.pswd});
    // final response = await http.post(
    //     Uri.parse(
    //       "${apidomain}auths/signup",
    //     ),
    //     headers: <String, String>{
    //       'Context-Type': 'application/json; charset=UTF-8',
    //     },
    //     body: <String, String>{
    //       'name': users.name,
    //       'email': users.email,
    //       'pswd': users.pswd,
    //       'phone': "",
    //       'location': "",
    //       'pincode': "",
    //     });

    // Color? msgclr;
    // String? msg;
    // String? msgdesc;
    // var str;

    // if (response.statusCode == 201) {
    //   var jsonData = jsonDecode(response.body);
    //   str = jsonData[0]["id"];

    //   msgclr = Colors.green[400];
    //   msg = "Signup Success";
    //   msgdesc = "User Signed Successfully";
    // } else {
    //   msgclr = Colors.red[400];
    //   msg = "Signup Failed";
    //   msgdesc = "Email already in use";
    //   setState(() {
    //     isLoading = false;
    //   });
    // }

    // Get.snackbar(
    //   msg,
    //   msgdesc,
    //   icon: const Icon(Icons.person, color: Colors.white),
    //   snackPosition: SnackPosition.BOTTOM,
    //   backgroundColor: msgclr,
    //   borderRadius: 12,
    //   margin: const EdgeInsets.all(15),
    //   colorText: Colors.white,
    //   duration: const Duration(seconds: 3),
    //   isDismissible: true,
    //   dismissDirection: DismissDirection.horizontal,
    //   forwardAnimationCurve: Curves.bounceIn,
    // );

    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString("name", users.name);

    Get.to(() => Community(title: "title"));
    // Get.offAll(() => {UserExithome()});
    // Navigator.of(context).pushReplacement(MaterialPageRoute(
    //     builder: (BuildContext context) => const UserExithome()));
  }

  // String _currentAddress = "";
  // String _pinCode = "";
  // Position? _currentPosition;

  // Future<bool> _handleLocationPermission() async {
  //   bool serviceEnabled;
  //   LocationPermission permission;

  //   serviceEnabled = await Geolocator.isLocationServiceEnabled();
  //   if (!serviceEnabled) {
  //     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
  //         content: Text(
  //             'Location services are disabled. Please enable the services')));
  //     return false;
  //   }
  //   permission = await Geolocator.checkPermission();
  //   if (permission == LocationPermission.denied) {
  //     permission = await Geolocator.requestPermission();
  //     if (permission == LocationPermission.denied) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //           const SnackBar(content: Text('Location permissions are denied')));
  //       return false;
  //     }
  //   }
  //   if (permission == LocationPermission.deniedForever) {
  //     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
  //         content: Text(
  //             'Location permissions are permanently denied, we cannot request permissions.')));
  //     return false;
  //   }
  //   return true;
  // }

  // Future<void> _getCurrentPosition() async {
  //   final hasPermission = await _handleLocationPermission();

  //   if (!hasPermission) return;
  //   await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
  //       .then((Position position) {
  //     setState(() => _currentPosition = position);
  //     _getAddressFromLatLng(_currentPosition!);
  //   }).catchError((e) {
  //     debugPrint(e);
  //   });
  // }

  // Future<void> _getAddressFromLatLng(Position position) async {
  //   await placemarkFromCoordinates(
  //           _currentPosition!.latitude, _currentPosition!.longitude)
  //       .then((List<Placemark> placemarks) {
  //     Placemark place = placemarks[0];
  //     // print(place.country);
  //     setState(() {
  //       _pinCode = '${place.postalCode}';
  //       _currentAddress =
  //           '${place.administrativeArea}, ${place.locality}, ${place.thoroughfare}, ${place.postalCode}';
  //     });
  //     // print(_currentAddress);
  //     users.location = _currentAddress;
  //   }).catchError((e) {
  //     debugPrint(e);
  //   });
  // }

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(tDefaultSize),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.fromLTRB(0, 80.0, 0.0, 0.0),
                    child: Center(
                      child: Text(
                        tSignUp,
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                  padding:
                      const EdgeInsets.only(top: 35.0, left: 20.0, right: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      TextFormField(
                        initialValue: "",
                        // //controller: nameController,
                        onChanged: (val) {
                          users.name = val;
                        },
                        decoration: const InputDecoration(
                            labelText: 'Name ',
                            labelStyle: TextStyle(
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.bold,
                                color: Colors.grey),
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.green))),
                      ),
                      const SizedBox(height: 10.0),
                      // TextFormField(
                      //   keyboardType: TextInputType.emailAddress,
                      //   autovalidateMode: AutovalidateMode.onUserInteraction,
                      //   validator: (value) {
                      //     // Check if the entered text is a valid email address using a regex pattern
                      //     if (value!.isEmpty ||
                      //         !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                      //             .hasMatch(value)) {
                      //       return 'Please enter a valid email address';
                      //     }
                      //     return null;
                      //   },
                      //   // //controller: emailController,
                      //   onChanged: (val) {
                      //     users.email = val;
                      //   },
                      //   decoration: const InputDecoration(
                      //       labelText: 'Email',
                      //       labelStyle: TextStyle(
                      //           fontFamily: 'Montserrat',
                      //           fontWeight: FontWeight.bold,
                      //           color: Colors.grey),
                      //       // hintText: 'EMAIL',
                      //       // hintStyle: ,
                      //       focusedBorder: UnderlineInputBorder(
                      //           borderSide: BorderSide(color: Colors.green))),
                      // ),
                      // TextField(
                      //   // //controller: emailController,
                      //   onChanged: (val) {
                      //     users.phone = val;
                      //   },
                      //   keyboardType: TextInputType.number,
                      //   decoration: const InputDecoration(
                      //       labelText: 'Phone Number',
                      //       labelStyle: TextStyle(
                      //           fontFamily: 'Montserrat',
                      //           fontWeight: FontWeight.bold,
                      //           color: Colors.grey),
                      //       // hintText: 'EMAIL',
                      //       // hintStyle: ,
                      //       focusedBorder: UnderlineInputBorder(
                      //           borderSide: BorderSide(color: Colors.green))),
                      // ),
                      //          Container(
                      //   height: 80,
                      //   padding: const EdgeInsets.symmetric(vertical: 12.0),
                      //   clipBehavior: Clip.antiAlias,
                      //   decoration: BoxDecoration(
                      //     borderRadius: BorderRadius.circular(22),
                      //   ),
                      //   child: TextFormField(
                      //     // //controller: locationController,
                      //     // initialValue: widget.location,
                      //     onChanged: (val) {
                      //       users.location = val;
                      //     },
                      //     decoration: const InputDecoration(
                      //       labelText: 'Location',
                      //       labelStyle: TextStyle(
                      //         fontSize: 14,
                      //         fontFamily: 'Montserrat',
                      //         fontWeight: FontWeight.bold,
                      //         color: Colors.grey,
                      //       ),
                      //       // hintText: 'myshop..',
                      //     ),
                      //   ),
                      // ),
                      // TextFormField(
                      //   // //controller: emailController,
                      //   // initialValue: users.location,
                      //   onChanged: (val) {
                      //     users.location = val;
                      //   },
                      //   decoration: const InputDecoration(
                      //       labelText: 'Address',
                      //       labelStyle: TextStyle(
                      //           fontFamily: 'Montserrat',
                      //           fontWeight: FontWeight.bold,
                      //           color: Colors.grey),
                      //       // hintText: 'EMAIL',
                      //       // hintStyle: ,
                      //       focusedBorder: UnderlineInputBorder(
                      //           borderSide: BorderSide(color: Colors.green))),
                      // ),
                      // TextFormField(
                      //   // //controller: emailController,
                      //   // initialValue: users.location,
                      //   onChanged: (val) {
                      //     users.pincode = val;
                      //   },
                      //   keyboardType: TextInputType.number,
                      //   decoration: const InputDecoration(
                      //       labelText: 'Pincode',
                      //       labelStyle: TextStyle(
                      //           fontFamily: 'Montserrat',
                      //           fontWeight: FontWeight.bold,
                      //           color: Colors.grey),
                      //       // hintText: 'EMAIL',
                      //       // hintStyle: ,
                      //       focusedBorder: UnderlineInputBorder(
                      //           borderSide: BorderSide(color: Colors.green))),
                      // ),
                      // const SizedBox(height: 10.0),
                      // TextField(
                      //   // //controller: pswdController,
                      //   onChanged: (val) {
                      //     users.pswd = val;
                      //   },
                      //   decoration: const InputDecoration(
                      //       labelText: 'Password',
                      //       labelStyle: TextStyle(
                      //           fontFamily: 'Montserrat',
                      //           fontWeight: FontWeight.bold,
                      //           color: Colors.grey),
                      //       focusedBorder: UnderlineInputBorder(
                      //           borderSide: BorderSide(color: Colors.green))),
                      //   // //obscureText: true,
                      // ),
                      // const Padding(
                      //   padding: EdgeInsets.only(top:24.0),
                      //   child: Text("Sign Up Failed. Try Again!",style: TextStyle(color: Colors.red,fontWeight: FontWeight.w500),),
                      // ),
                      addVerticalSpace(30),
                      // ignore: sized_box_for_whitespace
                      Container(
                          height: 40.0,
                          child: Material(
                            borderRadius: BorderRadius.circular(20.0),
                            shadowColor: Colors.greenAccent,
                            color: ColorConstants.green,
                            elevation: 7.0,
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  isLoading = true;
                                });
                                // print("saved");
                                // if (users.email.isEmpty ||
                                //     !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                                //         .hasMatch(users.email)) {
                                //   Get.snackbar(
                                //     "Invalid Email",
                                //     "Enter Valid Email Address",
                                //     icon: const Icon(Icons.person,
                                //         color: Colors.white),
                                //     snackPosition: SnackPosition.BOTTOM,
                                //     backgroundColor: Colors.red,
                                //     borderRadius: 12,
                                //     margin: const EdgeInsets.all(15),
                                //     colorText: Colors.white,
                                //     duration: const Duration(seconds: 3),
                                //     isDismissible: true,
                                //     dismissDirection:
                                //         DismissDirection.horizontal,
                                //     forwardAnimationCurve: Curves.bounceIn,
                                //   );
                                //   setState(() {
                                //     isLoading = false;
                                //   });
                                // } else if (users.name.isEmpty ||
                                //         users.pswd.isEmpty ||
                                //         users.phone.isEmpty
                                //     // users.location.isEmpty ||
                                //     // users.pincode.isEmpty
                                //     ) {
                                //   Get.snackbar(
                                //     "Fill Every Field",
                                //     "Fill every fields to continue",
                                //     icon: const Icon(Icons.person,
                                //         color: Colors.white),
                                //     snackPosition: SnackPosition.BOTTOM,
                                //     backgroundColor: Colors.red,
                                //     borderRadius: 12,
                                //     margin: const EdgeInsets.all(15),
                                //     colorText: Colors.white,
                                //     duration: const Duration(seconds: 3),
                                //     isDismissible: true,
                                //     dismissDirection:
                                //         DismissDirection.horizontal,
                                //     forwardAnimationCurve: Curves.bounceIn,
                                //   );
                                //   setState(() {
                                //     isLoading = false;
                                //   });
                                // } else {
                                signup_save(context);
                                // }
                              },
                              child: isLoading
                                  ? const Center(
                                      child: SizedBox(
                                        height: 15,
                                        width: 15,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 3,
                                          color: Colors.white,
                                        ),
                                      ),
                                    )
                                  : const Center(
                                      child: Text(
                                        tSignUp,
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 15),
                                      ),
                                    ),
                            ),
                          )),
                      addVerticalSpace(20),
                    ],
                  )),
              const SizedBox(height: 15.0),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: <Widget>[
              //     const Text(
              //       tLoginQuestion,
              //     ),
              //     TextButton(
              //       child: Text(tLogin,
              //           style: TextStyle(
              //             color: ColorConstants.green,
              //             fontWeight: FontWeight.bold,
              //             decoration: TextDecoration.underline,
              //           )),
              //       onPressed: () => Get.to(() => const UserLoginPage()),
              //     )
              //   ],
              // )
            ],
          ),
        ),
      ),
    );
  }
}
