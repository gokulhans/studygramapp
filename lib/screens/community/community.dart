import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:studygram/components/indicator/progress_indicator.dart';
import 'package:studygram/screens/auth/signup/signup.dart';
import 'package:studygram/utils/color_constants.dart';
import 'package:studygram/utils/constants.dart';

class CheckAuthCommunity extends StatefulWidget {
  const CheckAuthCommunity({super.key});

  @override
  State<CheckAuthCommunity> createState() => _CheckAuthCommunityState();
}

class _CheckAuthCommunityState extends State<CheckAuthCommunity> {
  late bool user = false;
  late String useruniversity = "university";
  late String username = "Guest";
  @override
  void initState() {
    super.initState();
    onload();
  }

  void onload() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool uservalue = await prefs.getBool('user')!;
    useruniversity = prefs.getString('universityname')!;
    useruniversity = prefs.getString('username')!;
    setState(() {
      user = uservalue;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (user) {
      print('called 1');
      return Community(
        name: username,
        university: useruniversity,
      );
    } else {
      print('called 2');
      return UserSignUpPage();
    }
  }
}

class Community extends StatefulWidget {
  var name;
  var university;
  Community({super.key, required this.name, required this.university});
  @override
  State<Community> createState() => _CommunityState();
}

class _CommunityState extends State<Community> {
  InAppWebViewController? webViewController;
  PullToRefreshController? pullToRefreshController;
  String url = "";
  String initialurl = "${apidomain2}community/Guest/community";
  double progress = 0;
  final urlController = TextEditingController();
  var isLoading = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      initialurl = "${apidomain2}community/${widget.name}/${widget.university}";
    });
    onload();
  }

  void onload() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var username = pref.getString('username')!;
    setState(() {
      initialurl = "${apidomain2}community/${username}";
    });
    pullToRefreshController = PullToRefreshController(
      options: PullToRefreshOptions(
          color: ColorConstants.textclr,
          backgroundColor: ColorConstants.appbgclr),
      onRefresh: () async {
        webViewController?.reload();
      },
    );
    // if (user!) {
    //   Get.to(() => Community(title: "title"));
    // } else {
    //   Get.to(() => UserSignUpPage());
    // }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        // appBar: AppBar(
        //   title: const Text('Select Subject'),
        //   systemOverlayStyle: const SystemUiOverlayStyle(
        //     statusBarColor: Colors.green,
        //     statusBarIconBrightness: Brightness.dark,
        //   ),
        // ),
        body: Stack(
          alignment: Alignment.topCenter,
          children: [
            InAppWebView(
                onWebViewCreated: (controller) {
                  webViewController = controller;
                },
                initialOptions: InAppWebViewGroupOptions(
                  android: AndroidInAppWebViewOptions(
                    geolocationEnabled: true,
                  ),
                ),
                onLoadStart: (controller, url) {
                  setState(() {
                    // this.url = url.toString();
                    // urlController.text = this.url;
                    isLoading = true;
                  });
                },
                onLoadStop: (controller, url) {
                  pullToRefreshController!.endRefreshing();
                  setState(() {
                    isLoading = false;
                  });
                },
                onProgressChanged: (controller, progress) {
                  if (progress == 100) {
                    pullToRefreshController?.endRefreshing();
                  }
                  setState(() {
                    this.progress = progress / 100;
                  });
                },
                pullToRefreshController: pullToRefreshController,
                initialUrlRequest: URLRequest(url: Uri.parse(initialurl))),
            // Visibility(
            //     visible: isLoading,
            //     child: CircularProgressIndicator(
            //       valueColor: AlwaysStoppedAnimation(ColorConstants.appbgclr2),
            //       backgroundColor: Colors.white,
            //     )),
            progress < 1.0
                ? LoadingIndicator(
                    progress: progress,
                  )
                : Container(),
          ],
        ),
      ),
    );
  }

  Future<bool> _onBackPressed() async {
    if (await webViewController!.canGoBack()) {
      webViewController!.goBack();
      return false;
    }
    return true;
    // return await showDialog(
    //   //show confirm dialogue
    //   //the return value will be from "Yes" or "No" options
    //   context: context,
    //   builder: (context) => AlertDialog(
    //     title: const Text('Exit App'),
    //     content: const Text(
    //       'Do you want to close ?',
    //       style: TextStyle(fontWeight: FontWeight.w600),
    //     ),
    //     actions: [
    //       ElevatedButton(
    //         onPressed: () => Navigator.of(context).pop(false),
    //         child: const Text('No'),
    //       ),
    //       ElevatedButton(
    //         onPressed: () => Navigator.of(context).pop(true),
    //         //return true when click on "Yes"
    //         child: const Text('Yes'),
    //       ),
    //     ],
    //   ),
    // );
  }
}
