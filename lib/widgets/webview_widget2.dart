import 'dart:async';
import 'dart:io';
import 'dart:isolate';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_downloader/flutter_downloader.dart';

import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
// import 'package:flutter_share_me/flutter_share_me.dart';

import '../screens/main_screen.dart';
ReceivePort _port = ReceivePort();

class WebViewWidget2 extends StatefulWidget {
  final webViewUrl;

  WebViewWidget2({this.webViewUrl});

  @override
  WebViewWidget2State createState() => WebViewWidget2State();
}

class WebViewWidget2State extends State<WebViewWidget2> {
  InAppWebViewController webView;
  var progress;

  void init_down()async {
    await Permission.storage.request();
    IsolateNameServer.registerPortWithName(
        _port.sendPort, 'downloader_send_port');
    _port.listen((dynamic data) {
      String id = data[0];
      DownloadTaskStatus status = data[1];
      int progress = data[2];
      // setState((){ });
    });
    FlutterDownloader.registerCallback(downloadCallback as DownloadCallback);
  }
  @override
  void initState() {
    super.initState();
      init_down();

  }

  @override
  void dispose() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
    super.dispose();
  }
  static void downloadCallback(String id, DownloadTaskStatus status, int progress) {
    final SendPort send = IsolateNameServer.lookupPortByName('downloader_send_port');
    send.send([id, status, progress]);
  }

  void downloadVCFFile(url)async
  {
    try{
        print("onDownloadStart ${url.toString()}");
        // print("onDownloadStart ${ (await getExternalStorageDirectory()).path}");
        print("onDownloadStart ${ (await getApplicationDocumentsDirectory()).path}");

        // _launchURL(url.toString());
        String fileName=url.toString().split('/').last.toString()+'-${DateTime.now()}.vcf';
        String filePath= (await getExternalStorageDirectory()).path.toString();
        final String taskId = await FlutterDownloader.enqueue(
        url: url.toString(),
        // url:"http://www.africau.edu/images/default/sample.pdf",
        headers: {
        'Content-Description':'File Transfer',
        'Content-Type': 'text/vcard',
        'Content-Transfer-Encoding': 'binary',
        'Expires': '0',
        'Cache-Control': 'must-revalidate, post-check=0, pre-check=0',
        'Pragma': 'public',
        // 'Content-Disposition': 'attachment; filename=${widget.fileName}',
        // 'Content-Length':'1056',
        },
        savedDir: Platform.isIOS?
        (await getExternalStorageDirectory()).path:(await getExternalStorageDirectory()).path,
        showNotification: true, // show download progress in status bar (for Android)
        openFileFromNotification: true,// click on notification to open downloaded file (for Android)
        saveInPublicStorage: true,
        fileName: fileName
        );
        // if(taskId.isNotEmpty){
        //   ScaffoldMessenger.of(context).showSnackBar(
        //     SnackBar(content: Text('File Downloaded.'),
        //       duration: const Duration(seconds: 10),
        //         action: SnackBarAction(
        //           label:'Open',
        //           onPressed: () async{
        //             // // Some code to undo the change.
        //             // if(file_msg!="Something is Wrong")
        //             //   Navigator.push(globals.SCAFFOLD_KEY.currentContext, MaterialPageRoute(builder: (context)=>PdfViewer(fileName: fileName,)));
        //             print('open vcf file path :"$filePath/$fileName');
        //             // var response = await FlutterShareMe().;
        //           },
        //         )
        //     ),
        //   );
        // }
        // await FlutterDownloader.open(taskId: taskId);
      }catch(e){
        print("Download vcard exception:$e");
      }
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()async{
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>MainScreen()));
        return true;
      },
      child: Scaffold(
          appBar: AppBar(
            titleSpacing: 0,
            leading: InkWell(
                onTap:(){
                  // setState(() {
                  //   Navigator.of(context).pop();
                  // });
                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>MainScreen()));
                },
                child: Icon(Icons.arrow_back_ios,color: Colors.black,size: 18,)
            ),
            title: Text(' ',style: Theme.of(context).textTheme.headline5.copyWith(
                color: Colors.black,fontSize: 18
            ),),
          ),
          body: Container(
              child: Column(children: <Widget>[
                Expanded(
                    child: InAppWebView(
                      // initialFile:widget.webViewUrl,
                      initialUrlRequest:URLRequest(url: Uri.parse(widget.webViewUrl),
                      ),

                      initialOptions: InAppWebViewGroupOptions(
                        crossPlatform: InAppWebViewOptions(
                          useShouldOverrideUrlLoading: true,
                          useShouldInterceptAjaxRequest: true,
                          useOnLoadResource: true,
                          useOnDownloadStart: true,
                          allowFileAccessFromFileURLs: true,
                          cacheEnabled: true,
                          javaScriptEnabled: true,
                          javaScriptCanOpenWindowsAutomatically: true,
                          supportZoom: true,
                          allowUniversalAccessFromFileURLs: true,
                          preferredContentMode: UserPreferredContentMode.MOBILE,
                          incognito: true,

                        ),
                      ),
                      onWebViewCreated: (InAppWebViewController controller) {
                        webView = controller;
                      },
                      // onLoadStart: (InAppWebViewController controller, String url) {
                      //
                      // },
                      // onLoadStop: (InAppWebViewController controller, String url) {
                      //
                      // },
                      shouldOverrideUrlLoading: (controller, request) async {
                        // use shouldOverrideUrlLoading to intercept requests after the first one and check if it is an XML file
                        var url = request.request.url;
                        print("onDownloadStart ${url.toString()}");
                        if(Platform.isIOS)
                          downloadVCFFile(url);
                        print('shouldOverrideUrlLoading:${request.request.url.scheme}');
                        // use shouldOverrideUrlLoading to intercept requests after the first one and check if it is an XML file
                        // var url = shouldOverrideUrlLoadingRequest.request.url;
                        // print("onDownloadStart ${url.toString()}");
                        // if(Platform.isIOS)
                        //   downloadVCFFile(url);
                        // return;
                        // if (url.toString().endsWith(".xml")) {
                        //   // it's an xml file, then cancel the request and do wnload the file
                        //   download(url);
                        //   return ShouldOverrideUrlLoadingAction.toString();
                        // }
                        // return ShouldOverrideUrlLoadingAction.ALLOW;
                        // var url1 = request.request.url.toString();
                        // var scheme = request.request.url.scheme;
                        // var uri = Uri.parse(url1);
                        //
                        // if (scheme.contains('tel') || scheme.contains('whatsapp') || scheme.contains('mailto')) {
                        //   // webView?.stopLoading();
                        //   // webView?.canGoBack();
                        //   if (await canLaunch(url1)) {
                        //     // Launch the App
                        //     await launch(
                        //       url1,
                        //     );
                        //     if(scheme.contains('whatsapp')) {
                        //       webView?.goBack();
                        //     }
                        //     // and cancel the request
                        //     return NavigationActionPolicy.CANCEL;
                        //     // return ShouldOverrideUrlLoadingAction.CANCEL;
                        //   }
                        // }
                        // return NavigationActionPolicy.ALLOW;
                        return;

                      },
                      onDownloadStart: (controller, url) async {
                        downloadVCFFile(url);
                      },
                      onProgressChanged: (InAppWebViewController controller, int progress) {
                        setState(() {
                          this.progress = progress / 100;
                        });
                      },
                    )
                ),
                Align(
                    alignment: Alignment.center,
                    child: _buildProgressBar()
                ),
                ButtonBar(
                  alignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ElevatedButton(
                      child: Icon(Icons.arrow_back),
                      onPressed: () {
                        webView?.goBack();
                      },
                    ),
                    ElevatedButton(
                      child: Icon(Icons.arrow_forward),
                      onPressed: () {
                        webView?.goForward();
                      },
                    ),
                    ElevatedButton(
                      child: Icon(Icons.refresh),
                      onPressed: () {
                        webView?.reload();
                      },
                    ),
                  ],
                ),
              ])),
      ),
    );
  }
  // void _launchURL(browsUrl) async =>
  //     await canLaunch(browsUrl,) ? await launch(browsUrl) : throw 'Could not launch $browsUrl';

  Widget _buildProgressBar() {
    if (progress != 1.0) {
      // return CircularProgressIndicator();
// You can use LinearProgressIndicator also
     return LinearProgressIndicator(
       value: progress,
       valueColor: new AlwaysStoppedAnimation<Color>(Colors.blue),
       backgroundColor: Color(0xFFeef2fb),
     );
    }
    return Container();
  }
}