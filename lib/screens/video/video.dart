import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:studygram/utils/widget_functions.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:http/http.dart' as http;

class VideoPage extends StatelessWidget {
  static String myVideoId = '8gMt9QYX8aI';
  final YoutubePlayerController _controller = YoutubePlayerController(
    initialVideoId: myVideoId,
    flags: const YoutubePlayerFlags(
      autoPlay: true,
      mute: false,
    ),
  );

  VideoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Complex Theory'),
        elevation: 0,
      ),
      body: Stack(
        children: [
          Column(children: [
            Expanded(
                flex: 35,
                child: YoutubePlayer(
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
                )),
            const Spacer(
              flex: 65,
            )
          ]),
          DraggableScrollableSheet(
            initialChildSize: 0.65,
            minChildSize: 0.65,
            builder: (BuildContext context, ScrollController scrollController) {
              return Container(
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(32.0))),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ListView(
                    controller: scrollController,
                    children: [
                      Center(
                        child: Container(
                          decoration: BoxDecoration(
                              color: MyTheme.grey.withOpacity(0.5),
                              borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(1.0))),
                          height: 4,
                          width: 48,
                        ),
                      ),
                      MyTheme.mediumVerticalPadding,
                      const Text("Complex Theory Explanation Part 1",
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold)),
                      addVerticalSpace(10),
                      Text("course by nss college panthalam",
                          style: TextStyle(fontSize: 16, color: MyTheme.grey)),
                      MyTheme.largeVerticalPadding,
                      // Row(
                      //   children: [
                      //     const Text("199 ",
                      //         style: TextStyle(
                      //             fontSize: 22, fontWeight: FontWeight.bold)),
                      //     Expanded(
                      //       child: Column(
                      //         children: [
                      //           const Text("Progress: 100%"),
                      //           Container(
                      //             margin: const EdgeInsets.fromLTRB(
                      //                 32.0, 4.0, 32.0, 8.0),
                      //             height: 10,
                      //             child: const ClipRRect(
                      //               borderRadius:
                      //                   BorderRadius.all(Radius.circular(10)),
                      //               child: LinearProgressIndicator(
                      //                 value: 1,
                      //                 valueColor: AlwaysStoppedAnimation<Color>(
                      //                     Colors.green),
                      //               ),
                      //             ),
                      //           )
                      //         ],
                      //       ),
                      //     )
                      //   ],
                      // ),
                      MyTheme.mediumVerticalPadding,
                      Text(
                        "Learn the basics of lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.",
                        style: GoogleFonts.poppins(
                          fontSize: 17,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      MyTheme.mediumVerticalPadding,
//                       Row(
//                         children: [
//                           Expanded(
//                             child: Html(
//                               data: """<!doctype html>
// <html>
// <head>
//   <meta charset="UTF-8">
//   <meta name="viewport" content="width=device-width, initial-scale=1.0">
//   <script src="https://cdn.tailwindcss.com"></script>
// </head>
// <body>
//   <h1 class="text-3xl font-bold underline">
//     Hello world!
//   </h1>
// </body>
// </html>""",
//                               style: {
//                                 'body': Style(
//                                   margin: EdgeInsets.all(8),
//                                   fontSize: FontSize.medium,
//                                   fontFamily: 'Helvetica',
//                                 ),
//                               },
//                             ),
//                           ),
//                         ],
//                       )
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

// class YoutubePlayerPage extends StatefulWidget {
//   const YoutubePlayerPage({Key? key}) : super(key: key);

//   @override
//   _YoutubePlayerPageState createState() => _YoutubePlayerPageState();
// }

// class _YoutubePlayerPageState extends State<YoutubePlayerPage> {
//   late YoutubePlayerController _controller;
//   final List<String> _qualityOptions = ['1080p', '720p', '480p', '360p'];
//   String _selectedQuality = '1080p';

//   @override
//   void initState() {
//     super.initState();
//     _controller = YoutubePlayerController(
//       initialVideoId: 'ENTER_YOUTUBE_VIDEO_ID_HERE',
//       flags: const YoutubePlayerFlags(
//         autoPlay: true,
//         mute: false,
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Youtube Player'),
//         actions: [
//           DropdownButton<String>(
//             value: _selectedQuality,
//             items: _qualityOptions.map((String quality) {
//               return DropdownMenuItem<String>(
//                 value: quality,
//                 child: Text(quality),
//               );
//             }).toList(),
//             onChanged: (String? value) {
//               setState(() {
//                 _selectedQuality = value!;
//               });
//               // _controller.setPlaybackQuality(_selectedQuality);
//             },
//           ),
//           const SizedBox(width: 8),
//         ],
//       ),
//       body: YoutubePlayer(
//         controller: _controller,
//         showVideoProgressIndicator: true,
//         progressIndicatorColor: Colors.red,
//       ),
//     );
//   }
// }

// class CourseScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return
//   }
// }

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
