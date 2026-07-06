import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/widgets/loading.dart';
import 'package:flutter/material.dart';

final CONSOLE_lOGS = <String>[];

class InAppWebViewScreen extends StatefulWidget {
  const InAppWebViewScreen({
    super.key,
    required this.webContent,
    this.onPageStart,
    this.transparentBackground = true,
    this.showBackButton = false,
    this.onLoadUrl,
    this.onError,
    this.directBackToApp = false,
  });

  final WebContent webContent;
  final Function({
    InAppWebViewController? webCltr,
  })? onPageStart;

  final Function({
    InAppWebViewController? webCltr,
  })? onLoadUrl;

  final Function({String? message})? onError;

  final bool transparentBackground;
  final bool showBackButton;
  final bool directBackToApp;

  @override
  State<InAppWebViewScreen> createState() => _InAppWebViewScreenState();
}

class _InAppWebViewScreenState extends State<InAppWebViewScreen> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  double opacity = 1;
  bool pageLoadFinished = false;

  load() {
    if (mounted) setState(() {});
  }

  InAppWebViewController? _controller;

  Future<bool> goBack() async {
    if (_controller != null && await _controller!.canGoBack()) {
      _controller?.goBack();
      return false;
    } else {
      // if (_controller != null) _controller!.clearCache();
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (val, res) => goBack(),
      child: Scaffold(
        backgroundColor: widget.transparentBackground
            ? Colors.transparent
            : kBackgroundColor,
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height,
              ),
              child: IntrinsicHeight(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Opacity(
                      opacity: pageLoadFinished ? 1 : 0,
                      child: InAppWebView(
                        key: scaffoldKey,
                        gestureRecognizers: widget.transparentBackground
                            ? null
                            : {Factory(() => EagerGestureRecognizer())},
                        initialSettings: InAppWebViewSettings(
                            useShouldOverrideUrlLoading: true,
                            javaScriptCanOpenWindowsAutomatically: true,
                            verticalScrollBarEnabled: true,
                            disableVerticalScroll: false,
                            cacheEnabled: false,
                            javaScriptEnabled: true,
                            transparentBackground: widget.transparentBackground,
                            allowContentAccess: true,
                            needInitialFocus: true,
                            useHybridComposition: true),
                        shouldOverrideUrlLoading: (controller, action) async {
                          return NavigationActionPolicy.ALLOW;
                        },

                        initialUrlRequest:
                            URLRequest(url: WebUri(widget.webContent.url)),

                        onProgressChanged: (cltr, int i) {
                          if (widget.onLoadUrl != null)
                            widget.onLoadUrl!(webCltr: _controller);

                          if (opacity == 0) return;

                          opacity = (100 - i) / 100;

                          if (i % 25 == 0) load();
                        },

                        onLoadStart: widget.onPageStart == null
                            ? null
                            : (cltr, a) {
                                // opacity = 1;
                                // load();
                                widget.onPageStart!(
                                  webCltr: _controller,
                                );
                              },

                        // onPageStarted: widget.onPageStart == null
                        //     ? null
                        //     : (url) {
                        //         // opacity = 1;
                        //         // load();
                        //         widget.onPageStart!(
                        //           url: url,
                        //           webCltr: _controller,
                        //         );
                        //       },

                        onLoadStop: (cltr, a) {
                          pageLoadFinished = true;
                          load();
                        },
                        // onPageFinished: (url) async {
                        //   pageLoadFinished = true;
                        //   load();
                        //   // log("page finished $url");
                        // },

                        onWebViewCreated: (cltr) {
                          _controller = cltr;
                        },

                        // onWebViewCreated: (controller) {
                        //   _controller = controller;
                        // },

                        onReceivedError: (controller, request, error) {
                          if (widget.onError != null)
                            widget.onError!(message: error.description);
                        },
                        onConsoleMessage: (a, b) {
                          // log("Console Message: ${b.message}");
                          CONSOLE_lOGS.add(b.message);
                        },
                        // onWebResourceError: (e) {
                        //   if (widget.onError != null)
                        //     widget.onError!(message: e.description);
                        // },
                      ),
                    ),
                    if (opacity > 0.1)
                      SizedBox(
                        height: 100,
                        width: 100,
                        child: Card(
                          child: Loading(),
                        ),
                      ),
                    if (widget.showBackButton)
                      Positioned(
                        bottom: 10,
                        left: 10,
                        child: GestureDetector(
                          onTap: () {
                            if (widget.directBackToApp)
                              Navigator.pop(context);
                            else
                              goBack().then((value) {
                                if (value) Navigator.pop(context);
                              });
                          },
                          child: Opacity(
                            opacity: 1 - opacity,
                            child: Container(
                              padding: EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle, color: kPrimaryColor),
                              child: Icon(
                                Icons.arrow_back_ios_new_outlined,
                                color: Colors.white,
                                size: 36,
                              ),
                            ),
                          ),
                        ),
                      )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class WebContent {
  WebContent({
    required this.title,
    required this.url,
  });

  String title;
  String url;

  factory WebContent.fromJson(Map<String, dynamic> json) => WebContent(
        title: json["title"],
        url: json["url"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "url": url,
      };
}
