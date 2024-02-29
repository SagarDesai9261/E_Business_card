import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../src/bloc/Data_Bloc.dart';
import '../src/bloc/Data_Events.dart';
import '../src/bloc/Data_State.dart';
import '../src/repositories/DataApiClient.dart';
import '../src/repositories/Data_Repository.dart';
import '../globals.dart' as globals;

class AppointmentsScreen extends StatefulWidget {
  const AppointmentsScreen({Key key}) : super(key: key);

  @override
  State<AppointmentsScreen> createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends State<AppointmentsScreen> {
  TextEditingController notecontroller = TextEditingController();
  bool pending = true;
  bool completed = false;
  bool editdone = false;
  bool emptyDataFlag = false;
  bool deletedone = false;
  DataBloc _dataBloc;
  bool visibleBloc = false;
  List<dynamic> appointmentlist = [];

  void getAllContactCardInfo() {
    visibleBloc = true;

    var url = '${globals.API_URL}/api/all_appointment_list';

    _dataBloc = DataBloc(
        dataRepository: DataRepository(
            dataApiClient: DataApiClient(
      url: url,
    )));
    _dataBloc.add(FetchData());
    setState(() {
      editdone = false;
      deletedone = false;
    });
  }

  Future<bool> deleteconfirmation(BuildContext context, String id) async {
    return (await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        title: Text(
          'Do you want to Delete?',
          style: Theme.of(context).textTheme.bodyText2,
        ),
        content: Text(
          'Are You Sure?',
          style: Theme.of(context).textTheme.bodyText2.copyWith(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
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
              Navigator.of(context).pop(false);
              deleteappointment(id: id);
            },
            child: Text('Yes'),
          ),
        ],
      ),
    )) ??
        false;
  }

  /*Future<bool> deleteconfirmation(BuildContext context, String id) {
    return showDialog(
          context: context,
          builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0)),
            title: Text(
              'Do you want to Delete?',
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
                  Navigator.of(context).pop(false);

                  deleteappointment(id: id);
                  // logout();
                },
                child: Text('Yes'),
              ),
            ],
          ),
        ) ??
        false;
  }*/

  Future getAllCardApiResponse(List<Object> responseData) async {
    print('Main Screen List responce: $responseData');
    setState(() {
      visibleBloc = false;
    });

    Map<String, Object> responseMap = responseData[0] as Map<String, Object>;
    if (responseMap['status'] == '1') {
      appointmentlist = responseMap['result'] as List<dynamic>;
    } else {
      return;
    }
  }

  @override
  void initState() {
    getAllContactCardInfo();
    super.initState();
  }

  void editappointment({
    @required String id,
  }) {
    setState(() {
      visibleBloc = true;
    });
    var url = '${globals.API_URL}/api/add_appointment_status_note';
    var data = {
      "appointment_id": id,
      "status": pending == true ? "0" : "1",
      "note": notecontroller.text,
    };

    _dataBloc = DataBloc(
        dataRepository: DataRepository(
            dataApiClient: DataApiClient(
      url: url,
      data: data,
    )));
    _dataBloc.add(FetchData());
    setState(() {
      editdone = true;
    });
  }

  void deleteappointment({
    @required String id,
  }) {
    setState(() {
      visibleBloc = true;
    });
    var url = '${globals.API_URL}/api/delete_appointment';
    var data = {
      "appointment_id": id,
    };

    _dataBloc = DataBloc(
        dataRepository: DataRepository(
            dataApiClient: DataApiClient(
      url: url,
      data: data,
    )));
    _dataBloc.add(FetchData());
    setState(() {
      deletedone = true;
    });
  }

  Future apiResponse(List<Object> responseData) async {
    print("Calling");
    setState(() {
      print('api response data: $responseData');
      visibleBloc = false;
    });

    Map<String, dynamic> responseMap = responseData[0] as Map<String, dynamic>;

    if (responseMap['status'].toString() == '1') {
      setState(() {
        appointmentlist = responseMap['result'];
      });
      if (responseMap['message'].runtimeType == String) {
      } else {
        List<Object> messageList = responseMap['message'];
        for (int i = 0; i < messageList.length; i++) {}
      }
      setState(() {});
      if (emptyDataFlag) {
        print("emptydata flag:$emptyDataFlag");
        setState(() {
          getAllContactCardInfo();
        });
      }
      emptyDataFlag =
          false; //when first record is inserted user can click on home icon
    }

    print('userid: ${globals.USER_ID}');
    print('token : ${globals.USER_TOKEN}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60.0),
        child: AppBar(
          systemOverlayStyle: SystemUiOverlayStyle.dark,
          automaticallyImplyLeading: false,
          title: Image.asset(
            'assets/images/logo.png',
            height: 210,
            width: 210,
          ),
          centerTitle: false,
        ),
      ),
      body: visibleBloc
          ?   BlocBuilder<DataBloc, UsersState>(
              bloc: _dataBloc,
              builder: (context, state) {
                print(state);
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
                  else
                    WidgetsBinding.instance.addPostFrameCallback(
                        (_) => getAllCardApiResponse(state.responseData));
                  if (editdone) {
                    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                      getAllContactCardInfo();
                    });
                    if (deletedone) {
                      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                        getAllContactCardInfo();
                      });
                    }
                  }
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
                              if (visibleBloc) getAllContactCardInfo();
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
          : Container(
              margin: const EdgeInsets.all(15),
              child: appointmentlist.isEmpty
                  ? Center(
                      child: Text(
                        "No Pending Appointments Found",
                        style: Theme.of(context).textTheme.headline6,
                      ),
                    )
                  :
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Appointments",
                        style:
                        Theme.of(context).textTheme.headline2.copyWith(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        )),
                    SizedBox(
                      height: 20,
                    ),
                    ListView.separated(
                        separatorBuilder: (context, sp) {
                          return SizedBox(
                            height: 20,
                          );
                        },
                        shrinkWrap: true,
                        primary: false,
                        itemCount: appointmentlist.length,
                        itemBuilder: (context, index) {
                          var singleItem = appointmentlist[index];

                          double width = MediaQuery.of(context).size.width;
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            clipBehavior: Clip.antiAlias,
                            child: Theme(
                              data: Theme.of(context).copyWith(
                                  dividerColor: Colors.transparent),
                              child: ExpansionTile(
                                collapsedBackgroundColor: Color(0xFFeef2fb),
                                title: Row(
                                  children: [
                                    Text(
                                      singleItem["date"],
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1
                                          .copyWith(color: Colors.black),
                                    ),
                                    Spacer(),
                                    Text(
                                      singleItem['time'],
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1,
                                    ),
                                  ],
                                ),
                                childrenPadding: EdgeInsets.all(15),
                                children: [
                                  Container(
                                    height:
                                    MediaQuery.of(context).size.height *
                                        0.2,
                                    child: Row(
                                      children: [
                                        Column(
                                          mainAxisAlignment:
                                          MainAxisAlignment.start,
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            titlesubtiletext(
                                                context: context,
                                                width: width,
                                                subtext:
                                                singleItem["title"],
                                                text: "Business Name"),
                                            Spacer(),
                                            titlesubtiletext(
                                                context: context,
                                                width: width,
                                                subtext:
                                                singleItem["email"],
                                                text: "Email"),
                                            Spacer(),
                                            titlesubtiletext(
                                                context: context,
                                                width: width,
                                                subtext: singleItem["name"],
                                                text: "Name"),
                                            Spacer(),
                                            titlesubtiletext(
                                                context: context,
                                                width: width,
                                                subtext:
                                                singleItem["phone"],
                                                text: "Phone No."),
                                            Spacer(),
                                            titlesubtiletext(
                                                context: context,
                                                width: width,
                                                subtext:
                                                singleItem["status"],
                                                text: "Status"),
                                          ],
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "Actions:",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium
                                                  .copyWith(
                                                  fontWeight:
                                                  FontWeight.w600,
                                                  fontSize: 15),
                                            ),
                                            Row(
                                              children: [
                                                InkWell(
                                                  onTap: () {
                                                    showDialog(
                                                        context: context,
                                                        builder: (context) {
                                                          return StatefulBuilder(
                                                              builder:
                                                              ((context,
                                                                  setState) {
                                                                return Builder(
                                                                    builder:
                                                                        (context) {
                                                                      double width =
                                                                          MediaQuery.of(
                                                                              context)
                                                                              .size
                                                                              .width;

                                                                      return AlertDialog(
                                                                        contentPadding:
                                                                        EdgeInsets.all(
                                                                            10),
                                                                        shape:
                                                                        RoundedRectangleBorder(
                                                                          borderRadius:
                                                                          BorderRadius
                                                                              .circular(
                                                                            20,
                                                                          ),
                                                                        ),
                                                                        content:
                                                                        Container(
                                                                          width:
                                                                          width *
                                                                              0.8,
                                                                          //  height: height * 0.4,
                                                                          margin: EdgeInsets
                                                                              .all(
                                                                              10),
                                                                          child:
                                                                          Column(
                                                                            mainAxisSize:
                                                                            MainAxisSize.min,
                                                                            crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                            children: [
                                                                              Text(
                                                                                "Status",
                                                                                style: Theme.of(context).textTheme.headline1.copyWith(
                                                                                    fontWeight: FontWeight.w500,
                                                                                    color: Colors.black,
                                                                                    fontSize: 17),
                                                                              ),
                                                                              Row(
                                                                                children: [
                                                                                  Checkbox(
                                                                                      fillColor: MaterialStateProperty.all(Colors.blueAccent),
                                                                                      value: pending,
                                                                                      onChanged: (value) {
                                                                                        setState(
                                                                                              () {
                                                                                            pending = value;
                                                                                            if (completed == false) {
                                                                                              completed = true;
                                                                                            } else if (completed == true) {
                                                                                              completed = false;
                                                                                            }
                                                                                          },
                                                                                        );
                                                                                      }),
                                                                                  Text(
                                                                                    "Pending",
                                                                                    style: Theme.of(context).textTheme.headline6,
                                                                                  )
                                                                                ],
                                                                              ),
                                                                              Row(
                                                                                children: [
                                                                                  Checkbox(
                                                                                      fillColor: MaterialStateProperty.all(Colors.blueAccent),
                                                                                      value: completed,
                                                                                      onChanged: (value) {
                                                                                        setState(
                                                                                              () {
                                                                                            completed = value;
                                                                                            if (pending == false) {
                                                                                              pending = true;
                                                                                            } else if (pending == true) {
                                                                                              pending = false;
                                                                                            }
                                                                                          },
                                                                                        );
                                                                                      }),
                                                                                  Text(
                                                                                    "Completed",
                                                                                    style: Theme.of(context).textTheme.headline6,
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                              Text(
                                                                                "Add Note",
                                                                                style: Theme.of(context).textTheme.headline1.copyWith(
                                                                                    fontWeight: FontWeight.w500,
                                                                                    color: Colors.black,
                                                                                    fontSize: 17),
                                                                              ),
                                                                              TextFormField(
                                                                                controller:
                                                                                notecontroller,
                                                                                maxLines:
                                                                                5,
                                                                              )
                                                                            ],
                                                                          ),
                                                                        ),
                                                                        actions: <
                                                                            Widget>[
                                                                          ElevatedButton(
                                                                            onPressed:
                                                                                () {
                                                                              setState(
                                                                                      () {
                                                                                    print(visibleBloc);
                                                                                    editappointment(id: singleItem["AppointmentId"]);
                                                                                  });
                                                                              Navigator.of(context)
                                                                                  .pop();
                                                                            },
                                                                            child: Text(
                                                                                'Save'),
                                                                          ),
                                                                          ElevatedButton(
                                                                            onPressed:
                                                                                () {
                                                                              Navigator.of(context)
                                                                                  .pop();
                                                                            },
                                                                            child: Text(
                                                                                'Cancel'),
                                                                          ),
                                                                        ],
                                                                      );
                                                                    });
                                                              }));
                                                        });
                                                  },
                                                  child: Container(
                                                    padding:
                                                    EdgeInsets.all(2),
                                                    margin:
                                                    EdgeInsets.all(5),
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                        BorderRadius
                                                            .circular(
                                                            3),
                                                        color: Color(
                                                            0xff36B9D6)),
                                                    child: Icon(
                                                      Icons.edit,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                                InkWell(
                                                  onTap: () {
                                                    deleteconfirmation(
                                                        context,
                                                        singleItem[
                                                        "AppointmentId"]);
                                                  },
                                                  child: Container(
                                                    padding:
                                                    EdgeInsets.all(2),
                                                    margin:
                                                    EdgeInsets.all(5),
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                        BorderRadius
                                                            .circular(
                                                            3),
                                                        color: Colors.red),
                                                    child: Icon(
                                                      Icons.delete,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  )
                                ],
                                backgroundColor: Color(0xFFeef2fb),
                              ),
                            ),
                          );
                        })
                  ],
                ),
              )

            ),
    );
  }
}

Widget titlesubtiletext(
    {String text, String subtext, BuildContext context, double width}) {
  return Container(
    width: width * 0.6,
    child: RichText(
      text: TextSpan(children: [
        TextSpan(
          text: text + ":",
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              .copyWith(fontWeight: FontWeight.w600, fontSize: 15),
        ),
        TextSpan(
            text: subtext,
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                .copyWith(fontWeight: FontWeight.w400, fontSize: 15))
      ]),
      textAlign: TextAlign.start,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    ),
  );
}
