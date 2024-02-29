import 'dart:convert';
import 'dart:typed_data';

import 'package:e_business_card/util/show_message.dart';
import 'package:e_business_card/widgets/write_screen_top_part.dart';
import 'package:e_business_card/widgets/write_user_profile_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:http/http.dart' as http;
import 'package:searchable_listview/searchable_listview.dart';

import '../modals/sql_manager.dart';
import '../src/repositories/repositories.dart';
import '../src/bloc/blocs.dart';
import '../globals.dart' as globals;

class WriteScreen extends StatefulWidget {
  final selectUserId;
  final writeNfcCardDialog;
  WriteScreen({this.selectUserId, this.writeNfcCardDialog});
  @override
  _WriteScreenState createState() => _WriteScreenState();
}

class _WriteScreenState extends State<WriteScreen> {
  SqlManager sqlManager;
  // List<Map> contactList;
  bool listImageFlag = false;

  String selectUserId;
  List<Object> contactList;
  bool visibleBloc = false;
  DataBloc _dataBloc;
  String dataSize = "0";
  static const _pageSize = 10;

  final PagingController<int, Object> _pagingController =
      PagingController(firstPageKey: 0);

  //
  // Future<void> showContacts()async{
  //   var databasesPath = await getDatabasesPath();
  //   String dbPath = P.join(databasesPath, 'nfcsmartcard.db');
  //   database= await openDatabase(dbPath);
  //
  //   print('show client call:$database');
  //   if(database!=null) {
  //     if (database.isOpen) {
  //       contactList = await database.rawQuery('SELECT * FROM contacts');
  //       setState(() {
  //         print('Contact list map :${contactList[0]['name']}');
  //       });
  //     }
  //   }
  // }

  void getAllContactCardInfo() {
    visibleBloc = true;

    var url = '${globals.API_URL}/api/getAllCardsInformation';
    var data = {
      "user_id": globals.USER_ID,
      "csrf_token": globals.USER_TOKEN,
    };

    _dataBloc = DataBloc(
        dataRepository: DataRepository(
            dataApiClient: DataApiClient(
      url: url,
      data: data,
    )));
    _dataBloc.add(FetchData());
  }

  Future apiResponse(List<Object> responseData) async {
    print('DashBoard List responce: $responseData');

    Map<String, Object> responseMap = responseData[0];

    if (responseMap['status'] == 'Success') {
      Map<String, Object> data = responseMap['data'];
      // contactList=data;
      contactList = data.entries.map((entry) => entry.value).toList();

      setState(() {
        visibleBloc = false;
      });
    }
  }
  // @override
  // void initState() {
  //   super.initState();
  //   sqlManager=SqlManager.instance;
  //   fetchData();
  // }
  //
  // void fetchData()async{
  //   List<Map> list= await sqlManager.selectAllRecords();
  //   setState(() {
  //     contactList=list;
  //   });
  // }

  void writeScreenUserCardOnTap(Map<String, Object> singleContact) {
    print('User id: ${singleContact['id']}');

    //calculate write Data size
    String writeData =
        "${globals.API_URL}/index/index/${singleContact['title']}";
    List<int> bytes = utf8.encode(writeData);
    print("Write Data size in byetes:${bytes.length}");
    setState(() {
      selectUserId = singleContact['id'].toString();
      listImageFlag = !listImageFlag;
      globals.singleCardToWrite = singleContact;
      dataSize = bytes.length.toString();
    });
  }

  void writeSpacialCardOnTap() {
    setState(() {
      selectUserId = "";
      listImageFlag = !listImageFlag;
      globals.singleCardToWrite = null;
    });
    print('selected user id: $selectUserId');
    print("single Card to write: ${globals.singleCardToWrite}");
  }

