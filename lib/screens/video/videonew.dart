import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:studygram/screens/video/video.dart';
import 'package:studygram/utils/constants.dart';
import 'package:studygram/utils/widget_functions.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:http/http.dart' as http;

class VideoPageNew extends StatefulWidget {
  VideoPageNew({Key? key}) : super(key: key);

  @override
  State<VideoPageNew> createState() => _VideoPageNewState();
}

class _VideoPageNewState extends State<VideoPageNew> {
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

  var videoData = Get.arguments;
  late String myVideoId = videoData['link'];

  late YoutubePlayerController _controller = YoutubePlayerController(
    initialVideoId: myVideoId,
    flags: const YoutubePlayerFlags(
      autoPlay: true,
      mute: false,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(videoData['title']),
          elevation: 0,
        ),
        body: Column(
          children: [
            YoutubePlayer(
              showVideoProgressIndicator: true,
              topActions: <Widget>[
                const SizedBox(width: 8.0),
                Expanded(
                  child: Text(
                    _controller.metadata.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.settings,
                    color: Colors.white,
                    size: 25.0,
                  ),
                  onPressed: () {
                    // log('Settings Tapped!');
                  },
                ),
              ],
              controller: _controller,
              liveUIColor: Colors.green,
            ),
            // Container(
            //   padding: EdgeInsets.symmetric(horizontal: 10),
            //   child: ListView(
            //     shrinkWrap: true,
            //     children: [
            //       Center(
            //         child: Container(
            //           decoration: BoxDecoration(
            //               color: MyTheme.grey.withOpacity(0.5),
            //               borderRadius: const BorderRadius.vertical(
            //                   top: Radius.circular(1.0))),
            //           height: 4,
            //           width: 48,
            //         ),
            //       ),
            //       MyTheme.mediumVerticalPadding,
            //       Text(videoData['title'],
            //           style: TextStyle(
            //               fontSize: 20, fontWeight: FontWeight.bold)),
            //       addVerticalSpace(10),
            //       Text("${videoData['subject']}",
            //           style: TextStyle(fontSize: 16, color: MyTheme.grey)),
            //       // MyContentWidget()
            //     ],
            //   ),
            // ),
            Expanded(
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
                        left: 0,
                        right: 0,
                        top: 12,
                      ),
                      child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                        itemCount: videos.length,
                        // itemCount: snapshot.data.length,
                        itemBuilder: (context, i) {
                          var ytid = YoutubePlayer.convertUrlToId(
                              videos[i]['videolink']);
                          return TextButton(
                            onPressed: () async {
                              var link = YoutubePlayer.convertUrlToId(
                                  videos[i]['videolink']);
                              Get.off(() => VideoPage(), arguments: {
                                "link": link,
                                "title": videos[i]['videoname'],
                                "subject": argumentData['subject'],
                                'university': argumentData['university'],
                                'course': argumentData['course'],
                                'semester': argumentData['semester'],
                                'category': argumentData['category'],
                              });
                            },
                            child: Container(
                              margin: const EdgeInsets.only(
                                left: 3,
                                right: 3,
                              ),
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
                                    child: Image(
                                      // height: 120,
                                      fit: BoxFit.cover,
                                      image: NetworkImage(
                                        "https://i3.ytimg.com/vi/${ytid}/hqdefault.jpg",
                                      ),
                                    ),
                                  ),
                                ),
                                title: Text(
                                  videos[i]['videoname'],
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                  ),
                                ),
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
                                            // child: SizedBox(width: 4, height: 4),
                                            // ),
                                            ),
                                        Text("${argumentData['subject']}"),
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
            )
          ],
        ));
  }
}

class MyTheme {
  static Color get backgroundColor => const Color(0xFFF7F7F7);
  static Color get grey => const Color(0xFF999999);
  static Color get catalogueCardColor =>
      const Color(0xFFBAE5D4).withOpacity(0.5);
  static Color get catalogueButtonColor => const Color(0xFF29335C);
  static Color get courseCardColor => const Color(0xFFEDF1F1);
  static Color get progressColor => const Color(0xFF36F1CD);

  static Padding get largeVerticalPadding =>
      const Padding(padding: EdgeInsets.only(top: 32.0));

  static Padding get mediumVerticalPadding =>
      const Padding(padding: EdgeInsets.only(top: 16.0));

  static Padding get smallVerticalPadding =>
      const Padding(padding: EdgeInsets.only(top: 8.0));

  static ThemeData get theme => ThemeData(
        fontFamily: 'Poppins',
        primarySwatch: Colors.blueGrey,
      ).copyWith(
        cardTheme: const CardTheme(
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(16.0)))),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            elevation: MaterialStateProperty.all(0.0),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            backgroundColor: MaterialStateProperty.all<Color>(
                catalogueButtonColor), // Button color
            foregroundColor: MaterialStateProperty.all<Color>(
                Colors.white), // Text and icon color
          ),
        ),
      );
}

