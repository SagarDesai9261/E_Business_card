// import 'dart:io';
// import 'dart:typed_data';
//
// import 'package:flutter/material.dart';
// import 'package:pdf_viewer_plugin/pdf_viewer_plugin.dart';
// // import 'package:path_provider/path_provider.dart';
// // import 'package:permission_handler/permission_handler.dart';
// import 'package:flutter/widgets.dart';
// import 'package:ext_storage/ext_storage.dart';
// import 'package:share/share.dart';
//
// class PdfViewer extends StatefulWidget{
//     String fileName;
//
//   PdfViewer({this.fileName});
//
//   @override
//   _PdfViewerState createState() => _PdfViewerState();
// }
//
// class _PdfViewerState extends State<PdfViewer> {
//   String path;
//   void loadPdf()async
//   {
//     try {
//       final directory = await ExtStorage.getExternalStoragePublicDirectory(
//           ExtStorage.DIRECTORY_DOWNLOADS);
//       path = directory + "/" + widget.fileName;
//       setState(() {});
//     }catch($e){
//         path=null;
//         print($e);
//     }
//   }
//   @override
//   void initState() {
//     // TODO: implement initState
//     loadPdf();
//     super.initState();
//
//   }
//
//
//   void SelectedItem(BuildContext context, item) {
//     switch (item) {
//       case 0:
//       print("0 is selected");
//       Share.shareFiles([path,]);
//
//         break;
//       case 1:
//         print("menu");
//         break;
//     }
//   }
//   @override
//   Widget build(BuildContext context) {
//
//     PdfView.platform = SurfaceAndroidPdfViewer();
//         return  Scaffold(
//           appBar: AppBar(
//             title: Text("Policy Master"),
//             actions: [
//           Theme(
//           data: Theme.of(context).copyWith(
//               textTheme: TextTheme().apply(bodyColor: Colors.black,displayColor: Colors.black,),
//               dividerColor: Colors.black,
//               iconTheme: IconThemeData(color: Colors.white)),
//           child: PopupMenuButton<int>(
//             color: Colors.white,
//             itemBuilder: (context) => [
//               // PopupMenuDivider(),
//               PopupMenuItem<int>(
//                   value: 0,
//                   child: Row(
//                     children: [
//                       Icon(
//                         Icons.share,
//                         color: Theme.of(context).primaryColor,
//                       ),
//                       const SizedBox(
//                         width: 7,
//                       ),
//                       Text("Share",style: TextStyle(color: Colors.black))
//                     ],
//                   )
//               ),
//             ],
//             onSelected: (item) => SelectedItem(context, item),
//           ),
//         ),
//     ],
//         ),
//
//           body: Center(
//             child: Column(
//               children: <Widget>[
//                 if (path != null)
//                   Container(
//                     height:MediaQuery.of(context).size.height-MediaQuery.of(context).size.height*0.1 ,
//                     width: double.infinity,
//                     child: PdfView(
//                       path:path,
//                     ),
//                   )
//                 else
//                   Text("Pdf is not Loaded"),
//               ],
//             ),
//           ),
//         );
//
//   }
// }