  @override
  void initState() {
    super.initState();
    // setState(() {
    //   getAllContactCardInfo();
    // });
    // _pagingController.addPageRequestListener((pageKey) {
    //   print("first page key:$pageKey");
    _fetchPage();
    // });

    if (widget.selectUserId == null) globals.singleCardToWrite = null;

    if (widget.selectUserId != null) {
      setState(() {
        selectUserId = widget.selectUserId;
      });
      writeScreenUserCardOnTap(globals.singleCardToWrite);
      WidgetsBinding.instance
          .addPostFrameCallback((_) => widget.writeNfcCardDialog(context));
      // widget.writeNfcCardDialog(context);
    }
  }

  // @override unused build method
  Widget build_old(BuildContext context) {
    print("Write Screen contactList: $contactList");

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
                            getAllContactCardInfo();
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
              height: constraints.maxHeight,
              width: constraints.maxWidth,
              child: ListView(
                children: [
                  WriteScreenTopPart(dataSize: dataSize),
                  if (contactList != null)
                    ...contactList.map((singleCard) {
                      Map<String, Object> singleContact =
                          singleCard as Map<String, Object>;
                      print("singleContact: ${singleContact}");
                      listImageFlag = !listImageFlag;
                      if (singleContact['uuid'] == selectUserId) {
                        globals.singleCardToWrite = singleContact;
                        return WriteUserProfileCard(
                          constraints: constraints,
                          singleContact: singleContact,
                          writeSpacialCardOnTap: writeSpacialCardOnTap,
                          listImageFlag: listImageFlag,
                        );
                      }
                      return Container(
                        width: constraints.maxWidth,
                        height: 80,
                        alignment: Alignment.center,
                        margin:
                            const EdgeInsets.only(top: 5, bottom: 5, left: 20),
                        // decoration: BoxDecoration(color: Colors.black),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              children: [
                                Container(
                                  width: 15,
                                  height: 15,
                                  decoration: BoxDecoration(
                                      color: Colors.grey,
                                      borderRadius: BorderRadius.circular(15)),
                                ),
                                Container(
                                    height: 65,
                                    child: VerticalDivider(
                                      width: 2,
                                      color: Colors.grey,
                                      thickness: 2,
                                      endIndent: 10,
                                      indent: 5,
                                    )),
                              ],
                            ),
                            InkWell(
                              onTap: () =>
                                  writeScreenUserCardOnTap(singleContact),
                              child: Container(
                                width: constraints.maxWidth - 35,
                                child: Card(
                                  margin: const EdgeInsets.only(
                                    left: 15,
                                    right: 15,
                                  ),
                                  color: const Color(0xFFeef2fb),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                  ),
                                  child: ListTile(
                                    // leading: Image.asset(listImageFlag?'assets/images/name.png':'assets/images/name2.png'),
                                    leading: ClipRRect(
                                        borderRadius: BorderRadius.circular(50),
                                        child: FadeInImage.assetNetwork(
                                          image:
                                              singleContact['user_avatar_link'],
                                          placeholder:
                                              "assets/images/avatar_place_holder.png",
                                          // height:50,
                                          // width: 50,
                                          fit: BoxFit.cover,
                                        )),
                                    title: Text(
                                      "${singleContact['first_name']} ${singleContact['last_name']}",
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline5
                                          .copyWith(fontSize: 13),
                                    ),
                                    subtitle: Text(
                                      singleContact['position'],
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline5
                                          .copyWith(fontSize: 10),
                                    ),
                                    dense: true,
                                    minVerticalPadding: 20,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                ],
              ),
            );
          });
  }

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
        dataRepository:
            DataRepository(dataApiClient: DataApiClient(data: data, url: url)),
      );
      fetchData = await _dataBloc.dataRepository.dataApiClient.fetchData();

