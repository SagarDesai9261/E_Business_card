import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;


import 'package:e_business_card/screens/appointments_screen.dart';
import 'package:e_business_card/screens/calendar_screen.dart';
import 'package:e_business_card/screens/login_screen.dart';
import 'package:e_business_card/screens/user_account.dart';
import 'package:e_business_card/screens/write_screen.dart';
import 'package:e_business_card/src/bloc/blocs.dart';
import 'package:e_business_card/src/repositories/repositories.dart';
import 'package:e_business_card/util/constant_method.dart';
import 'package:e_business_card/util/show_message.dart';
import 'package:e_business_card/widgets/dashboard_users_list.dart';
import 'package:e_business_card/widgets/user_profile_form.dart';
import 'package:e_business_card/widgets/webview_widget2.dart';
import 'package:e_business_card/widgets/yearly_plans.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_nfc_kit/flutter_nfc_kit.dart';
import 'package:ndef/ndef.dart' as ndef;
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/foundation.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:google_sign_in/google_sign_in.dart';

// import 'package:flutter_facebook_login/flutter_facebook_login.dart';
//import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:swipe_cards/swipe_cards.dart';
import 'package:vcard_maintained/vcard_maintained.dart';

import '../globals.dart' as globals;

import 'package:http/http.dart' as http;

GoogleSignIn _googleSignIn = GoogleSignIn(
  // Optional clientId
  // clientId: '479882132969-9i9aqik3jfjd7qhci1nqf0bm2g71rm1u.apps.googleusercontent.com',
  scopes: <String>[
    'email',
    'https://www.googleapis.com/auth/contacts.readonly',
  ],
);

