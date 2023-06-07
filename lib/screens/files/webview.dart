import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:studygram/components/indicator/progress_indicator.dart';
import 'package:studygram/utils/color_constants.dart';
import 'package:studygram/utils/constants.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewApp extends StatefulWidget {
  var link;
  WebViewApp({super.key, required this.link});

  @override
  State<WebViewApp> createState() => _WebViewAppState();
}

class _WebViewAppState extends State<WebViewApp> {
  InAppWebViewController? webViewController;
  PullToRefreshController? pullToRefreshController;
  String url = "";
  String initialurl =
      "https://res.cloudinary.com/gbrozdev/image/upload/v1683526006/product-images/g9eq1udtspoqkips41w9.pdf";
  double progress = 0;
  final urlController = TextEditingController();
  var isLoading = false;
  @override
  void initState() {
    super.initState();
    pullToRefreshController = PullToRefreshController(
      options: PullToRefreshOptions(
          color: ColorConstants.textclr,
          backgroundColor: ColorConstants.appbgclr),
      onRefresh: () async {
        webViewController?.reload();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        // appBar: AppBar(
        //   leading: IconButton(
        //     icon: Icon(Icons.refresh),
        //     onPressed: () {
        //       webViewController!.reload();
        //     },
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
                initialUrlRequest: URLRequest(url: Uri.parse(widget.link))),
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
  }
}
