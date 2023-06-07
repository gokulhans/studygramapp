import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:studygram/utils/color_constants.dart';

class LoadingIndicator extends StatelessWidget {
  var progress;
  LoadingIndicator({super.key, required this.progress});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      color: ColorConstants.appbgclr,
      child: Center(
        child: Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: ListView.builder(
            itemCount: 10,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                width: double.infinity,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(12),
                ),
              );
            },
          ),
        ),
      ),
    );
    // return Container(
    //   decoration: BoxDecoration(
    //     boxShadow: [
    //       BoxShadow(
    //         color: Colors.blue.withOpacity(0.3),
    //         spreadRadius: 1.0,
    //         blurRadius: 3.0,
    //         offset: Offset(0, 2),
    //       ),
    //     ],
    //   ),
    //   child: LinearProgressIndicator(
    //     backgroundColor: Colors.grey[200],
    //     valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
    //     value: progress,
    //     minHeight: 2.0,
    //   ),
    // );
  }
}