class MainScreen extends StatefulWidget {
  MainScreenState createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen>
    with SingleTickerProviderStateMixin {
  final formKey = GlobalKey<FormState>();
  bool iconTapFlag = true;
  String buttonText = 'Create Profile';
  Widget currentWidget;
  bool historyBackIconFlag = false;
  String homeIconPath = 'assets/images/ic_homegray.png';

  // AnimationController _controller;
  // Animation<Offset> _offsetAnimation;
  int mobileVisibleCounter = 0;
  int emailVisibleCounter = 0;
  bool visibleBloc = false;
  bool visibleGetAllCardBloc = false;
  bool emptyDataFlag = false;
  DataBloc _dataBloc;
  String uuid;
  String businessId;
  bool visibleplanbloc = false;
  String currentProfile;
  var tag;
  bool _reading = false;
  List<dynamic> planlist = [];
  StreamSubscription<NdefMessage> _stream;
  bool textFieldReadOnlyFlag = false;
  String uuidForReadOnly;
  GlobalKey _globalKeyForQRCode = new GlobalKey();
  String browsUrl;
  BuildContext thisContext;
  List<SwipeItem> _swipeItems = <SwipeItem>[];
  MatchEngine _matchEngine;
  GlobalKey writeDialogKey = new GlobalKey();
  final titleController = TextEditingController();
  final subTitleController = TextEditingController();
  final designationController = TextEditingController();
  final metaKeywordsController = TextEditingController();
  final metaDescriptionController = TextEditingController();
  final descriptionController = TextEditingController();
  final googleAnalyticController = TextEditingController();
  final facebookPixelController = TextEditingController();
  final customJSController = TextEditingController();
  final slugController = TextEditingController();

  final List<dynamic> contactInfoWidgetList = [];
  final List<dynamic> socialLinksWidgetList = [];
  final List<dynamic> appointmentWidgetList = [];
  final List<dynamic> servicesWidgetList = [];
  final List<dynamic> testimonialsWidgetList = [];
  List<dynamic> businessHourWidgetList;

  final websiteController = TextEditingController();
  final cityController = TextEditingController();
  final stateController = TextEditingController();
  final countryController = TextEditingController();
  final postalCodeController = TextEditingController();
  final linkedInController = TextEditingController();
  final twitterController = TextEditingController();
  final facebookController = TextEditingController();
  final instagramController = TextEditingController();
  final youtubeController = TextEditingController();
  final compnayNameController = TextEditingController();

  // final List<TextEditingController> mobileNumberGroup=[TextEditingController(),TextEditingController()];
  final List<TextEditingController> mobileNumberGroup = [];

  // List<TextEditingController> emailAddressGroup=[];
  final List<dynamic> multipleDynamicFieldList = [];

  final List switchFlags = [
    false,
    false,
    false,
    false,
    false,
    false,
  ];
  bool _supportsNFC = false;

  //database Variables
  String dbPath;
  Database database;
  PreferredSizeWidget appbar;
  ValueNotifier<dynamic> NFCresult = ValueNotifier(null);
  bool qrSwitchFlag = true;

  Future logout() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString("user_login", "logout");
    String socialType = preferences.getString('social_type').toString();

    if (socialType == "google") {
      _googleSignIn.disconnect();
    } else if (socialType == "facebook") {
      // final facebookLogin = FacebookLogin();
      // facebookLogin.logOut();
    } else if (socialType == "linkedin") {}
    // preferences.remove('user_name');
    // preferences.remove('user_email');
    // preferences.remove('user_token');
    //
    // print('Shared Preference removed');
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => LoginScreen()));
  }

  /*Future<bool> logoutConfirmation(BuildContext context) {
    return showDialog(
          context: context,
          builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0)),
            title: Text(
              'Do you want to Log Out?',
              style: Theme.of(context).textTheme.bodyText2,
            ),
            content: Text(
              'Are You Sure ?',
              style: Theme.of(context).textTheme.bodyText2.copyWith(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w500),
            ),
            actions: <Widget>[
              ElevatedButton(
                onPressed: () {
                  print("you choose no");
                  Navigator.of(context).pop(false);
                },
                child: Text('No'),
              ),
              ElevatedButton(
                onPressed: () {
                  logout();
                },
                child: Text('Yes'),
              ),
            ],
          ),
        ) ??
        false;
  }*/

  Future<bool> logoutConfirmation(BuildContext context) async {
    bool confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        title: Text(
          'Do you want to Log Out?',
          style: Theme.of(context).textTheme.bodyText2,
        ),
        content: Text(
          'Are You Sure ?',
          style: Theme.of(context).textTheme.bodyText2.copyWith(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: <Widget>[
          ElevatedButton(
            onPressed: () {
              print("You chose no");
              Navigator.of(context).pop(false);
            },
            child: Text('No'),
          ),
          ElevatedButton(
            onPressed: () {
              logout();
            },
            child: Text('Yes'),
          ),
        ],
      ),
    );

    return confirm ?? false;
  }

  Future writeNfcCardDialog(BuildContext ctx) async {
    print('show dialog called');
    var writeButtonVisibility= true;

    if (globals.singleCardToWrite == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please Select Card to Write !'),
          duration: const Duration(seconds: 2),
        ),
      );
    } else {
      if(Platform.isAndroid) {
        writeNfcCard();
        writeButtonVisibility=false;
      }
      WidgetsBinding.instance.addPostFrameCallback((_) => showDialog(
            context: ctx,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return Dialog(
                key: writeDialogKey,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0)),
                child: Container(
                  // height: 350,
                  width: 350,
                  child: Column(
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Align(
                          alignment: Alignment.topRight,
                          child: InkWell(
                              onTap: (){
                                if (Platform.isAndroid) tagPoll();
                                Navigator.of(context).pop();
                              },
                              child: Container(
                                  padding: const EdgeInsets.all(10),
                                  child: Icon(Icons.close,
                                      color: Colors.indigo)))),
                      SizedBox(
                        height: 10,
                      ),
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Image.asset(
                            'assets/images/tap_and_hold.png',
                            height: 200,
                            width: 200,
                          ),
                          Text(
                            'Tap & Hold\nNFC Card',
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .headline6
                                .copyWith(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                          )
                        ],
                      ),
                      // SizedBox(
                      //   height: 10,
                      // ),
                      Visibility(
                        visible: writeButtonVisibility,
                        child: Container(
                          width: 150,
                          margin: EdgeInsets.only(top: 20),
                          child: ElevatedButton(
                              onPressed: writeNfcCard,
                              child: Text('Write',
                                  style: Theme.of(context).textTheme.headline1)),
                        ),
                      ),
                      SizedBox(
                        height: 50,
                      ),
                    ],
                  ),
                ),
              );
            },
          ));
    }
  }

  void selectedMenuItem(BuildContext context, item) {
    switch (item) {
      case 'Appointments':
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => AppointmentsScreen()));

        break;
      case "Calendar":
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => CalenderScreen()));
        break;
        // case 'About us':
        //   Navigator.of(context)
        //       .push(MaterialPageRoute(builder: (context) => AboutUs()));
        //   break;
        // case 'Contact us':
        //   Navigator.of(context)
        //       .push(MaterialPageRoute(builder: (context) => ContactUs()));
        break;
      // case 'Upgrade Plan':
      //   upgradeToProButtonClick();

      //   showSnack("Swipe Card to see another available Plans");
      //   // Navigator.of(context).push(MaterialPageRoute(builder: (context)=>WebViewWidget2(webViewUrl: "https://flutter.dev/",)));
      //   break;
      case 'Account':
        Navigator.of(context).push(PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              UserAccount(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(0.0, 1.0);
            const end = Offset.zero;
            const curve = Curves.ease;

            var tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
        ));
        break;
      case 'Log Out':
        logoutConfirmation(context);
        break;
    }
  }

  Route _createRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  Future<void> _widgetImageSaverForQr() async {
    // Navigator.of(context).pop();
    if (globals.permissionGranted) {
      if(_globalKeyForQRCode.currentContext != null){

        print("DS>>> "+_globalKeyForQRCode.currentContext.toString());
        RenderRepaintBoundary boundary = _globalKeyForQRCode.currentContext.findRenderObject();
        ui.Image image = await boundary.toImage();
        ByteData byteData =
        await image.toByteData(format: ui.ImageByteFormat.png);
        Uint8List pngBytes = byteData.buffer.asUint8List();

        final result = await ImageGallerySaver.saveImage(
            Uint8List.fromList(pngBytes),
            quality: 70);
        if (result != null && result != "") {
          //Return path
          // String str = Uri.decodeComponent(result);
          print("image Saver Result: $result");

          showSnack(Platform.isIOS
              ? "Successfully saved to gallery"
              : "Successfully saved to :${result['filePath']}");
        } else {
          showSnack("Save failed");
        }
      }
      else{
        print("Global key context is null");
      }

    } else
      showSnack("Permission Denied");
  }

  /*Future<void> _widgetImageSaverForQr() async {
    // Navigator.of(context).pop();
    if (globals.permissionGranted) {
      RenderRepaintBoundary boundary;

      // Check if the global key is valid and the context is available
      if (_globalKeyForQRCode != null && thisContext != null) {
        // Retrieve the RenderRepaintBoundary object associated with the global key
        boundary = thisContext.findRenderObject();// as RenderRepaintBoundary;
      }

      // If the boundary is found, proceed with capturing the image
      if (boundary != null) {
        ui.Image image = await boundary.toImage();
        ByteData byteData = await image.toByteData(format: ui.ImageByteFormat.png);
        Uint8List pngBytes = byteData.buffer.asUint8List();

        final result = await ImageGallerySaver.saveImage(
            Uint8List.fromList(pngBytes),
            quality: 70);

        if (result != null && result != "") {
          // Handle successful image saving
          print("image Saver Result: $result");
          showSnack(Platform.isIOS
              ? "Successfully saved to gallery"
              : "Successfully saved to :${result['filePath']}");
        } else {
          showSnack("Save failed");
        }
      } else {
        // Handle the case where the boundary is not found
        print("Unable to find RenderRepaintBoundary for QR code capture");
      }
    } else
      showSnack("Permission Denied");
  }*/

  Future<void> generatedQrCodeDialogBox(singleContact) async {
    print('show QR Code dialog called:$singleContact');

    WidgetsBinding.instance.addPostFrameCallback((_) => showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return QRDialogWidget(
              context: context,
              globalKeyForQRCode: _globalKeyForQRCode,
              qrSwitchFlag: qrSwitchFlag,
              uuid: singleContact['uuid'],
              slug: singleContact['slug'],
              widgetImageSaverForQr: _widgetImageSaverForQr,
            );
            // return Dialog(
            //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
            //   child: Container(
            //     height: 350,
            //     width:350,
            //     child: Column(
            //       children: [
            //         Align(
            //             alignment: Alignment.topRight,
            //             child: InkWell(
            //                 onTap: ()=>Navigator.of(context).pop(),
            //                 child: Container(
            //                     padding: const EdgeInsets.all(10),
            //                     child: Icon(Icons.close,color:Colors.indigo)
            //                 )
            //             )
            //         ),
            //         Switch(value:qrSwitchFlag , onChanged:(val){
            //             qrSwitchFlag=val;
            //         }
            //         ),
            //         SizedBox(height: 10,),
            //         Container(
            //           height: 200,
            //           width: 200,
            //           child: RepaintBoundary(
            //             key: _globalKeyForQRCode,
            //             child: QrImage(
            //               padding: const EdgeInsets.all(30),
            //               backgroundColor: Colors.white,
            //               data: singleContact['uuid'],
            //               version: QrVersions.auto,
            //               size: 320,
            //               gapless: false,
            //               errorStateBuilder: (cxt, err) {
            //                 return Container(
            //                   child: Center(
            //                     child: Text(
            //                       "Uh oh! Something went wrong...",
            //                       textAlign: TextAlign.center,
            //                     ),
            //                   ),
            //                 );
            //               },
            //             ),
            //           ),
            //         ),
            //         TextButton(onPressed:_widgetImageSaverForQr,
            //             child: Text('Download',style:Theme.of(context).textTheme.headline5.copyWith(
            //               fontSize: 14,color:Color(0xFF006ade),
            //             )
            //             )
            //         )
            //       ],
            //     ),
            //   ),
            // );
          },
        ));

    /*WidgetsBinding.instance.addPostFrameCallback((_) {
      if (thisContext != null) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return QRDialogWidget(
              globalKeyForQRCode: _globalKeyForQRCode,
              qrSwitchFlag: qrSwitchFlag,
              uuid: singleContact['uuid'],
              slug: singleContact['slug'],
              widgetImageSaverForQr: _widgetImageSaverForQr,
            );
          },
        );
      } else {
        // Handle the case where the widget is not yet built
      }
    });*/
  }

  void cardPopupMenuOnTap(String menuString, String uuid, {singleContact}) {
    print("Selected menu Item :$menuString");
    print("Selected menu Item UUID:$uuid");

    if (menuString == 'Generate PDF') {
      print('single contact data for pdf:$singleContact');
    }

    if (menuString == "QR Code") {
      print(singleContact);
      generatedQrCodeDialogBox(singleContact);
    }
    if (menuString == "Write") {
      setState(() {
        currentWidget = WriteScreen(
            selectUserId: uuid, writeNfcCardDialog: writeNfcCardDialog);
        buttonText = 'Write';
        iconTapFlag = false;
        if (Platform.isAndroid) tagPoll();
      });
    }

    if (menuString == "Edit" || menuString == "View") {
      setState(() {
        if (menuString == "Edit") {
          buttonText = "Update Profile";
          textFieldReadOnlyFlag = false;
          // mobileVisibleCounter=mobilecounter;
          print("Mobile counter:$mobileVisibleCounter");
        } else {
          buttonText = "Edit Profile";
          textFieldReadOnlyFlag = true;
          uuidForReadOnly = uuid;
        }
        this.uuid = uuid;
        businessId = uuid;
        iconTapFlag = true;
        currentWidget = UserProfileForm(
          editable: true,
          formKey: formKey,
          titleController: titleController,
          designationController: designationController,
          descriptionController: descriptionController,
          subTitleController: subTitleController,
          metaKeywordsController: metaKeywordsController,
          metaDescriptionController: metaDescriptionController,
          googleAnalyticController: googleAnalyticController,
          facebookPixelController: facebookPixelController,
          customJSController: customJSController,
          slugController: slugController,
          contactInfoWidgetList: contactInfoWidgetList,
          businessHourWidgetList: businessHourWidgetList,
          socialLinksWidgetList: socialLinksWidgetList,
          appointmentWidgetList: appointmentWidgetList,
          servicesWidgetList: servicesWidgetList,
          testimonialsWidgetList: testimonialsWidgetList,
          switchFlags: switchFlags,
          websiteController: websiteController,
          mobileNumberGroup: mobileNumberGroup,
          cityController: cityController,
          countryController: countryController,
          facebookController: facebookController,
          instagramController: instagramController,
          linkedInController: linkedInController,
          postalCodeController: postalCodeController,
          twitterController: twitterController,
          youtubeController: youtubeController,
          compnayNameController: compnayNameController,
          mobileVisibleCounter: mobileVisibleCounter,
          emailVisibleCounter: emailVisibleCounter,
          stateController: stateController,
          cardPopUpMenuString: menuString,
          businessId: uuid,
          textFieldReadOnlyFlag: textFieldReadOnlyFlag,
          multipleDynamicFieldList: multipleDynamicFieldList,
        );
      });
    }
  }

  void getAllContactCardInfo() {
    visibleGetAllCardBloc = true;

    var url = '${globals.API_URL}/api/business_listing';
    var data = {
      "user_id": globals.USER_ID,
      // "csrf_token":globals.USER_TOKEN,
      // "limit":"10",
      // "offset":"0"
    };

    _dataBloc = DataBloc(
        dataRepository: DataRepository(
            dataApiClient: DataApiClient(
      url: url,
      data: data,
    )));
    _dataBloc.add(FetchData());
  }

  var controller = PageController(viewportFraction: 0.9);

  void getAllPlan() {
    setState(() {
      visibleplanbloc = true;
    });

    var url = '${globals.API_URL}/api/show_all_plan';

    _dataBloc = DataBloc(
        dataRepository: DataRepository(
            dataApiClient: DataApiClient(
      url: url,
    )));
    _dataBloc.add(FetchData());
  }

  Future getAllCardApiResponse(List<Object> responseData) async {
    print('Main Screen List responce: $responseData');
    setState(() {
      visibleGetAllCardBloc = false;
    });

    //Map<String, Object> responseMap = responseData[0];
    Map<String, Object> responseMap = responseData[0] as Map<String, Object>;
   /* var contactList = [];
    if (responseMap!['status'] == '1') {
      var data = responseMap['result'];
      contactList = data ;*/
    var contactList = [];
    if (responseMap['status'] == '1') {
      var data = responseMap['result'] as List<dynamic>;
      contactList = data;
    }
      // contactList= data.entries.map( (entry) => entry.value).toList();
      if (contactList.isEmpty) {
        setState(() {
          emptyDataFlag = true;
          textFieldReadOnlyFlag = false;
          userIconOnTap();
        });
      } else {
        setState(() {
          homeIconOnTap();
        });
        emptyDataFlag = false;
      }
    }
    // else {
    //   ShowMessage().showSnack('Token expired', context);
    //   //  logout();
    //   return;
    // }


  Future getPlanApiResponse(List<Object> responseData) async {
    print('Main Screen List responce: $responseData');
    setState(() {
      visibleplanbloc = false;
    });

    //Map<String, Object> responseMap = responseData[0];
    Map<String, Object> responseMap = Map<String, Object>.from(responseData[0] as Map);
    if (responseMap['status'] == '1') {
      var data = responseMap['result']as List<dynamic>;;
      planlist = data ?? [];
      // contactList= data.entries.map( (entry) => entry.value).toList();
      if (planlist.isEmpty) {
        setState(() {
          emptyDataFlag = true;
          textFieldReadOnlyFlag = false;
          // userIconOnTap();
        });
      } else {
        setState(() {
          //   homeIconOnTap();
        });
        emptyDataFlag = false;
      }
    } else {
      ShowMessage().showSnack('Token expired', context);
      //   logout();
      return;
    }
  }

  Widget availableinpack({@required String pack}) {
    return Row(
      children: [
        Icon(
          Icons.check,
          color: Colors.black,
          size: 28,
        ),
        SizedBox(
          width: 7,
        ),
        Text(
          pack,
          style: Theme.of(context).textTheme.headline6.copyWith(
                fontSize: 15,
              ),
        )
      ],
    );
  }

  void upgradeToProButtonClick() {
    /*showBarModalBottomSheet(
        backgroundColor: Theme.of(context).canvasColor,
        context: context,
        builder: (ctx) {
          return Container(
            height: 400,
            child: Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(20),
                      topLeft: Radius.circular(20)),
                ),
                leading: IconButton(
                  icon: new Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.black,
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                title: Text(
                  'Upgrade Plan',
                  style: Theme.of(context).textTheme.headline2,
                ),
                centerTitle: true,
              ),
              body: Container(
                // margin: EdgeInsets.only(top:30),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20))),
                height: double.infinity,
                width: double.infinity,
                child: Align(
                    alignment: Alignment.center,
                    child: Container(
                      height: MediaQuery.of(context).size.height / 1.8,
                      width: MediaQuery.of(context).size.width / 1.45,
                      margin: EdgeInsets.all(7),
                      child: PageView.builder(
                          controller: controller,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(20),
                              child: Container(
                                // height: MediaQuery.of(context).size.height / 2,
                                // width: MediaQuery.of(context).size.width / 2,
                                padding: EdgeInsets.all(10),
                                child: Column(
                                  children: [
                                    Spacer(),
                                    Text(
                                      planlist[index]["name"],
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline2
                                          .copyWith(
                                            color: Colors.black,
                                          ),
                                    ),
                                    Spacer(),
                                    RichText(
                                        text: TextSpan(children: [
                                      TextSpan(
                                        text: "₹ ",
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline6,
                                      ),
                                      TextSpan(
                                          text: planlist[index]["price"],
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline2
                                              .copyWith(
                                                fontSize: 23,
                                              )),
                                      TextSpan(
                                        text: "/" + planlist[index]["duration"],
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline6,
                                      )
                                    ])),
                                    Spacer(),
                                    availableinpack(
                                        pack: planlist[index]["total_theme"]
                                                .toString() +
                                            " Themes"),
                                    Spacer(),
                                    availableinpack(
                                        pack: planlist[index]["business"]
                                                .toString() +
                                            " Business"),
                                    Spacer(),
                                    planlist[index]["enable_custdomain"] ==
                                            "off"
                                        ? Row(
                                            children: [
                                              Icon(
                                                Icons.close,
                                                size: 28,
                                                color: Colors.black,
                                              ),
                                              Text(" Custom Domain",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .headline6
                                                      .copyWith(fontSize: 15))
                                            ],
                                          )
                                        : availableinpack(
                                            pack: " Custom Domain"),
                                    Spacer(),
                                    planlist[index]["enable_custsubdomain"] ==
                                            "off"
                                        ? Row(
                                            children: [
                                              Icon(
                                                Icons.close,
                                                size: 28,
                                                color: Colors.black,
                                              ),
                                              SizedBox(
                                                width: 7,
                                              ),
                                              Text("Sub Domain",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .headline6
                                                      .copyWith(
                                                        fontSize: 15,
                                                      ))
                                            ],
                                          )
                                        : availableinpack(pack: "Sub Domain"),
                                    Spacer(),
                                    ElevatedButton(
                                        onPressed: () {},
                                        child: Container(
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          padding: EdgeInsets.all(6),
                                          child: Center(
                                            child: Text(planlist[index]
                                                        ["price"] ==
                                                    "0.00"
                                                ? "Free"
                                                : planlist[index]["price"]),
                                          ),
                                        )),
                                    Spacer(),
                                  ],
                                ),
                                decoration: BoxDecoration(
                                  color: ui.Color(0xFFeef2fb),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                            );
                          },
                          // separatorBuilder: (context, index) {
                          //   return SizedBox(
                          //     width: 20,
                          //   );
                          // },
                          itemCount: planlist.length),
                    )),
                // child: SwipeCards(
                //   matchEngine: _matchEngine,
                //   itemBuilder: (BuildContext context, int index) {
                //     return Container(
                //       alignment: Alignment.center,
                //       child: _swipeItems[index].content,
                //     );
                //   },
                //   onStackFinished: () {
                //     showSnack("Plans over");
                //     // print("swipe cards:$_swipeItems");
                //     // Navigator.of(context).pop();
                //     setState(() {
                //       setCardsStack();
                //     });
                //   },
                // ),
              ),
            ),
          );
        });*/
  }

  void setCardsStack() {
    for (int i = 0; i < 10; i++) {
      _swipeItems.add(SwipeItem(
          content: YearlyPlans(),
          likeAction: () {
            print("like action");
          },
          nopeAction: () {
            print("nope action");
          },
          superlikeAction: () {
            print("superLike action");
          }));
    }

    _matchEngine = MatchEngine(swipeItems: _swipeItems);
  }

  Future<void> initPlatformState() async {
    NFCAvailability availability;
    try {
      availability = await FlutterNfcKit.nfcAvailability;
    } on PlatformException {
      availability = NFCAvailability.not_supported;
    }
    if(availability == NFCAvailability.not_supported){
      Fluttertoast.showToast(
          msg: "Your Device does not support NFC",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }


  }

  @override
  void initState() {
    super.initState();
    // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    //   statusBarColor: Colors.black,
    // ));

    businessHourWidgetList = [
      {
        'status': false,
        'title': 'Sunday',
        'start_time': TextEditingController(text: ''),
        'end_time': TextEditingController(text: '')
      },
      {
        'status': false,
        'title': 'Monday',
        'start_time': TextEditingController(text: ''),
        'end_time': TextEditingController(text: '')
      },
      {
        'status': false,
        'title': 'Tuesday',
        'start_time': TextEditingController(text: ''),
        'end_time': TextEditingController(text: '')
      },
      {
        'status': false,
        'title': 'Wednesday',
        'start_time': TextEditingController(text: ''),
        'end_time': TextEditingController(text: '')
      },
      {
        'status': false,
        'title': 'Thursday',
        'start_time': TextEditingController(text: ''),
        'end_time': TextEditingController(text: '')
      },
      {
        'status': false,
        'title': 'Friday',
        'start_time': TextEditingController(text: ''),
        'end_time': TextEditingController(text: '')
      },
      {
        'status': false,
        'title': 'Saturday',
        'start_time': TextEditingController(text: ''),
        'end_time': TextEditingController(text: '')
      },
    ];
    if (Platform.isAndroid) tagPoll();

    setState(() {
      // userIconOnTap();
      getAllContactCardInfo();
      getAllPlan();
    });

    initPlatformState();
    /*NFC.isNDEFSupported.then((bool isSupported) {
      _supportsNFC = isSupported;
      if (!_supportsNFC) {
        Fluttertoast.showToast(
            msg: "Your Device does not support NFC",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    });*/

    appbar = PreferredSize(
        preferredSize: const Size.fromHeight(90.0),
        child: AppBar(
          systemOverlayStyle: SystemUiOverlayStyle.dark,
          automaticallyImplyLeading: false,
          title: Image.asset(
            'assets/images/logo.png',
            height: 210,
            width: 210,
          ),
          // Flexible(
          //   // width: 40,
          //   child:
          //   Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //     children: [
          //       Image.asset('assets/images/logo.png', height: 200,width: 200,),
          //       SizedBox(width: 8,),
          //       Expanded(
          //         child: OutlinedButton(
          //           onPressed: upgradeToProButtonClick,
          //           child: Text('Upgrade to Pro',style: TextStyle(fontSize: 8),),
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
          centerTitle: false,
          actions: [
            PopupMenuButton<String>(
              icon: historyBackIconFlag
                  ? Icon(Icons.arrow_back_ios)
                  : Image.asset(
                      'assets/images/ic_menu.png',
                      height: 20,
                      width: 20,
                    ),
              padding: EdgeInsets.only(right: 20),
              color: Colors.white,
              itemBuilder: (BuildContext context) {
                return [ 'Calendar', "Account",'Log Out']
                    .map((String value) {
                  return PopupMenuItem<String>(
                      value: value,
                      child: Text(value,
                          style: TextStyle(
                              color: Colors.black, fontFamily: 'Poppins')));
                }).toList();
              },
              // PopupMenuDivider(),
              onSelected: (item) => selectedMenuItem(context, item),
            )
          ],
        ));

    WidgetsBinding.instance.addObserver(LifecycleEventHandler(
        resumeCallBack: () async => setState(() {
              // do something
              if (Platform.isAndroid) tagPoll();
            })));

    setCardsStack();
  }

  Future<void> homeIconOnTap() async {
    bool flag = true;

    if (flag) {
      setState(() {
        iconTapFlag = true;
        buttonText = 'Add Profile';
        currentWidget = DashboardUsersList(
            database: database,
            writeCardOnTap: writeCardOnTap,
            cardPopUpMenuOnTap: cardPopupMenuOnTap,
            nfcCardReading: nfcCardReading);
        if (Platform.isAndroid) tagPoll();
        homeIconPath = 'assets/images/ic_homeblue.png';
      });
    }
    setState(() {});
  }

  void userIconOnTap() {
    if (buttonText == "Update Profile" || buttonText == "Edit Profile") return;

    setState(() {
      globals.selectedAvatarImage = null;
      globals.selectedCoverImage = null;
      titleController.clear();
      designationController.clear();
      descriptionController.clear();
      subTitleController.clear();
      metaKeywordsController.clear();
      metaDescriptionController.clear();
      googleAnalyticController.clear();
      facebookPixelController.clear();
      customJSController.clear();
      slugController.clear();
      contactInfoWidgetList.clear();
      businessHourWidgetList = [
        {
          'status': false,
          'title': 'Sunday',
          'start_time': TextEditingController(text: ''),
          'end_time': TextEditingController(text: '')
        },
        {
          'status': false,
          'title': 'Monday',
          'start_time': TextEditingController(text: ''),
          'end_time': TextEditingController(text: '')
        },
        {
          'status': false,
          'title': 'Tuesday',
          'start_time': TextEditingController(text: ''),
          'end_time': TextEditingController(text: '')
        },
        {
          'status': false,
          'title': 'Wednesday',
          'start_time': TextEditingController(text: ''),
          'end_time': TextEditingController(text: '')
        },
        {
          'status': false,
          'title': 'Thursday',
          'start_time': TextEditingController(text: ''),
          'end_time': TextEditingController(text: '')
        },
        {
          'status': false,
          'title': 'Friday',
          'start_time': TextEditingController(text: ''),
          'end_time': TextEditingController(text: '')
        },
        {
          'status': false,
          'title': 'Saturday',
          'start_time': TextEditingController(text: ''),
          'end_time': TextEditingController(text: '')
        },
      ];
      appointmentWidgetList.clear();
      servicesWidgetList.clear();
      testimonialsWidgetList.clear();
      socialLinksWidgetList.clear();
      for (int i = 0; i < switchFlags.length; i++) switchFlags[i] = false;

      countryController.clear();
      facebookController.clear();
      cityController.clear();
      instagramController.clear();
      linkedInController.clear();
      postalCodeController.clear();
      twitterController.clear();
      youtubeController.clear();
      compnayNameController.clear();
      websiteController.clear();

      for (var controller in mobileNumberGroup) controller.clear();
      mobileNumberGroup.clear();
      // mobileNumberGroup[0].clear();
      // mobileNumberGroup[1].clear();
      stateController.clear();
      countryController.clear();
      cityController.clear();

      iconTapFlag = true;
      uuid = null;
      businessId = null;
      buttonText = 'Create Profile';
      currentWidget = UserProfileForm(
        editable: false,
        formKey: formKey,
        titleController: titleController,
        designationController: designationController,
        descriptionController: descriptionController,
        subTitleController: subTitleController,
        metaKeywordsController: metaKeywordsController,
        metaDescriptionController: metaDescriptionController,
        googleAnalyticController: googleAnalyticController,
        facebookPixelController: facebookPixelController,
        customJSController: customJSController,
        slugController: slugController,
        contactInfoWidgetList: contactInfoWidgetList,
        socialLinksWidgetList: socialLinksWidgetList,
        businessHourWidgetList: businessHourWidgetList,
        appointmentWidgetList: appointmentWidgetList,
        servicesWidgetList: servicesWidgetList,
        testimonialsWidgetList: testimonialsWidgetList,
        switchFlags: switchFlags,
        websiteController: websiteController,
        mobileNumberGroup: mobileNumberGroup,
        cityController: cityController,
        countryController: countryController,
        facebookController: facebookController,
        instagramController: instagramController,
        linkedInController: linkedInController,
        postalCodeController: postalCodeController,
        twitterController: twitterController,
        youtubeController: youtubeController,
        compnayNameController: compnayNameController,
        stateController: stateController,
        emailVisibleCounter: emailVisibleCounter,
        mobileVisibleCounter: mobileVisibleCounter,
        textFieldReadOnlyFlag: false,
        multipleDynamicFieldList: multipleDynamicFieldList,
      );
      homeIconPath = 'assets/images/ic_homegray.png';
    });
  }

  void writeCardOnTap() {
    print('write Screen Open:');
    setState(() {
      currentWidget = WriteScreen();
      buttonText = 'Write';
      iconTapFlag = false;
    });
  }

  Future<void> tagPoll() async {
    tag = await FlutterNfcKit.poll(
        timeout: Duration(minutes: 30),
        iosMultipleTagMessage: "Multiple tags found!",
        iosAlertMessage: "Scan your tag");

    print("Tag Info: $tag");
    if (tag != null) {
      showSnack("NFC tag Detected");
      if (Platform.isAndroid) tagPoll();
    }
    // var result = await FlutterNfcKit.transceive(Duration(minutes:30)); // timeout is still Android-only, persist until next change
    // if (tag.type == NFCTagType.iso7816) {
    //   var result = await FlutterNfcKit.transceive(Duration(minutes:30)); // timeout is still Android-only, persist until next change
    //   // print(result);
    // }
    // read NDEF records if available
    // if (tag.ndefAvailable){
    //   /// decoded NDEF records (see [ndef.NDEFRecord] for details)
    //   /// `UriRecord: id=(empty) typeNameFormat=TypeNameFormat.nfcWellKnown type=U uri=https://github.com/nfcim/ndef`
    //   for (var record in await FlutterNfcKit.readNDEFRecords(cached: false)) {
    //     print(record.toString());
    //   }
    //   /// raw NDEF records (data in hex string)
    //   /// `{identifier: "", payload: "00010203", type: "0001", typeNameFormat: "nfcWellKnown"}`
    //   for (var record in await FlutterNfcKit.readNDEFRawRecords(cached: false)) {
    //     print(record);
    //   }
    // }
  }

  Future<void> writeNfcCard() async {

    _ndefWrite(globals.singleCardToWrite);
    return;
  }

  void _ndefWrite(var singleCard) {
    //For IOS
    NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
      var ndef = Ndef.from(tag);
      if (ndef == null || !ndef.isWritable) {
        NFCresult.value = 'Tag is not ndef writable';
        NfcManager.instance.stopSession(errorMessage: NFCresult.value);
        return;
      }

      print(
          "write data for nfc card:${globals.API_URL}/${singleCard['slug']}");
      NdefMessage message = NdefMessage([
        // NdefRecord.createText('Hello World!'),
        NdefRecord.createUri(
            Uri.parse("${globals.API_URL}/${singleCard['slug']}")),
        // NdefRecord.createMime(
        //     'text/plain', Uint8List.fromList('Hello'.codeUnits)),
        // NdefRecord.createExternal(
        //     'com.example', 'mytype', Uint8List.fromList('mydata'.codeUnits)),
      ]);

      try {
        await ndef.write(message);
        NFCresult.value = 'Success to "Ndef Write"';

        if (Platform.isIOS) {
          NfcManager.instance.stopSession();
        }
        showSnack('Data written successfully');
        if(writeDialogKey.currentContext!=null  ) {
          Navigator.of(writeDialogKey.currentContext).pop();
        }
        if (Platform.isAndroid) tagPoll();
      } catch (e) {
        NFCresult.value = e;
        NfcManager.instance
            .stopSession(errorMessage: NFCresult.value.toString());
        print("Error while writing tag, Please try again: $e");
        showSnack('Something wrong, please try again');
        return;
      }
    });
  }

  Future<void> nfcCardReading() async {
    if (!_supportsNFC) {
      showToast('Your Device does not support NFC');
    }

    if (Platform.isAndroid) if (tag == null) return;
    // if(Platform.isAndroid) tagPoll();
    if (tag != null) await FlutterNfcKit.finish();
    print("NFC reading flag :$_reading");
    Navigator.of(context).pop();
    // if (_reading) {
    //   _stream?.cancel();
    //   setState(() {
    //     _readingreading = false;
    //   });
    // } else {
    setState(() {
      _reading = true;
      // Start reading using NFC.readNDEF()

      var result = FlutterNfcKit.readNDEFRecords(cached: false);
      _stream = result.asStream() as StreamSubscription<NdefMessage>;
      print(_stream.toString());

      if (Platform.isAndroid) {
        tagPoll();
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => WebViewWidget2(
              webViewUrl: "https://${_stream}",
              // webViewUrl:"${message.data}",
            )));
        return;
      }
      browsUrl = "https://${_stream}";
      // browsUrl="${message.data}";
      if (Platform.isIOS) _launchURL();


     /* _stream = NFC
          .readNDEF(
        once: true,
        throwOnUserCancel: false,
      )
          .listen((NdefMessage message) {
        print("read NDEF message: ${message.data}");
        print(message.data);
        // setState(() {
        //   _reading=false;
        //   // currentWidget=WebViewWidget(webViewUrl:"https://${message.data}",);
        // });
        if(message.data.trim().isEmpty || message.data==null || message.data=="null"){
          if (Platform.isAndroid) tagPoll();
          showToast("Nfc tag is empty!");
          return;
        }
        if (Platform.isAndroid) {
          tagPoll();
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => WebViewWidget2(
                    webViewUrl: "https://${message.data}",
                    // webViewUrl:"${message.data}",
                  )));
          return;
        }
        browsUrl = "https://${message.data}";
        // browsUrl="${message.data}";
        if (Platform.isIOS) _launchURL();
      }, onError: (e) {
        // Check error handling guide below
        print('NFC Error: $e');
      });
    });*/

    // }
    // if(Platform.isAndroid) tagPoll();
    });
  }



  void _launchURL() async => await canLaunch(
        browsUrl.toString(),
      )
          ? await launch(browsUrl.toString())
          : throw 'Could not launch $browsUrl';

  void showSnack(String str) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(str),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void addProfileButton(BuildContext context) //add business card
  {
    // String facebookUrl,linkedinUrl,twitterUrl,youtubeUrl,instagramUrl;
    // if(uuid!=null){
    //   if(facebookController.text.toString().trim()!="" && !facebookController.toString().contains("https://www.facebook.com/"))
    //   {
    //     facebookController.text="https://www.facebook.com/"+facebookController.text;
    //   }if(linkedInController.text.toString().trim()!="" && !linkedInController.toString().contains("https://www.linkedin.com/"))
    //   {
    //     linkedInController.text="https://www.linkedin.com/"+linkedInController.text;
    //   }if(twitterController.text.toString().trim()!="" && !twitterController.toString().contains("https://www.twitter.com/"))
    //   {
    //     twitterController.text="https://www.twitter.com/"+twitterController.text;
    //   }if(instagramController.text.toString().trim()!="" && !instagramController.toString().contains("https://www.instagram.com/"))
    //   {
    //     instagramController.text="https://www.instagram.com/"+instagramController.text;
    //   }if(youtubeController.text.toString().trim()!="" && !youtubeController.toString().contains("https://www.youtube.com/"))
    //   {
    //     youtubeController.text="https://www.youtube.com/"+youtubeController.text;
    //   }
    // }
    // // print("Generated UUID:${Uuid().v1().runtimeType}");
    //
    // //multipleFields
    // List<String> multiplePhoneList=[];
    // List<String> multipleMobileList=[];
    // List<String> multipleEmailList=[];
    // List<String> multipleWebsiteList=[];
    // for(var singleField in multipleDynamicFieldList){
    //   if(singleField['type']=='Phone'){
    //     multiplePhoneList.add(singleField['controller'].text);
    //   }
    //   if(singleField['type']=='Mobile'){
    //     multipleMobileList.add(singleField['controller'].text);
    //   }if(singleField['type']=='Email'){
    //     multipleEmailList.add(singleField['controller'].text);
    //   }if(singleField['type']=='Website'){
    //     multipleWebsiteList.add(singleField['controller'].text);
    //   }
    // }
    // print('multiple phone:${multiplePhoneList}');
    // print('multiple mobile:${multipleMobileList}');
    // print('multiple email:${multipleEmailList}');
    // print('multiple website:${multipleWebsiteList}');
    //
    // print("new User :${globals.USER_ID}");
    // print("new token:${globals.USER_TOKEN}");
    // print("new uuid: ${uuid}");
    // print("global Current Profile: ${globals.current_profile}");
    // print("STATE controller text: ${stateController.text}");

    print("selected Avatar Image: ${globals.selectedAvatarImage}");
    print("selected Avatar Image: ${globals.selectedCoverImage}");

    var url = '${globals.API_URL}/api/add_edit_business_card';
    var data = {
      // "uuid": uuid!=null?uuid:Uuid().v1(),
      // "user_id":globals.USER_ID,
      "business_id": businessId == null ? '' : businessId,
      "title": titleController.text,
      "designation": designationController.text,
      "sub_title": subTitleController.text,
      "description": descriptionController.text,
      'slug': slugController.text,
      // theme_color:test,
      // links:test,
      "meta_keyword": metaKeywordsController.text,
      "meta_description": metaDescriptionController.text,
      // "enable_businesslink":"test",
      // "enable_subdomain":test
      // "subdomain":test
      "enable_domain": "off",
      // "domains":domains,
      "google_analytic": googleAnalyticController.text,
      "fbpixel_code": facebookPixelController.text,
      "customjs": customJSController.text,
      "is_contacts_enabled": switchFlags[0] ? 'on' : 'off',
      "is_business_hours_enabled": switchFlags[1] ? 'on' : 'off',
      "is_appoinment_enabled": switchFlags[2] ? 'on' : 'off',
      "is_services_enabled": switchFlags[3] ? 'on' : 'off',
      "is_testimonials_enabled": switchFlags[4] ? 'on' : 'off',
      "is_socials_enabled": switchFlags[1] ? 'on' : 'off'
      //"is_socials_enabled": 'on'
      // "content":'{"1":{"Phone":"9715012345","id":"1"},"2":{"Email":"360tester03@gmail.com","id":"2"},"4":{"Address":{"Address":"Al Barsha, Dubai, UAE","Address_url":"https:\/\/www.google.com\/"},"id":"4"}}',
      // "is_enabled":"1",
      // "content_business_hour":'{"sun":{"days":"off","start_time":"","end_time":""},"mon":{"days":"on","start_time":"10:00","end_time":"19:00"},"tue":{"days":"off","start_time":"","end_time":""},"wed":{"days":"off","start_time":"","end_time":""},"thu":{"days":"off","start_time":"","end_time":""},"fri":{"days":"off","start_time":"","end_time":""},"sat":{"days":"off","start_time":"","end_time":""}}',
      // "is_enabled_business_hour":'1',
      // "appointment_content":'[{"id":1,"start":"04:46","end":"02:48"},{"id":2,"start":"","end":""}]',
      // "appointment_is_enabled":"1",
      // "service_content":'[{"id":1,"title":"tit","description":"des","purchase_link":"yterst","image":"img_1642750254862844559.jfif"},{"id":2,"title":"","description":"","purchase_link":"","image":""}]',
      // "service_is_enabled":"1",
      // "testimonial_content":'[{"id":1,"rating":"5","description":"Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nam in orci ut diam condimentum hendrerit in nec mi. Donec varius quam sed venenatis pulvinar.","image":"img_1641387195476536393.jpg"},{"id":2,"rating":"5","description":"Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nam in orci ut diam condimentum hendrerit in nec mi. Donec varius quam sed venenatis pulvinar.","image":"img_1641387195961196523.png"}]',
      // "testimonial_is_enabled":"1",
      // "social_content":'{"1":{"Facebook":"https:\/\/www.google.com\/","id":"1"},"2":{"Instagram":"https:\/\/www.google.com\/","id":"2"},"3":{"LinkedIn":"https:\/\/www.google.com\/","id":"3"},"4":{"Twitter":"https:\/\/www.google.com\/","id":"4"},"5":{"Youtube":"https:\/\/www.google.com\/","id":"5"},"6":{"Pinterest":"https:\/\/www.google.com\/","id":"6"},"7":{"Whatsapp":"https:\/\/www.google.com\/","id":"7"}}',
      // "social_is_enabled":"1",
      // "social_linkedin":uuid!=null?linkedInController.text:"https://www.linkedin.com/"+linkedInController.text,
      // "social_linkedin":uuid!=null?linkedInController.text:linkedInController.text.toString().trim()==""?linkedInController.text:"https://www.linkedin.com/"+linkedInController.text,
      // "social_twitter":uuid!=null?twitterController.text:twitterController.text.toString().trim()==""?"":"https://www.twitter.com/"+twitterController.text,
      // "social_facebook":uuid!=null?facebookController.text:facebookController.text.toString().trim()==""?"":"https://www.facebook.com/"+facebookController.text,
      // "social_instagram":uuid!=null?instagramController.text:instagramController.text.toString().trim()==""?"":"https://www.instagram.com/"+instagramController.text,
      // "social_youtube":uuid!=null?youtubeController.text:youtubeController.text.toString().trim()==""?"":"https://www.youtube.com/"+youtubeController.text,
    };

    for (int i = 0; i < contactInfoWidgetList.length; i++) {
      if (contactInfoWidgetList[i]['type'].toString().toLowerCase() ==
          'address') {
        //this is for address url
        data.addAll({
          'contact[${i + 1}][${contactInfoWidgetList[i]['type']}][Address]':
              contactInfoWidgetList[i]['controller'].text
        });
        data.addAll({
          'contact[${i + 1}][${contactInfoWidgetList[i]['type']}][Address_url]':
              contactInfoWidgetList[i]['extra_controller'].text
        });
      } else {
        data.addAll({
          'contact[${i + 1}][${contactInfoWidgetList[i]['type']}]':
              contactInfoWidgetList[i]['controller'].text
        });
      }
    }
    for (int i = 0; i < businessHourWidgetList.length; i++) {
      String currentDay = businessHourWidgetList[i]['title']
          .toString()
          .substring(0, 3)
          .toLowerCase();
      data.addAll({
        'days_$currentDay': businessHourWidgetList[i]['status'] ? 'on' : '',
        'start-$currentDay': ConstantMethod.formatAMPMtoTimeOfDay(
            businessHourWidgetList[i]['start_time'].text),
        'end-$currentDay': ConstantMethod.formatAMPMtoTimeOfDay(
            businessHourWidgetList[i]['end_time'].text),
      });
    }

    for (int i = 0; i < appointmentWidgetList.length; i++) {
      data.addAll({
        "hours[$i][start]": ConstantMethod.formatAMPMtoTimeOfDay(
            appointmentWidgetList[i]['start_hour'].text),
        "hours[$i][end]": ConstantMethod.formatAMPMtoTimeOfDay(
            appointmentWidgetList[i]['end_hour'].text),
      });
    }
    List<dynamic> serviceImageList = [];
    for (int i = 0; i < servicesWidgetList.length; i++) {
      data.addAll({
        'services[$i][title]': servicesWidgetList[i]['title'].text.toString(),
        'services[$i][description]':
            servicesWidgetList[i]['description'].text.toString(),
        'services[$i][purchase_link]':
            servicesWidgetList[i]['purchase_link'].text.toString(),
        'services[$i][get_image]':
            servicesWidgetList[i]['imageNetworkPath'].toString(),
      });

      serviceImageList.add({
        'key': 'services[$i][image]',
        'file': servicesWidgetList[i]['image_file'],
      });
    }

    List<dynamic> testimonialsImageList = [];
    for (int i = 0; i < testimonialsWidgetList.length; i++) {
      data.addAll({
        'testimonials[$i][rating]': testimonialsWidgetList[i]['rating'].text,
        'testimonials[$i][description]':
            testimonialsWidgetList[i]['description'].text,
        'testimonials[$i][get_image]':
            testimonialsWidgetList[i]['imageNetworkPath'] ?? '',
      });
      testimonialsImageList.add({
        'key': 'testimonials[$i][image]',
        'file': testimonialsWidgetList[i]['image_file'],
      });
    }

    for (int i = 0; i < socialLinksWidgetList.length; i++) {
      data.addAll({
        'socials[${i + 1}][${socialLinksWidgetList[i]['type']}]':
            socialLinksWidgetList[i]['controller'].text
      });
    }

    // for(int i=0;i<multipleEmailList.length;i++){
    //   data.addAll({'emails[$i]':multipleEmailList[i]});
    // }for(int i=0;i<multipleWebsiteList.length;i++){
    //   data.addAll({'websites[$i]':multipleWebsiteList[i]});
    // }

    print('cardCreate api data:$data');
    // return;
    setState(() {
      visibleBloc = true;
    });

    _dataBloc = DataBloc(
        dataRepository: DataRepository(
            dataApiClient: DataApiClient(
                url: url,
                data: data,
                avtarImage: globals.selectedAvatarImage,
                coverImage: globals.selectedCoverImage,
                serviceImageList: serviceImageList,
                testimonialsImageList: testimonialsImageList)));
    _dataBloc.add(FetchData());
  }

  Future apiResponse(List<Object> responseData) async {
    setState(() {
      print('api response data : ${responseData}');
      visibleBloc = false;
    });

    Map<String, Object> responseMap = responseData[0] as Map<String, Object>;

    if (responseMap['status'].toString() == '1') {
      if (responseMap['message'].runtimeType == String) {
        showSnack(responseMap['message'].toString());
        setState(() {
          homeIconOnTap();
        });
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>MainScreen()));
      } else {
       // List<Object> messageList = responseMap['message'];
        List<Object> messageList = responseMap['message'] as List<Object>;
        for (int i = 0; i < messageList.length; i++) {
          showSnack(messageList[i].toString());
        }
        /*setState(() {
          homeIconOnTap();
        });*/
      }
      setState(() {
        homeIconOnTap();
      });
      getAllContactCardInfo();
      /*if (emptyDataFlag) {
        print("emptydata flag:${emptyDataFlag}");
        setState(() {
          getAllContactCardInfo();
        });
      }
      emptyDataFlag =
          false;*/ //when first record is inserted user can click on home icon
    } else {
      if (responseMap['message'].runtimeType == String) {
        showSnack(responseMap['message'].toString());
        if (responseMap['message'].toString().toLowerCase().contains('token'))
          logout();
        return;
      }
      List<Object> messageList = responseMap['message'] as List<Object>;
      for (int i = 0; i < messageList.length; i++) {
        showSnack(messageList[i].toString());
      }
      if (responseMap['message'].toString().toLowerCase().contains('token'))
        logout();
    }

    print('userid: ${globals.USER_ID}');
    print('token : ${globals.USER_TOKEN}');
  }

   DateTime currentBackPressTime;

  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime) > const Duration(seconds: 2)) {
      currentBackPressTime = now;
      showToast('Press back again to exit');
      return Future.value(false);
    }
    SystemNavigator.pop();
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    print('appbar height : ' + appbar.preferredSize.height.toString());
    print('token ${globals.USER_TOKEN}');
    print('user Id ${globals.USER_ID}');
    print('user name : ${globals.USER_NAME}');

    if (buttonText == "Update Profile" && textFieldReadOnlyFlag) {
      setState(() {
        textFieldReadOnlyFlag = false;
      });
    }

    print('read only:$textFieldReadOnlyFlag}');
    print('visibleBloc:$visibleBloc}');
    thisContext = context;
    print("Visible Plan Bloc $visibleplanbloc");
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        // resizeToAvoidBottomInset: false,
        appBar: appbar,
        body: visibleBloc || visibleGetAllCardBloc || visibleplanbloc
            ? BlocBuilder<DataBloc, UsersState>(
                bloc: _dataBloc,
                builder: (context, state) {
                  print("state is $state");
                  if (state is UsersLoading) {
                    return Center(
                      child: CircularProgressIndicator(
                        backgroundColor: Theme.of(context).primaryColorDark,
                      ),
                    );
                  }
                  if (state is UsersLoaded) {
                    if (visibleBloc)
                      WidgetsBinding.instance.addPostFrameCallback(
                          (_) => apiResponse(state.responseData));
                    if (visibleplanbloc) {
                      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                        getPlanApiResponse(state.responseData);
                      });
                    } else
                      WidgetsBinding.instance.addPostFrameCallback(
                          (_) => getAllCardApiResponse(state.responseData));
                  }
                  if (state is UsersError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Something went Wrong, Lets Try Again..',
                            style: Theme.of(context).textTheme.headline6,
                          ),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                if (visibleGetAllCardBloc)
                                  getAllContactCardInfo();
                                if (visibleBloc) visibleBloc = false;
                              });
                            },
                            child: Text(
                              "Retry",
                              style: Theme.of(context).textTheme.headline2,
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  return Container();
                })
            : SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      // alignment: Alignment.topCenter,
                      width: double.infinity,
                      height: (MediaQuery.of(context).size.height -
                              appbar.preferredSize.height -
                              MediaQuery.of(context).padding.top) *
                          0.9,
                      child: AnimatedSwitcher(
                          duration: const Duration(seconds: 1),
                          // transitionBuilder: (child,animation){
                          //   return SlideTransition(child: child,position:_offsetAnimation,);
                          // },
                          child: currentWidget),
                    ),
                    Container(
                      width: double.infinity,
                      height: (MediaQuery.of(context).size.height -
                              appbar.preferredSize.height -
                              MediaQuery.of(context).padding.top) *
                          0.1,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          IconButton(
                            onPressed:
                                homeIconOnTap ,
                            icon: Image.asset(
                              homeIconPath,
                              height: 15,
                              width: 15,
                            ),
                          ),
                          Container(
                              height: 45,
                              width: 200,
                              margin: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30)),
                              child: ElevatedButton.icon(
                                  onPressed: () {
                                    // print('business hour widget:${businessHourWidgetList}');
                                    print(
                                        'service widget:${servicesWidgetList}');

                                    if (buttonText == "Write") {
                                      writeNfcCardDialog(context);
                                    } else if (buttonText == "Add Profile") {
                                      userIconOnTap();
                                    } else if (buttonText == 'Edit Profile') {
                                      setState(() {
                                        buttonText = "Update Profile";
                                      });
                                      Fluttertoast.showToast(
                                          msg: "Now You Can Edit Details",
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.BOTTOM,
                                          timeInSecForIosWeb: 1,
                                          backgroundColor: Colors.blueGrey,
                                          textColor: Colors.white,
                                          fontSize: 16.0);
                                      cardPopupMenuOnTap(
                                          "Edit", uuidForReadOnly.toString());
                                    } else if (formKey.currentState
                                        .validate()) {
                                      if (buttonText == 'Create Profile' ||
                                          buttonText == 'Update Profile') {
                                        setState(() {
                                          addProfileButton(context);
                                        });
                                      }
                                    } else {
                                      ShowMessage.showToast(
                                          'Please fill required fields.');
                                    }

                                    print(
                                        'main screen contact info:${contactInfoWidgetList}');
                                    print(
                                        'main screen appointment info:${appointmentWidgetList}');
                                    print(
                                        'main screen services info:${servicesWidgetList}');
                                    print(
                                        'main screen testimonials info:${contactInfoWidgetList}');
                                  },
                                  icon: iconTapFlag
                                      ? Image.asset('assets/images/ic_add.png',
                                          height: 10, width: 10)
                                      : Container(),
                                  label: Text(
                                    buttonText,
                                    style:
                                        Theme.of(context).textTheme.headline1,
                                  ))),
                          IconButton(
                            onPressed: iconTapFlag ? userIconOnTap : null,
                            icon: Icon(Icons.person_outline_rounded,
                                color: iconTapFlag
                                    ? Color(0xFFc3cddf)
                                    : Color(0xFF3277bc)),
                            iconSize: 20,
                            // Image.asset('assets/images/ic_profile2.png',height: 15,width: 15)
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
      ),
    );
  }
}

