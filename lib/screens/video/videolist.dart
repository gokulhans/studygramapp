import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:studygram/screens/category/category.dart';
import 'package:http/http.dart' as http;
import 'package:studygram/screens/files/webview.dart';
import 'package:studygram/screens/video/video.dart';
import 'package:studygram/utils/constants.dart';
import 'package:studygram/utils/widget_functions.dart';
import 'package:url_launcher/url_launcher.dart';

class Videolist extends StatelessWidget {
  const Videolist({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Video'),
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
  var argumentData = Get.arguments;
  Future<List<Map<String, dynamic>>> fetchCourses() async {
    final response = await http.get(Uri.parse(
        '${apidomain}video/${argumentData['university']}/${argumentData['course']}/${argumentData['semester']}/${argumentData['subject']}/all-module'));
    print(
        '${apidomain}video/${argumentData['university']}/${argumentData['course']}/${argumentData['semester']}/${argumentData['subject']}/all-module');
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      List<Map<String, dynamic>> videos = data
          .map((item) => {
                '_id': item['_id'],
                'videoname': item['videoname'],
                'fvideoname': item['fvideoname'],
                'videolink': item['videolink']
              })
          .toList();
      return videos;
    } else {
      throw Exception('Failed to fetch videos');
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
              List<Map<String, dynamic>> videos = snapshot.data!;
              if (videos.isEmpty) {
                return const Center(child: Text('No Video Available.'));
              }
              return Container(
                padding: const EdgeInsets.only(
                  left: 12,
                  right: 12,
                  top: 12,
                ),
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  itemCount: videos.length,
                  // itemCount: snapshot.data.length,
                  itemBuilder: (context, i) {
                    return TextButton(
                      onPressed: () async {
                        Get.to(VideoPage());
                      },
                      child: Container(
                        margin: const EdgeInsets.only(
                          left: 3,
                          right: 3,
                        ),
                        decoration: BoxDecoration(
                            color: Colors.white30,
                            borderRadius: BorderRadius.circular(10),
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
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(5),
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Container(
                              width: 80,
                              // height: 120,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Image(
                                // height: 120,
                                fit: BoxFit.cover,
                                image: NetworkImage(
                                  "https://placehold.co/600x400/png",
                                ),
                              ),
                            ),
                          ),
                          title: Text(videos[i]['videoname']),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              addVerticalSpace(10),
                              Row(
                                children: [
                                  // const Icon(Icons.favorite,
                                  //     color: Colors.orange, size: 20),
                                  // const SizedBox(width: 3),
                                  // const Text("5"),
                                  Container(
                                    // decoration: const BoxDecoration(
                                    //   shape: BoxShape.circle,
                                    //   color: Colors.grey,
                                    // ),
                                    // child: const Padding(
                                    // padding:
                                    //     EdgeInsets.symmetric(horizontal: 20),
                                    child: SizedBox(width: 4, height: 4),
                                    // ),
                                  ),
                                  const Text("By studygram"),
                                ],
                              ),
                            ],
                          ),
                          // trailing: LikeButton(
                          //     onPressed: () {}, color: Colors.orange),
                        ),
                      ),
                    );
                  },
                ),
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

// import 'dart:convert';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import 'package:flutter/material.dart';
// import 'package:studygram/screens/video/video.dart';
// import 'package:studygram/utils/widget_functions.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:youtube_player_flutter/youtube_player_flutter.dart';

// class Videolist extends StatelessWidget {
//   const Videolist({Key? key, required this.title}) : super(key: key);
//   final String title;
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // drawer: NavDrawer(),
//       appBar: AppBar(
//         title: const Text('Videos'),
//       ),
//       body: Videoscreen(
//         title: title,
//       ),
//     );
//   }
// }