      Map<String, Object> responseMap = fetchData[0];
      if (responseMap['status'] == '1') {
        print("Response  is $responseMap");
        var data = responseMap['result'];

        setState(() {
          contactList = data;
        });

        // contactList= data.entries.map( (entry) => entry.value).toList();
        // print("card List ${contactList.runtimeType}");
      } else {
        ShowMessage().showSnack('Token expired', context);
        // logout();
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
    print("write screen list data:$contactList");
    return LayoutBuilder(
        builder: (BuildContext ctx, BoxConstraints constraints) {
      return Container(
        height: constraints.maxHeight,
        margin: EdgeInsets.only(right: 10, left: 10),
        child: Column(
          children: [
            Container(
                // height: constraints.maxHeight*0.15,
                child: WriteScreenTopPart(dataSize: dataSize)),
            contactList != null
                ? Flexible(
                    child: Container(
                      // margin: const EdgeInsets.only(
                      //   top: 5,
                      //   bottom: 5,
                      //   left: 20,
                      //   right: 20,
                      // ),
                      child: SearchableList<Object>(
                          filter: (value) => contactList.where((element) {
                                Map<String, Object> singleitem = element;
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
                          ),
                          //sliverScrollEffect: true,
                          initialList: contactList,
                          defaultSuffixIconColor: Colors.white,
                          builder: (Object user) {
                            // itemBuilder: (context, item, index) {
                            // print("Write Screen items in Pagination ListView: ${item}");
                            Map<String, Object> singleContact = user;

                            print("singleContact: ${singleContact}");
                            listImageFlag = !listImageFlag;
                            if (singleContact['id'].toString() ==
                                selectUserId) {
                              globals.singleCardToWrite = singleContact;
                              return WriteUserProfileCard(
                                constraints: constraints,
                                singleContact: singleContact,
                                writeSpacialCardOnTap: writeSpacialCardOnTap,
                                listImageFlag: listImageFlag,
                              );
                            } else {
                              return Container(
                                width: double.infinity,
                                height: 80,
                                alignment: Alignment.center,
                                margin: EdgeInsets.only(
                                  top: 10,
                                ),
                                // decoration: BoxDecoration(color: Colors.black),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Column(
                                      children: [
                                        Container(
                                          width: 15,
                                          height: 15,
                                          decoration: BoxDecoration(
                                              color: Colors.grey,
                                              borderRadius:
                                                  BorderRadius.circular(15)),
                                        ),
                                        Container(
                                            height: 65,
                                            child: VerticalDivider(
                                              width: 2,
                                              color: Colors.grey,
                                              thickness: 2,
                                              endIndent: 10,
                                              indent: 5,
                                            )),
                                      ],
                                    ),
                                    InkWell(
                                      onTap: () => writeScreenUserCardOnTap(
                                          singleContact),
                                      child: Container(
                                        width: constraints.maxWidth - 35,
                                        child: Card(
                                          margin: const EdgeInsets.only(
                                            left: 15,
                                            right: 15,
                                          ),
                                          color: const Color(0xFFeef2fb),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(18.0),
                                          ),
                                          child: ListTile(
                                            // leading: Image.asset(listImageFlag?'assets/images/name.png':'assets/images/name2.png'),
                                            leading: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(50),
                                                child: FadeInImage.assetNetwork(
                                                  image: singleContact['logo']
                                                      .toString(),
                                                  placeholder:
                                                      "assets/images/avatar_place_holder.png",
                                                  imageErrorBuilder:
                                                      (ctx, obj, trak) {
                                                    return Image.asset(
                                                        'assets/images/avatar_place_holder.png');
                                                  },
                                                  height: 50,
                                                  width: 50,
                                                  fit: BoxFit.fill,
                                                )),
                                            title: Text(
                                              "${singleContact['title']}",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline5
                                                  .copyWith(fontSize: 13),
                                            ),
                                            subtitle: Text(
                                              singleContact['designation'],
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline5
                                                  .copyWith(fontSize: 10),
                                            ),
                                            dense: true,
                                            minVerticalPadding: 20,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                              //    };
                            }
                          }),
                    ),
                  )
                : SizedBox()
          ],
        ),
      );
    });
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }
}