//global method for show toast
void showToast(str) {
  Fluttertoast.showToast(
      msg: "$str",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0);
}

class QRDialogWidget extends StatefulWidget {
  final BuildContext context;
  final qrSwitchFlag;
  final globalKeyForQRCode;
  final uuid;
  final String slug;
  final widgetImageSaverForQr;

  const QRDialogWidget(
      {Key key,
        this.context,
        this.qrSwitchFlag,
      this.slug,
      this.globalKeyForQRCode,
      this.uuid,
      this.widgetImageSaverForQr})
      : super(key: key);

  @override
  _QRDialogWidgetState createState() => _QRDialogWidgetState();
}

class _QRDialogWidgetState extends State<QRDialogWidget> {
  bool qrSwitchFlag = true;
  bool visibleBloc = false;
  DataBloc _dataBloc;
  ScreenshotController screenshotController = ScreenshotController();
  // String urlForQr='${globals.API_URL}/index/index/';
  String urlForQr = '${globals.API_URL}/';
  List<dynamic> multipleDynamicFieldList = [];
  String offlineQrDataString = "";
  String vCardData = '';
  var vCard = VCard();

  void getSingleContactCardInfo() async {
    // setState(() {
    //   visibleBloc=true;
    // });

    // var url = '${globals.API_URL}/api/getCardInformation';
    var url = '${globals.API_URL}/download/${widget.slug}';
    var data = {
      "uuid": widget.uuid,
    };

    var request = http.Request(
        'GET',
        Uri.parse(
            'https://360smartbusinesscard.com/app/download/${widget.slug}'));

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      // print(await response.stream.bytesToString());
      offlineQrDataString = await response.stream.bytesToString();
      print('offline vcf $offlineQrDataString');
      vCardData = offlineQrDataString;
    } else {
      print(response.reasonPhrase);
    }

