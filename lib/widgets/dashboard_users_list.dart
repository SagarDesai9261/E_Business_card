import 'package:async/async.dart';
import 'package:e_business_card/screens/login_screen.dart';
import 'package:e_business_card/util/show_message.dart';
import 'package:e_business_card/widgets/dashboard.dart';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:searchable_listview/searchable_listview.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as P;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:http/http.dart' as http;

import '../src/repositories/repositories.dart';
import '../src/bloc/blocs.dart';
import '../globals.dart' as globals;

class DashboardUsersList extends StatefulWidget {
  final database;
  final writeCardOnTap;
  final Function cardPopUpMenuOnTap;
  final nfcCardReading;
  // final cardPopUpMenuOnTap;
  DashboardUsersList(
      {this.cardPopUpMenuOnTap,
      this.writeCardOnTap,
      this.nfcCardReading,
      this.database});
  @override
  _DashboardUsersListState createState() => _DashboardUsersListState();
}

class _DashboardUsersListState extends State<DashboardUsersList> {
   Database database;
   List<Object> contactList;
  bool visibleBloc = false;
  bool visibleDeleteCardBloc = false;
   DataBloc _dataBloc;
  static const _pageSize = 10;
  var singleCardToBeDeleted;

  // final PagingController<int, Object> _pagingController =
  //     PagingController(firstPageKey: 0);

  void selectedMenuItem(BuildContext context, item, singleContact) {
    switch (item) {
      case 'View':
        widget.cardPopUpMenuOnTap(
          "View",
          singleContact['id'].toString(),
        );
        break;
      case 'Edit':
        print('edit call');
        widget.cardPopUpMenuOnTap("Edit", singleContact['id'].toString());
        break;
      case 'Write':
        globals.singleCardToWrite = singleContact;
        widget.cardPopUpMenuOnTap("Write", singleContact['id'].toString());
        break;
      case 'QR Code':
        widget.cardPopUpMenuOnTap("QR Code", singleContact['id'].toString(),
            singleContact: singleContact);
        break;
      case 'Delete':
        WidgetsBinding.instance
            .addPostFrameCallback((_) => showDeleteCardDialog(singleContact));
        break;
      case 'Generate PDF':
        widget.cardPopUpMenuOnTap("Generate PDF", singleContact['id'],
            singleContact: singleContact);
        break;
    }
  }