// class MyContentWidget extends StatefulWidget {
//   MyContentWidget();

//   @override
//   _MyContentWidgetState createState() => _MyContentWidgetState();
// }

// class _MyContentWidgetState extends State<MyContentWidget> {
//   var argumentData = Get.arguments;
//   Future<List<Map<String, dynamic>>> fetchCourses() async {
//     final response = await http.get(Uri.parse(
//         '${apidomain}video/${argumentData['university']}/${argumentData['course']}/${argumentData['semester']}/${argumentData['subject']}/all-module'));
//     print(
//         '${apidomain}video/${argumentData['university']}/${argumentData['course']}/${argumentData['semester']}/${argumentData['subject']}/all-module');
//     if (response.statusCode == 200) {
//       final List<dynamic> data = json.decode(response.body);
//       List<Map<String, dynamic>> videos = data
//           .map((item) => {
//                 '_id': item['_id'],
//                 'videoname': item['videoname'],
//                 'fvideoname': item['fvideoname'],
//                 'videolink': item['videolink']
//               })
//           .toList();
//       return videos;
//     } else {
//       throw Exception('Failed to fetch videos');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     // Use widget.data to render the dynamic content
//     return Container(
//       color: Colors.white,
//       child: FutureBuilder<List<Map<String, dynamic>>>(
//         future: fetchCourses(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(
//               child: SpinKitCircle(
//                 size: 80,
//                 color: Colors.green,
//               ),
//             );
//           } else if (snapshot.hasError) {
//             return Text('Error: ${snapshot.error}');
//           } else if (snapshot.hasData) {
//             List<Map<String, dynamic>> videos = snapshot.data!;
//             if (videos.isEmpty) {
//               return const Center(child: Text('No Video Available.'));
//             }
//             return Container(
//               padding: const EdgeInsets.only(
//                 left: 12,
//                 right: 12,
//                 top: 12,
//               ),
//               child: ListView.builder(
//                 scrollDirection: Axis.vertical,
//                 shrinkWrap: true,
//                 physics: const BouncingScrollPhysics(),
//                 itemCount: videos.length,
//                 // itemCount: snapshot.data.length,
//                 itemBuilder: (context, i) {
//                   return TextButton(
//                     onPressed: () async {
//                       var link =
//                           YoutubePlayer.convertUrlToId(videos[i]['videolink']);
//                       Get.to(VideoPage(), arguments: {
//                         "link": link,
//                         "title": videos[i]['videoname'],
//                         "subject": argumentData['subject']
//                       });
//                     },
//                     child: Container(
//                       margin: const EdgeInsets.only(
//                         left: 3,
//                         right: 3,
//                       ),
//                       decoration: BoxDecoration(
//                           color: Colors.white30,
//                           borderRadius: BorderRadius.circular(10),
//                           boxShadow: const [
//                             // Shadow for top-left corner
//                             BoxShadow(
//                               color: Colors.grey,
//                               offset: Offset(1, 1),
//                               blurRadius: 2,
//                               spreadRadius: 0.3,
//                             ),
//                             // Shadow for bottom-right corner
//                             BoxShadow(
//                               color: Colors.white,
//                               offset: Offset(-1, -1),
//                               blurRadius: 1,
//                               spreadRadius: 3,
//                             ),
//                           ]),
//                       child: ListTile(
//                         contentPadding: const EdgeInsets.all(5),
//                         leading: ClipRRect(
//                           borderRadius: BorderRadius.circular(8),
//                           child: Container(
//                             width: 80,
//                             // height: 120,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(12),
//                             ),
//                             child: const Image(
//                               // height: 120,
//                               fit: BoxFit.cover,
//                               image: NetworkImage(
//                                 "https://placehold.co/600x400/png",
//                               ),
//                             ),
//                           ),
//                         ),
//                         title: Text(videos[i]['videoname']),
//                         subtitle: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             addVerticalSpace(10),
//                             Row(
//                               children: [
//                                 // const Icon(Icons.favorite,
//                                 //     color: Colors.orange, size: 20),
//                                 // const SizedBox(width: 3),
//                                 // const Text("5"),
//                                 Container(
//                                     // decoration: const BoxDecoration(
//                                     //   shape: BoxShape.circle,
//                                     //   color: Colors.grey,
//                                     // ),
//                                     // child: const Padding(
//                                     // padding:
//                                     //     EdgeInsets.symmetric(horizontal: 20),
//                                     // child: SizedBox(width: 4, height: 4),
//                                     // ),
//                                     ),
//                                 Text("${argumentData['subject']}"),
//                               ],
//                             ),
//                           ],
//                         ),
//                         // trailing: LikeButton(
//                         //     onPressed: () {}, color: Colors.orange),
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             );
//           } else {
//             return const Center(
//                 child: Text(
//               'No Content is available right now',
//               style: TextStyle(
//                 fontWeight: FontWeight.w800,
//               ),
//             ));
//           }
//         },
//       ),
//     );
//   }
// }