    // setState(() {
    //   visibleBloc=false;
    // });

    _dataBloc = DataBloc(
        dataRepository: DataRepository(
            dataApiClient: DataApiClient(
      url: url,
      data: data,
    )));
    // _dataBloc.add(FetchData());
  }

  Future<String> networkImageToBase64(String imageUrl) async {
    http.Response response = await http.get(imageUrl);
    final bytes = response.bodyBytes;
    return (bytes != null ? base64Encode(bytes) : '');
  }

  Future apiResponse(List<dynamic> responseData) async {
    var responseMap = responseData[0];

    print('offline qr response data:$responseMap');
  }

  @override
  void initState() {
    qrSwitchFlag = widget.qrSwitchFlag;
    getSingleContactCardInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Align(
            alignment: Alignment.topRight,
            child: InkWell(
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                padding: const EdgeInsets.all(10),
                child: Icon(Icons.close, color: Colors.indigo),
              ),
            ),
          ),
          visibleBloc == true
              ? Container(
            height: 350,
            child: Center(
              child: CircularProgressIndicator(
                backgroundColor: Theme.of(context).primaryColorDark,
              ),
            ),
          )
              : Container(
            width: 350,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
               /* Switch(
                  value: qrSwitchFlag,
                  onChanged: (val) {

                    setState(() {
                      print(val);
                      qrSwitchFlag = val;
                    });
                    // Add your logic here if needed
                  },
                ),*/
                Text(
                  qrSwitchFlag ? 'Online' : 'Offline',
                  style: Theme.of(context).textTheme.headline5.copyWith(
                    fontSize: 14,
                    color: Color(0xFF006ade),
                  ),
                ),
                SizedBox(height: 10),
                Screenshot(
                  controller: screenshotController,
                  child: Visibility(
                    visible: true, // Set to true to make it visible
                    child: Container(
                      color: Colors.white,
                      child: QrImageView(
                        data: qrSwitchFlag
                            ? '${globals.API_URL}/${widget.slug}'
                            : '${globals.API_URL}/${widget.slug}',
                        version: QrVersions.auto,
                        size: 200.0,
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        if(qrSwitchFlag){
                          screenshotController.capture().then((Uint8List bytes) async {
                            if (bytes != null) {
                              await _captureAndSavePng(bytes);
                            }
                          }).catchError((onError) {
                            print(onError);
                          });
                        }
                        // Respond to button press
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.blue, // Set the color for the SVG button
                      ),
                      child: Text('Download', style:
                      Theme.of(context).textTheme.headline1,),
                    ),
                  /*  ElevatedButton(
                      onPressed: () {

                        // Respond to button press
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.green, // Set the color for the PDF button
                      ),
                      child: Text('PDF', style:
                      Theme.of(context).textTheme.headline1,),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Respond to button press
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.orange, // Set the color for the Email button
                      ),
                      child: Text('Email', style:
                      Theme.of(context).textTheme.headline1,),
                    ),*/

                  ],
                ),
                SizedBox(height: 20,)
                /*TextButton(
                  onPressed: () async {

                    if(qrSwitchFlag){
                      screenshotController.capture().then((Uint8List bytes) async {
                        if (bytes != null) {
                          await _captureAndSavePng(bytes);
                        }
                      }).catchError((onError) {
                        print(onError);
                      });
                    }else{
                      await saveVCardToFile(vCardData, widget.slug);
                    }

                    // You can provide feedback to the user here if needed
                  },
                  child: Text(
                    'Download',
                    style:
                    Theme.of(context).textTheme.headline5.copyWith(
                      fontSize: 14,
                      color: Color(0xFF006ade),
                    ),
                  ),
                ),*/
              ],
            ),
          ),
        ],
      ),
    );
  }
  Future<void> _captureAndSavePng(Uint8List bytes) async {
    try{
      await ImageGallerySaver.saveImage(bytes);
      Fluttertoast.showToast(
          msg: "Saved qr code",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.blueGrey,
          textColor: Colors.white,
          fontSize: 16.0);
    }
    catch(e){
      ShowMessage.showToast("error in Qr:- ${e}");
    }


  }



  Future<void> saveVCardToFile(String vCardData, String fileName) async {
    try {
      Directory downloadsDirectory = Directory('/storage/emulated/0/Download');
      File file = File('${downloadsDirectory.path}/$fileName.vcf');
      await file.writeAsString(vCardData);

      Fluttertoast.showToast(
          msg: "$fileName.vsf saved successfully",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.blueGrey,
          textColor: Colors.white,
          fontSize: 16.0);

      // Provide feedback or handle the download completion as needed
      print('VCard saved to ${file.path}');
    } catch (e) {
      print('Error saving VCard: $e');
    }
  }



}

class LifecycleEventHandler extends WidgetsBindingObserver {
  final AsyncCallback resumeCallBack;
  final AsyncCallback suspendingCallBack;

  LifecycleEventHandler({
    this.resumeCallBack,
    this.suspendingCallBack,
  });

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.resumed:
        if (resumeCallBack != null) {
          await resumeCallBack();
        }
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
        if (suspendingCallBack != null) {
          await suspendingCallBack();
        }
        break;
    }
  }
}