// class Videoscreen extends StatelessWidget {
//   Videoscreen({Key? key, required this.title}) : super(key: key);
//   final String title;
//   var h = false;

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder(
//         // future: getVideos(title),
//         builder: (context, AsyncSnapshot snapshot) {
//       // if (snapshot.data == null) {
//       //   return const Center(
//       //     child: SpinKitCircle(
//       //       size: 80,
//       //       color: Colors.green,
//       //     ),
//       //   );
//       // } else {
//       //   if (snapshot.data.length == 0) {
//       //     return const Center(
//       //         child: Text(
//       //       'No Content is available right now.\nWe will Update it with in august 31.',
//       //       style: TextStyle(fontWeight: FontWeight.w800),
//       //     ));
//       //   } else {
//       return ListView.builder(
//           scrollDirection: Axis.vertical,
//           shrinkWrap: true,
//           physics: const BouncingScrollPhysics(),
//           itemCount: 10,
//           // itemCount: snapshot.data.length,
//           itemBuilder: (context, i) {
//             return TextButton(
//               onPressed: () async {
//                 Get.to(VideoPage());
//                 // admobHelper.createInterad();
//                 // if (snapshot.data[i].link.contains("http")) {
//                 //   var url = snapshot.data[i].link;
//                 //   if (await canLaunchUrl(Uri.parse(url))) {
//                 //     await launchUrl(Uri.parse(url),
//                 //         mode: LaunchMode.externalNonBrowserApplication);
//                 //     //  await launch(url,
//                 //     //   forceWebView: false, enableJavaScript: true);
//                 //   } else {
//                 //     throw 'Could not launch $url';
//                 //   }
//                 // } else {
//                 //   var url = 'https://youtu.be/' + snapshot.data[i].link;
//                 //   if (await canLaunchUrl(Uri.parse(url))) {
//                 //     await launchUrl(Uri.parse(url),
//                 //         mode: LaunchMode.externalNonBrowserApplication);
//                 //     //  await launch(url,
//                 //     //   forceWebView: false, enableJavaScript: true);
//                 //   } else {
//                 //     throw 'Could not launch $url';
//                 //   }
//                 // }
//               },
//               child: Container(
//                 margin: const EdgeInsets.only(
//                   left: 3,
//                   right: 3,
//                 ),
//                 decoration: BoxDecoration(
//                     color: Colors.white30,
//                     borderRadius: BorderRadius.circular(10),
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
//                 child: ListTile(
//                   contentPadding: const EdgeInsets.all(5),
//                   leading: ClipRRect(
//                     borderRadius: BorderRadius.circular(8),
//                     child: Container(
//                       width: 80,
//                       // height: 120,
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       child: const Image(
//                         // height: 120,
//                         image: NetworkImage(
//                           "https://www.tensionends.com/wp-content/uploads/2022/09/Beautiful-Girl-DP-Images-21.jpg",
//                         ),
//                         fit: BoxFit.cover,
//                       ),
//                     ),
//                   ),
//                   title: Text(title),
//                   subtitle: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       addVerticalSpace(10),
//                       Row(
//                         children: [
//                           const Icon(Icons.favorite,
//                               color: Colors.orange, size: 20),
//                           const SizedBox(width: 3),
//                           const Text("5"),
//                           Container(
//                             decoration: const BoxDecoration(
//                               shape: BoxShape.circle,
//                               color: Colors.grey,
//                             ),
//                             child: const Padding(
//                               padding: EdgeInsets.symmetric(horizontal: 20),
//                               child: SizedBox(width: 4, height: 4),
//                             ),
//                           ),
//                           const Text("By Nss College"),
//                         ],
//                       ),
//                     ],
//                   ),
//                   trailing: LikeButton(onPressed: () {}, color: Colors.orange),
//                 ),
//               ),
//             );
//           });
//       //   }
//       // }
//     });
//   }
// }

// class LikeListTile extends StatelessWidget {
//   const LikeListTile(
//       {Key? key,
//       required this.title,
//       required this.likes,
//       required this.subtitle,
//       required this.imgUrl,
//       this.color = Colors.grey})
//       : super(key: key);
//   final String title;
//   final String likes;
//   final String subtitle;
//   final Color color;
//   final String imgUrl;
//   @override
//   Widget build(BuildContext context) {
//     return ListTile(
//       contentPadding: const EdgeInsets.all(0),
//       leading: Container(
//         width: 50,
//         child: AspectRatio(
//           aspectRatio: 1,
//           child: Container(
//             decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 image: DecorationImage(
//                     fit: BoxFit.cover,
//                     image: NetworkImage(
//                       imgUrl,
//                     ))),
//           ),
//         ),
//       ),
//       title: Text(title),
//       subtitle: Row(
//         children: [
//           const Icon(Icons.favorite, color: Colors.orange, size: 20),
//           const SizedBox(
//             width: 3,
//           ),
//           Text(likes),
//           Container(
//               decoration: const BoxDecoration(
//                 shape: BoxShape.circle,
//                 color: Colors.grey,
//               ),
//               child: const Padding(
//                 padding: EdgeInsets.symmetric(horizontal: 20),
//                 child: SizedBox(width: 4, height: 4),
//               )),
//           Text(subtitle)
//         ],
//       ),
//       trailing: LikeButton(onPressed: () {}, color: Colors.orange),
//     );
//   }
// }

class LikeButton extends StatefulWidget {
  const LikeButton(
      {Key? key, required this.onPressed, this.color = Colors.black12})
      : super(key: key);
  final Function onPressed;
  final Color color;
  @override
  _LikeButtonState createState() => _LikeButtonState();
}

class _LikeButtonState extends State<LikeButton> {
  bool isLiked = false;

  @override
  Widget build(BuildContext context) {
    return Container(
        child: IconButton(
      icon: Icon(isLiked ? Icons.favorite : Icons.favorite_border,
          color: widget.color),
      onPressed: () {
        setState(() {
          isLiked = !isLiked;
        });
        widget.onPressed();
      },
    ));
  }
}
