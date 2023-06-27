import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:studygram/components/appbar/appbarmain.dart';
import 'package:studygram/main.dart';
import 'package:studygram/models/usermodel.dart';
import 'package:studygram/screens/auth/signup/signup.dart';
import 'package:studygram/utils/color_constants.dart';
import 'package:studygram/utils/constants.dart';
import 'package:studygram/utils/sizes.dart';
import 'package:studygram/utils/text_strings.dart';
import 'package:studygram/utils/widget_functions.dart';

bool isLoading = false;

class UserLoginPage extends StatefulWidget {
  const UserLoginPage({super.key});

  @override
  State<UserLoginPage> createState() => _UserLoginPageState();
}

TextEditingController nameController = TextEditingController(text: '');
TextEditingController emailController = TextEditingController(text: '');
TextEditingController pswdController = TextEditingController(text: '');

UserLoginModel users = UserLoginModel('', '');

class _UserLoginPageState extends State<UserLoginPage> {
  Future login_save(BuildContext context) async {
    // print({users.email, users.pswd});
    final response = await http.post(
        Uri.parse(
          "${apidomain2}auths/pro/login",
        ),
        headers: <String, String>{
          'Context-Type': 'application/json; charset=UTF-8',
        },
        body: <String, String>{
          'email': users.email,
          'pswd': users.pswd,
        });

    var jsonData = jsonDecode(response.body);
    Color? msgclr;
    String? msg;
    String? msgdesc;
    var str;
    if (response.statusCode == 201) {
      str = jsonData[0]["id"];
      msgclr = Colors.green[400];
      msg = "Login Success";
      msgdesc = "User Logined Successfully";
      SharedPreferences pref = await SharedPreferences.getInstance();
      await pref.setString('username', jsonData[0]["name"]);
      await pref.setString('userid', str);
      await pref.setBool('user', true);
      Get.snackbar(
        msg,
        msgdesc,
        icon: const Icon(Icons.person, color: Colors.white),
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
      setState(() {
        isLoading = false;
      });
      Get.offAll(() => MainPage());
    } else {
      msgclr = Colors.red[400];
      msg = "Login Failed";
      msgdesc = "Incorrect Email or Password";
      Get.snackbar(
        msg,
        msgdesc,
        icon: const Icon(Icons.person, color: Colors.white),
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
      setState(() {
        isLoading = false;
      });
    }

    // Get.to(() => {UserExitHome(currentIndex:0)});

    // Get.snackbar(
    //   "Login Successfull",
    //   "Logined",
    //   colorText: Colors.white,
    //   backgroundColor: Colors.lightgreen,
    //   icon: const Icon(Icons.add_alert),
    // );
    // Get.offAll(() => const UserExithome());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: const PreferredSize(
        //   preferredSize: Size.fromHeight(55),
        //   child: AppBarMain(),
        // ),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(tDefaultSize),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Stack(
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.fromLTRB(0, 80.0, 0.0, 0.0),
                        child: Center(
                          child: Text(
                            tLogin,
                            style: TextStyle(
                                fontSize: 30, fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                      padding: const EdgeInsets.only(
                          top: 35.0, left: 20.0, right: 20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const SizedBox(height: 10.0),
                          TextField(
                            // //controller: emailController,
                            onChanged: (val) {
                              users.email = val;
                            },
                            decoration: const InputDecoration(
                                labelText: 'Email',
                                labelStyle: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey),
                                // hintText: 'EMAIL',
                                // hintStyle: ,
                                focusedBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.green))),
                          ),
                          const SizedBox(height: 10.0),
                          TextField(
                            //controller: pswdController,
                            onChanged: (val) {
                              users.pswd = val;
                            },
                            decoration: const InputDecoration(
                                labelText: 'Password',
                                labelStyle: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey),
                                focusedBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.green))),
                            //obscureText: true,
                          ),
                          // const Padding(
                          //   padding: EdgeInsets.only(top: 24.0),
                          //   child: Text(
                          //     "Login Failed. Try Again!",
                          //     style: TextStyle(
                          //         color: Colors.red, fontWeight: FontWeight.w500),
                          //   ),
                          // ),
                          const SizedBox(height: 30.0),
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
                                    login_save(context);
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
                                            tLogin,
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                ),
                              )),
                          addVerticalSpace(20),
                        ],
                      )),
                  const SizedBox(height: 15.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Text(
                        tSignUpQuestion,
                      ),
                      TextButton(
                        child: Text(tSignUp,
                            style: TextStyle(
                              color: ColorConstants.green,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                            )),
                        onPressed: () => Get.to(() => const UserSignUpPage()),
                      )
                    ],
                  )
                ]),
          ),
        ));
  }
}
