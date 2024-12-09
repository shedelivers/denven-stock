import 'package:denvin_stock/components/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'common_widget.dart';


class CommonWebViewScreen extends StatefulWidget {
  final String url, title;
  const CommonWebViewScreen({super.key, required this.url, required this.title});

  @override
  State<CommonWebViewScreen> createState() => _CommonWebViewScreenState();
}

class _CommonWebViewScreenState extends State<CommonWebViewScreen> {

  final WebViewController controller = WebViewController();
  bool loading = true;

  @override
  void initState() {

      controller
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setBackgroundColor(const Color(0x00000000))
        ..setNavigationDelegate(
          NavigationDelegate(
            onProgress: (int progress) {debugPrint('Loading progress : $progress%');},
            onPageStarted: (String url) {debugPrint('Page started loading: $url');},
            onPageFinished: (String url) {
              loading = false;
              setState(() {});
              debugPrint('Page finished loading: $url');
            },
            onWebResourceError: (WebResourceError error) {
              debugPrint(
                  "Page resource error: code: ${error.errorCode}\n"
                      "description: ${error.description}\n"
                      "errorType: ${error.errorType}\n"
                      "isForMainFrame: ${error.isForMainFrame}");
            },
            onNavigationRequest: (NavigationRequest request) {
              debugPrint('allowing navigation to ${request.url}');
              return NavigationDecision.navigate;
            },
            onHttpError: (HttpResponseError error) {
              debugPrint('Error occurred on page: ${error.response?.statusCode}');
            },
            onUrlChange: (UrlChange change) {
              debugPrint('url change to ${change.url}');
            },
            onHttpAuthRequest: (HttpAuthRequest request) {debugPrint('url change to ${request.host}');},
          ),
        )
        ..loadRequest(Uri.parse(widget.url));


    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: myAppBar(centerLogo: true, showBack: true, showLogo: false, title: widget.title, ),

      body: loading?Utils.circularLoader():
      WebViewWidget(controller: controller),
    );
  }
}