  //Delete card DialogBox
  Future<void> showDeleteCardDialog(singleContact) async {
    String businessId = singleContact['id'].toString();
    singleCardToBeDeleted = singleContact;

    print('delete card info$singleCardToBeDeleted');
    // return;

    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
          title: Text('Are You Sure You Want To Delete Card?',
              style: Theme.of(context).textTheme.headline2.copyWith(
                    fontWeight: FontWeight.normal,
                    color: Colors.black,
                  )),
          content: Container(
            // height: 110,
            width: 250,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text('This will delete Card information permanently.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .headline3
                        .copyWith(fontSize: 14)),
                // Text('Are You Sure You Want To Delete?',style:Theme.of(context).textTheme.headline6.copyWith(fontSize: 16)),
                // Padding(padding: EdgeInsets.all(5)),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Confirm'),
              onPressed: () {
                print('Confirmed');
                setState(() {
                  deleteCardApiCall(businessId);
                  Navigator.of(context).pop();
                });
              },
            ),
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                setState(() {
                  Navigator.of(context).pop();
                });
              },
            ),
          ],
        );
      },
    );
  }

  void deleteCardApiCall(String businessId) {
    visibleDeleteCardBloc = true;

    var url = '${globals.API_URL}/api/delete_business_card';
    var data = {
      'business_id': businessId,
      // "user_id": globals.USER_ID,
      // "csrf_token":globals.USER_TOKEN,
    };

    _dataBloc = DataBloc(
        dataRepository: DataRepository(
            dataApiClient: DataApiClient(
      url: url,
      data: data,
    )));
    _dataBloc.add(FetchData());
  }

  void getAllContactCardInfo() {
    visibleBloc = true;

    var url = '${globals.API_URL}/api/business_listing';
    var data = {
      "user_id": globals.USER_ID,
      // "csrf_token":globals.USER_TOKEN,
    };

    _dataBloc = DataBloc(
        dataRepository: DataRepository(
            dataApiClient: DataApiClient(
      url: url,
      data: data,
    )));
    _dataBloc.add(FetchData());
  }

  @override
  void initState() {
    super.initState();
    // _pagingController.addPageRequestListener((pageKey) {
    //   print("first page key:$pageKey");
    //   _fetchPage(pageKey);
    // });
    _fetchPage();
    // setState(() {
    //   getAllContactCardInfo();
    // });
  }

  Future apiResponse(List<Object> responseData) async {
    print('DashBoard List responce: $responseData');

    Map<String, Object> responseMap = responseData[0] as  Map<String, Object>;

    if (responseMap['status'] == 'Success') {
      Map<String, Object> data = responseMap['data'] as  Map<String, Object>;
      // contactList=data;
      contactList = data.entries.map((entry) => entry.value).toList();
      print("card List $contactList");

      setState(() {
        visibleBloc = false;
      });
    }
  }

  Future deleteCardApiCallResponse(List<Object> responseData) async {
    setState(() {
      print('api response data: ${responseData}');
      visibleDeleteCardBloc = false;
    });

    Map<String, Object> responseMap = responseData[0] as  Map<String, Object>;
    if (responseMap['message'].runtimeType == String) {
      ShowMessage().showSnack(responseMap['message'].toString(), context);
    } else {
      List<dynamic> messageList = responseMap['message'] as List<dynamic>;
      for (int i = 0; i < messageList.length; i++) {
        ShowMessage().showSnack(messageList[i], context);
      }
    }

    if (responseMap['status'].toString() == '1') {
      setState(() {
        // getAllContactCardInfo();
        // _pagingController.itemList.remove(singleCardToBeDeleted);
      });
    } else {}
  }

  // @override Unused Build method
  // Widget build_old(BuildContext context) {
  //
  //   print('Dashboard Card List:$contactList');
  //
  //   return visibleBloc==true||visibleDeleteCardBloc==true? BlocBuilder<DataBloc, UsersState>(
  //       bloc: _dataBloc,
  //       builder: (context, state) {
  //         if (state is UsersLoading) {
  //           return Center(
  //             child: CircularProgressIndicator(backgroundColor: Theme.of(context).primaryColorDark,),
  //           );
  //         }
  //         if (state is UsersLoaded) {
  //           if(visibleDeleteCardBloc)
  //             WidgetsBinding.instance.addPostFrameCallback((_) =>
  //                 deleteCardApiResponse(state.responseData));
  //           else
  //             WidgetsBinding.instance.addPostFrameCallback((_) =>
  //               apiResponse(state.responseData));
  //         }
  //         if (state is UsersError) {
  //           return Center(
  //             child: Column(
  //               mainAxisAlignment: MainAxisAlignment.center,
  //               children: [
  //                 Text('Something went Wrong, Lets Try Again..',
  //                   style: Theme.of(context).textTheme.headline6,
  //                 ),
  //                 TextButton(onPressed:(){
  //                   setState(() {
  //                     visibleBloc=false;
  //                     visibleDeleteCardBloc=false;
  //                   });
  //                 },
  //                   child: Text("Retry",
  //                     style: Theme.of(context).textTheme.headline2,
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           );
  //         }
  //         return Container();
  //       })
  //     :
  //   contactList!=null?
  //   // ListView.builder(
  //   //   padding: const EdgeInsets.only(bottom: 10),
  //   //   itemCount: contactList.length,
  //   //   itemBuilder: (BuildContext context,index){
  //   //     Map<String,Object> singleContact=contactList[index];
  //   //     return Card(
  //   //       margin: const EdgeInsets.only(left: 15,right: 15,top:10,),
  //   //       color:const Color(0xFFeef2fb),
  //   //       shape: RoundedRectangleBorder(
  //   //         borderRadius: BorderRadius.circular(18.0),
  //   //       ) ,
  //   //       child: ListTile(
  //   //         leading: Image.asset(index%2==0?'assets/images/name.png':'assets/images/name2.png'),
  //   //         title: Text("${singleContact['first_name']} ${singleContact['last_name']}",style: Theme.of(context).textTheme.headline5.copyWith(
  //   //           fontSize: 13
  //   //         ),),
  //   //         subtitle:Text(singleContact['position'],style: Theme.of(context).textTheme.headline5.copyWith(
  //   //             fontSize: 10
  //   //         )),
  //   //         dense: true,
  //   //         minVerticalPadding: 20,
  //   //         trailing:  Container(
  //   //           child: PopupMenuButton<String>(
  //   //             icon:Icon(Icons.more_vert),
  //   //             padding: EdgeInsets.only(left: 35),
  //   //             color: Colors.white,
  //   //             itemBuilder: (BuildContext context){
  //   //               return ['View','Edit','Write','QR Code','Delete'].map((String value){
  //   //                 return PopupMenuItem<String>(
  //   //                     value: value,
  //   //                     child:Text(value,style: TextStyle(color: Colors.black,fontFamily: 'Poppins'))
  //   //                 );
  //   //               }).toList();
  //   //             },
  //   //             // PopupMenuDivider(),
  //   //             onSelected: (item) => selectedMenuItem(context, item,singleContact['uuid']),
  //   //           ),
  //   //         ),
  //   //       ),
  //   //     );
  //   //   },
  //   // )
  //     Column(
  //       children: [
  //         ...contactList.map((value) {
  //           // print("Single Card In Listing :$value");
  //           Map<String,Object> singleContact=value;
  //           return Card(
  //             margin: const EdgeInsets.only(left: 15,right: 15,top:10,),
  //             color:const Color(0xFFeef2fb),
  //             shape: RoundedRectangleBorder(
  //               borderRadius: BorderRadius.circular(18.0),
  //             ) ,
  //             child: ListTile(
  //               // leading: Image.asset(2%2==0?'assets/images/name.png':'assets/images/name2.png'),
  //               leading:ClipRRect(
  //                 borderRadius: BorderRadius.circular(50),
  //                 child:FadeInImage.assetNetwork(
  //                   image:singleContact['user_avatar_link'],
  //                   placeholder: "assets/images/avatar_place_holder.png",
  //                   // height:50,
  //                   // width: 50,
  //                   fit: BoxFit.cover,
  //                   imageErrorBuilder: (ctx,obj,trak){
  //                     return Image.asset('assets/images/avatar_place_holder.png');
  //                    },
  //                   )
  //               ),
  //               title: Text("${singleContact['first_name']} ${singleContact['last_name']}",style: Theme.of(context).textTheme.headline5.copyWith(
  //                 fontSize: 13
  //               ),),
  //               subtitle:Text(singleContact['position'],style: Theme.of(context).textTheme.headline5.copyWith(
  //                   fontSize: 10
  //               )),
  //               dense: true,
  //               minVerticalPadding: 20,
  //               trailing:  Container(
  //                 child: PopupMenuButton<String>(
  //                   icon:Icon(Icons.more_vert),
  //                   padding: EdgeInsets.only(left: 35),
  //                   color: Colors.white,
  //                   itemBuilder: (BuildContext context){
  //                     return ['View','Edit','Write','QR Code','Delete','Generate PDF'].map((String value){
  //                       return PopupMenuItem<String>(
  //                           value: value,
  //                           child:Text(value,style: TextStyle(color: Colors.black,fontFamily: 'Poppins'))
  //                       );
  //                     }).toList();
  //                   },
  //                   // PopupMenuDivider(),
  //                   onSelected: (item) => selectedMenuItem(context, item,singleContact['uuid']),
  //                 ),
  //               ),
  //             ),
  //           );
  //         }).toList(),
  //         Padding(padding: EdgeInsets.only(bottom: 8))
  //       ],
  //     )
  //       :Container();
  // }

  Future<void> _fetchPage() async {
    // print("pageKey in fetch:$pageKey");
    List<Object> fetchData = [];
    var url = '${globals.API_URL}/api/business_listing';
    var data = {
      "user_id": globals.USER_ID,
      // "csrf_token":globals.USER_TOKEN,
      // "limit":"10",
      // "offset":"$pageKey"
    };
    try {
      // http.Response response = await http.post(url, body:data);
      // var responseData = json.decode(response.body);
      // print("dashboard new listing :$responseData");
      // fetchData.add(responseData);
      _dataBloc = DataBloc(
          dataRepository: DataRepository(
              dataApiClient: DataApiClient(data: data, url: url)));
      fetchData = await _dataBloc.dataRepository.dataApiClient.fetchData();

      Map<String, Object> responseMap = fetchData[0] as  Map<String, Object>;
      if (responseMap['status'] == '1') {
        print("Response  is $responseMap");
        var data = responseMap['result'];

        setState(() {
          contactList = data as List<Object>;
        });

        // contactList= data.entries.map( (entry) => entry.value).toList();
        // print("card List ${contactList.runtimeType}");
      } else {
        ShowMessage().showSnack('Token expired', context);
        logout();
        return;
      }

      bool isLastPage = contactList.length < _pageSize;

      isLastPage = true; //to add once in list

      //   if (_pagingController.itemList != null) {
      //     if (_pagingController.itemList.length + 10 >=
      //         responseMap['total_result']) isLastPage = true;
      //   }

      //   if (isLastPage) {
      //     _pagingController.appendLastPage(contactList);
      //   } else {
      //     final nextPageKey = pageKey + contactList.length;
      //     _pagingController.appendPage(contactList, nextPageKey);
      //   }
    } catch (error) {
      // _pagingController.error = error;
      print("pageController error:$error");
    }
  }

  @override
  Widget build(BuildContext context) {
    // print("dashboard list data:$contactList");
    return visibleDeleteCardBloc
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
                if (visibleDeleteCardBloc)
                  WidgetsBinding.instance.addPostFrameCallback(
                      (_) => deleteCardApiCallResponse(state.responseData));
                else
                  WidgetsBinding.instance.addPostFrameCallback(
                      (_) => apiResponse(state.responseData));
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
                            // visibleBloc=false;
                            visibleDeleteCardBloc = false;
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
        : Column(
            children: [
              Dashboard(
                nfcCardReading: widget.nfcCardReading,
                writeCardOnTap: widget.writeCardOnTap,
                database: widget.database,
                cardPopUpMenuOnTap: widget.cardPopUpMenuOnTap,
              ),
              Expanded(
                  child: Container(
                margin: const EdgeInsets.only(
                  left: 15,
                  right: 15,
                  top: 10,
                ),
                child: contactList != null
                    ? SearchableList<Object>(
                        initialList: contactList,
                        defaultSuffixIconColor: Colors.white,
                        builder: (Object user) {
                          Map<String, Object> singleContact = user as Map<String, Object>;

                          return Padding(
                              padding: EdgeInsets.only(top: 10),
                              child: Card(
                                color: const Color(0xFFeef2fb),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                ),
                                child: ListTile(
                                  // leading: Image.asset(2%2==0?'assets/images/name.png':'assets/images/name2.png'),
                                  leading: ClipRRect(
                                      borderRadius: BorderRadius.circular(50),
                                      child: FadeInImage.assetNetwork(
                                        image:
                                            "${singleContact['logo'].toString()}",
                                        placeholder:
                                            "assets/images/avatar_place_holder.png",
                                        height: 50,
                                        width: 50,
                                        fit: BoxFit.fill,
                                        imageErrorBuilder: (ctx, obj, trak) {
                                          return Image.asset(
                                              'assets/images/avatar_place_holder.png');
                                        },
                                      )),
                                  title: Text(
                                    "${singleContact['title']}",
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline5
                                        .copyWith(fontSize: 13),
                                  ),
                                  subtitle: Text(singleContact['designation'].toString(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline5
                                          .copyWith(fontSize: 10)),
                                  dense: true,
                                  minVerticalPadding: 20,
                                  trailing: Container(
                                    child: PopupMenuButton<String>(
                                      icon: Icon(Icons.more_vert, color: Colors.blue,),
                                      padding: EdgeInsets.only(left: 35),
                                      color: Colors.white,
                                      itemBuilder: (BuildContext context) {
                                        return [
                                          'View',
                                          'Edit',
                                          'Write',
                                          'QR Code',
                                          'Delete'
                                        ].map((String value) {
                                          return PopupMenuItem<String>(
                                              value: value,
                                              child: Text(value,
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontFamily: 'Poppins')));
                                        }).toList();
                                      },
                                      // PopupMenuDivider(),
                                      onSelected: (item) => selectedMenuItem(
                                          context, item, singleContact),
                                    ),
                                  ),
                                ),
                              ));
                        },
                        filter: (value) => contactList.where((element) {
                              Map<String, Object> singleitem = element as Map<String, Object>;
                              return singleitem["title"]
                                  .toString()
                                  .toLowerCase()
                                  .contains(value);
                            }).toList(),
                        emptyWidget: Center(child: Text("No Contacts Found")),
                        inputDecoration: InputDecoration(
                          enabled: true,
                          icon: null,
                          hintText: "Search",
                          prefixIcon: Icon(Icons.search),
                          fillColor: Colors.white,
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.blue,
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),)
                        //sliverScrollEffect: true)
                    : SizedBox(),
              )),
            ],
          );
  }

  Future logout() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString("user_login", "logout");
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => LoginScreen()));
  }

  @override
  void dispose() {
    // _pagingController.dispose();
    super.dispose();
  }
}
