// import 'package:pos_account/constant/constant.dart';
// import 'package:pos_account/widgets/loading.dart';
// import 'package:webview_flutter/webview_flutter.dart';
// import 'package:flutter/material.dart';

// class WebViewScreen extends StatefulWidget {
//   const WebViewScreen({
//     super.key,
//     required this.webContent,
//     this.onPageStart,
//     this.backgroundColor = Colors.transparent,
//     this.showBackButton = false,
//     this.onLoadUrl,
//     this.onError,
//   }) ;

//   final WebContent webContent;
//   final Function({
//     required String url,
//     WebViewController? webCltr,
//   })? onPageStart;

//   final Function({
//     WebViewController? webCltr,
//   })? onLoadUrl;

//   final Function({String? message})? onError;

//   final Color backgroundColor;
//   final bool showBackButton;

//   @override
//   State<WebViewScreen> createState() => _WebViewScreenState();
// }

// class _WebViewScreenState extends State<WebViewScreen> {
//   final scaffoldKey = GlobalKey<ScaffoldState>();

//   double opacity = 1;
//   bool pageLoadFinished = false;

//   load() {
//     if (mounted) setState(() {});
//   }

//   WebViewController? _controller;

//   Future<bool> goBack() async {
//     if (_controller != null && await _controller!.canGoBack()) {
//       _controller?.goBack();
//       return false;
//     } else {
//       // if (_controller != null) _controller!.clearCache();
//       return true;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: goBack,
//       child: Scaffold(
//         backgroundColor: widget.backgroundColor,
//         body: SafeArea(
//           child: Stack(
//             alignment: Alignment.center,
//             children: [
//               Opacity(
//                 opacity: pageLoadFinished ? 1 : 0,
//                 child: WebView(
//                   key: scaffoldKey,
//                   backgroundColor: widget.backgroundColor,
//                   initialUrl: widget.webContent.url,
//                   javascriptMode: JavascriptMode.unrestricted,
//                   gestureNavigationEnabled: true,
//                   debuggingEnabled: true,
//                   userAgent:
//                       "Mozilla/5.0 (Linux; Android 10; SM-G960U) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Mobile Safari/537.36",
//                   // ignore: prefer_collection_literals
//                   onProgress: (int i) {
//                     if (widget.onLoadUrl != null)
//                       widget.onLoadUrl!(webCltr: _controller);

//                     if (opacity == 0) return;

//                     opacity = (100 - i) / 100;
//                     if (i % 25 == 0) load();
//                   },
//                   onPageStarted: widget.onPageStart == null
//                       ? null
//                       : (url) {
//                           // opacity = 1;
//                           // load();
//                           widget.onPageStart!(
//                             url: url,
//                             webCltr: _controller,
//                           );
//                         },
//                   onPageFinished: (url) async {
//                     pageLoadFinished = true;
//                     load();
//                     // log("page finished $url");
//                   },
//                   onWebViewCreated: (controller) {
//                     _controller = controller;
//                   },
//                   onWebResourceError: (e) {
//                     if (widget.onError != null)
//                       widget.onError!(message: e.description);
//                   },
//                 ),
//               ),
//               if (opacity > 0)
//                 Container(
//                   height: 100,
//                   width: 100,
//                   decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(10)),
//                   child: Opacity(
//                     opacity: opacity,
//                     child: Loading(),
//                   ),
//                 ),
//               if (widget.showBackButton)
//                 Positioned(
//                   bottom: 10,
//                   left: 10,
//                   child: GestureDetector(
//                     onTap: () => goBack().then((value) {
//                       if (value) Navigator.pop(context);
//                     }),
//                     child: Opacity(
//                       opacity: 1 - opacity,
//                       child: Container(
//                         padding: EdgeInsets.all(16),
//                         decoration: BoxDecoration(
//                             shape: BoxShape.circle, color: kPrimaryColor),
//                         child: Icon(
//                           Icons.arrow_back_ios_new_outlined,
//                           color: Colors.white,
//                         ),
//                       ),
//                     ),
//                   ),
//                 )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class WebContent {
//   WebContent({
//     required this.title,
//     required this.url,
//   });

//   String title;
//   String url;

//   factory WebContent.fromJson(Map<String, dynamic> json) => WebContent(
//         title: json["title"],
//         url: json["url"],
//       );

//   Map<String, dynamic> toJson() => {
//         "title": title,
//         "url": url,
//       };
// }
