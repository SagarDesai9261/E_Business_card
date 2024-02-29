// import 'dart:io';
//
// import 'dart:async';
//
// import 'package:flutter/material.dart';
//
// import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
// import '../screens/main_screen.dart';
//
// // import 'package:webview_flutter/webview_flutter.dart';
// const kAndroidUserAgent =
//     'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/62.0.3202.94 Mobile Safari/537.36';
// final Set<JavascriptChannel> jsChannels = [
//   JavascriptChannel(
//       name: 'Print',
//       onMessageReceived: (JavascriptMessage message) {
//         print(message.message);
//       }),
// ].toSet();
//
// class WebViewWidget extends StatefulWidget {
//   final webViewUrl;
//
//   WebViewWidget({this.webViewUrl});
//
//   @override
//   WebViewWidgetState createState() => WebViewWidgetState();
// }
//
// class WebViewWidgetState extends State<WebViewWidget> {
//   // WebViewController _webViewController;
//   final flutterWebViewPlugin = FlutterWebviewPlugin();
//
//   @override
//   void initState() {
//     super.initState();
//     flutterWebViewPlugin.launch(widget.webViewUrl);
//     flutterWebViewPlugin.onUrlChanged.listen((String url) {
//       print("Url changed to: $url");
//       flutterWebViewPlugin.launch(url);
//     });
//     flutterWebViewPlugin.onStateChanged.listen((event) {
//       print("Url changed to: $event");
//       flutterWebViewPlugin.launch(event.url);
//     });
//
//
//     // Enable hybrid composition.
//     // if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     // return Scaffold(
//     //     appBar: AppBar(
//     //       titleSpacing: 0,
//     //       leading: InkWell(
//     //           onTap:()=>Navigator.of(context).pop(),
//     //           child: Icon(Icons.arrow_back_ios,color: Colors.black,size: 18,)
//     //       ),
//     //       title: Text(' ',style: Theme.of(context).textTheme.headline5.copyWith(
//     //           color: Colors.black,fontSize: 18
//     //       ),),
//     //     ),
//     //     body: WebView(
//     //       initialUrl: widget.webViewUrl,
//     //       key: Key("webview1"),
//     //       debuggingEnabled: true,
//     //       javascriptMode: JavascriptMode.unrestricted,
//     //       gestureNavigationEnabled: true,
//     //       allowsInlineMediaPlayback: true,
//     //       onWebViewCreated: (controller){
//     //         _webViewController=controller;
//     //       },
//     //     ),
//     // );
//     return WebviewScaffold(
//       url: widget.webViewUrl,
//       javascriptChannels: jsChannels,
//       mediaPlaybackRequiresUserGesture: true,
//       scrollBar: true,
//       useWideViewPort: true,
//       withOverviewMode: true,
//       allowFileURLs: true,
//       withJavascript: true,
//       // supportMultipleWindows: true,
//       appCacheEnabled: true,withLocalUrl: true,
//       appBar: AppBar(
//           titleSpacing: 0,
//           leading: InkWell(
//               onTap:(){
//                 setState(() {
//                   Navigator.of(context).pop();
//                 });
//                 flutterWebViewPlugin.dispose();
//                 Navigator.of(context).push(MaterialPageRoute(builder: (context)=>MainScreen()));
//               },
//               child: Icon(Icons.arrow_back_ios,color: Colors.black,size: 18,)
//           ),
//          title: Text(' ',style: Theme.of(context).textTheme.headline5.copyWith(
//           color: Colors.black,fontSize: 18
//           ),),
//        ),
//       withZoom: false,
//       withLocalStorage: true,
//       // hidden: true,
//       initialChild: Container(
//         // color: Color(0xFF3a8ac9),
//         child: Center(
//           child: CircularProgressIndicator(backgroundColor: Theme.of(context).primaryColorDark,),
//         ),
//       ),
//       bottomNavigationBar: BottomAppBar(
//         child: Row(
//           children: <Widget>[
//             IconButton(
//               icon: const Icon(Icons.arrow_back_ios),
//               onPressed: () {
//                 flutterWebViewPlugin.goBack();
//               },
//             ),
//             IconButton(
//               icon: const Icon(Icons.arrow_forward_ios),
//               onPressed: () {
//                 flutterWebViewPlugin.goForward();
//               },
//             ),
//             IconButton(
//               icon: const Icon(Icons.autorenew),
//               onPressed: () {
//                 flutterWebViewPlugin.reload();
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//
//   }
// }