import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_business_card/widgets/read_write_card.dart';
import 'package:e_business_card/widgets/webview_widget2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:bloc/bloc.dart';

import './dashboard_users_list.dart';
import '../globals.dart' as globals;
import '../src/bloc/blocs.dart';
import '../src/repositories/repositories.dart';

class Dashboard extends StatefulWidget {
  final database;
  final writeCardOnTap;
  final cardPopUpMenuOnTap;
  final nfcCardReading;
  Dashboard(
      {this.database,
      this.writeCardOnTap,
      this.cardPopUpMenuOnTap,
      this.nfcCardReading});
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  String firstUsername = "User Name";
  bool visibleBloc = false;
  DataBloc _dataBloc;
  String browsUrl;

  Future<void> selectFirstRecord() async {
    if (widget.database != null) {
      if (widget.database.isOpen) {
        List<Map> contactList =
            await widget.database.rawQuery('SELECT * FROM contacts LIMIT 1');
        setState(() {
          if (contactList.length != 0) firstUsername = contactList[0]['name'];
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      selectFirstRecord();
    });
    print("name :" + firstUsername);
  }

  Future<void> _QRCodeScanner(BuildContext context) async {
    String barcodeScanResUUID = await FlutterBarcodeScanner.scanBarcode(
      "#aa6598",
      "Cancel",
      true,
      ScanMode.QR,
    );

    print('Scanned QR code String: $barcodeScanResUUID');

    if (barcodeScanResUUID != "-1") {
      // setState(() {
      // getSingleContactCardInfo(barcodeScanResUUID);
      browsUrl = "$barcodeScanResUUID"; //URL of profile
      if (Platform.isIOS) _launchURL();
      if (Platform.isAndroid) {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => WebViewWidget2(
                  webViewUrl: browsUrl,
                )));
        return;
      }
      // });
    }
    Navigator.of(context).pop();
  }

  void getSingleContactCardInfo(String uuid) {
    visibleBloc = true;

    var url = '${globals.API_URL}/api/getCardInformation';
    var data = {
      "uuid": uuid,
    };

    _dataBloc = DataBloc(
        dataRepository: DataRepository(
            dataApiClient: DataApiClient(
      url: url,
      data: data,
    )));
    _dataBloc.add(FetchData());
  }

  Future getSingleContactCardApiResponse(List<Object> responseData) async {
    // print('single Card responce: $responseData');

    Map<String, Object> responseMap = responseData[0] as Map<String, Object>;

    if (responseMap['status'] == 'Success') {
      Map<String, Object> data = responseMap['data'] as Map<String, Object> ;
      // print("mobile1 type: ${data['mobile1'].runtimeType}");

      print("whole data:${data}");
      print("data['profilename']:${data['profile_name']}");
      browsUrl = "${globals.API_URL}/index/index/${data['profile_name']}";
      if (Platform.isIOS) _launchURL();
      if (Platform.isAndroid) {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => WebViewWidget2(
                  webViewUrl: browsUrl,
                )));
        return;
      }
    } else {
      String message = responseMap['message'].toString();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          duration: const Duration(seconds: 3),
        ),
      );
    }
    setState(() {
      visibleBloc = false;
    });
  }

  void _launchURL() async => await canLaunch(
        browsUrl.toString(),
      )
          ? await launch(browsUrl.toString())
          : throw 'Could not launch $browsUrl';

  @override
  Widget build(BuildContext context) {
    print("Primary image url: ${globals.primaryImage}");

    return visibleBloc == true
        ? BlocBuilder<DataBloc, UsersState>(
            bloc: _dataBloc,
            builder: (context, state) {
              if (state is UsersLoading) {
                return Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Theme.of(context).primaryColorDark,
                  ),
                );
              }
              if (state is UsersLoaded) {
                WidgetsBinding.instance.addPostFrameCallback(
                    (_) => getSingleContactCardApiResponse(state.responseData));
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
                            visibleBloc = false;
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
        : LayoutBuilder(
            builder: (BuildContext ctx, BoxConstraints constraints) {
            return Container(
              // width: constraints.maxWidth,
              // height: constraints.maxHeight*0.3,
              child:
                  // 1==1?   DashboardUsersList(cardPopUpMenuOnTap: widget.cardPopUpMenuOnTap,):
                  Column(
                // primary: false,
                // shrinkWrap: true,
                children: [
                  Container(
                    // height:constraints.maxHeight*0.1,
                    // width: double.infinity,
                    child: Row(
                      children: [
                        const SizedBox(
                          width: 20,
                        ),
                        ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: FadeInImage.assetNetwork(
                              image: globals.primaryImage,
                              placeholder: "assets/images/profile.png",
                              height: 60,
                              width: 60,
                              imageErrorBuilder: (ctx, obj, trak) {
                                return Image.asset(
                                  'assets/images/profile.png',
                                  height: 60,
                                  width: 60,
                                );
                              },
                              fit: BoxFit.cover,
                            )
                            // CachedNetworkImage(
                            //   height: 60,
                            //   width: 60,
                            //   fit:BoxFit.cover,
                            //   imageUrl:globals.primaryImage,
                            //   placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                            //   errorWidget: (context, url, error) => Icon(Icons.error),
                            // )
                            ),
                        // Image.asset('assets/images/profile.png',height: 60,width: 60,),
                        const SizedBox(
                          width: 20,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'Hi, ',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline3
                                      .copyWith(
                                          fontSize: 18, color: Colors.black),
                                ),
                                Text(
                                    globals.USER_NAME
                                    // globals.primaryName!=null?globals.primaryName:""
                                    ,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline4
                                        .copyWith(
                                            color: Colors.black, fontSize: 16))
                              ],
                            ),
                            Text(
                              'Welcome Back',
                              style: Theme.of(context)
                                  .textTheme
                                  .headline5
                                  .copyWith(fontSize: 10),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(
                        left: 20, top: 20, right: 20, bottom: 10),
                    // height:constraints.maxHeight*0.11,
                    // width: double.infinity,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Digital BusinessCard',
                      style: Theme.of(context)
                          .textTheme
                          .headline5
                          .copyWith(color: Colors.black, fontSize: 20),
                    ),
                  ),
                  Container(
                    // height:constraints.maxHeight*0.30,
                    // width: double.infinity,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          SizedBox(
                            width: constraints.maxWidth * 0.01,
                          ),
                          ReadWriteCard(
                              constraints: constraints,
                              imagePath: 'assets/images/read_bg1.png',
                              textOnCard: 'Read',
                              readCardHandler: widget.nfcCardReading,
                              QRCodeScanner: _QRCodeScanner
                              // cardTapHandler: readCardTap(ctx),
                              ),
                          ReadWriteCard(
                            constraints: constraints,
                            imagePath: 'assets/images/write_bg1.png',
                            textOnCard: 'Write',
                            cardTapHandler: widget.writeCardOnTap,
                          ),
                          SizedBox(
                            width: constraints.maxWidth * 0.01,
                          ),
                        ]),
                  ),

                  // DashboardUsersList(cardPopUpMenuOnTap: widget.cardPopUpMenuOnTap,),
                  // Expanded(
                  //   // height:constraints.maxHeight*0.49,
                  //   // width: double.infinity,
                  //   child:DashboardUsersList(cardPopUpMenuOnTap: widget.cardPopUpMenuOnTap,)
                  // ),
                ],
              ),
            );
          });
  }
}
