import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../globals.dart' as globals;


import 'package:flutter_bloc/flutter_bloc.dart';

import '../src/bloc/Data_Events.dart';
import '../src/repositories/DataApiClient.dart';
import '../src/repositories/Data_Repository.dart';
import '../src/bloc/Data_Bloc.dart';
import '../textfield_validator.dart';
import '../src/bloc/Data_State.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
   DataBloc _dataBloc;
  bool visibleBloc = false;
  bool editdone = false;
  bool changepassword = false;

  dynamic result;
  TextEditingController namecontroller = TextEditingController();
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController currentpassword = TextEditingController();
  FieldValidator fieldValidator = FieldValidator();
  TextEditingController newpassword = TextEditingController();
  TextEditingController confirmpassword = TextEditingController();
  @override
  void initState() {
    getUserProfile();
    super.initState();
  }

  void getUserProfile() {
    setState(() {
      visibleBloc = true;
    });

    var url = '${globals.API_URL}/api/show_profile';

    _dataBloc = DataBloc(
        dataRepository: DataRepository(
            dataApiClient: DataApiClient(
      url: url,
    )));
    _dataBloc.add(FetchData());
    setState(() {
      editdone = false;
    });
  }

  void edituserprofile() {
    setState(() {
      visibleBloc = true;
    });
    var url = '${globals.API_URL}/api/edit_profile';
    var data = {
      "user_id": globals.USER_ID,
      "email": emailcontroller.text,
      "name": namecontroller.text,
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

  void changeuserpassword() {
    setState(() {
      visibleBloc = true;
    });
    var url = '${globals.API_URL}/api/change_password';
    var data = {
      "user_id": globals.USER_ID,
      "current_password": currentpassword.text,
      "new_password": newpassword.text,
      "confirm_password": confirmpassword.text
    };

    _dataBloc = DataBloc(
        dataRepository: DataRepository(
            dataApiClient: DataApiClient(
      url: url,
      data: data,
    )));
    _dataBloc.add(FetchData());
    setState(() {
      changepassword = true;
    });
  }

  Future getProfileApiResponse(List<Object> responseData) async {
    print('Main Screen List responce: $responseData');
    setState(() {
      visibleBloc = false;
    });

    Map<String, Object> responseMap = responseData[0] as Map<String, Object>;
    if (responseMap['status'] == '1') {
      result = responseMap['result'];
      setState(() {
        namecontroller.text = result["name"];
        emailcontroller.text = result["email"];
      });
    } else {
      return;
    }
  }

  GlobalKey<FormState> formkey = GlobalKey();

  Future changepasswordapiresponse(List<Object> responseData) async {
    setState(() {
      changepassword = false;
    });

    print(responseData);
    Map<String, Object> responseMap = responseData[0] as Map<String, Object>;

    showSnack(responseMap["message"].toString());
    if (responseMap['status'] == '1') {
      // setState(() {
      //   namecontroller.text = result["name"];
      //   emailcontroller.text = result["email"];
      // });
    } else {
      return;
    }
  }

  void showSnack(String str) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(str),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future apiResponse(List<Object> responseData) async {
    print("Calling");
    setState(() {
      visibleBloc = false;
    });

    Map<String, dynamic> responseMap = responseData[0] as Map<String, dynamic>;

    if (responseMap['status'].toString() == '1') {
      if (changepassword) {
        showSnack(responseMap["message"]);
        newpassword.clear();
        confirmpassword.clear();
        currentpassword.clear();
      } else
        setState(() {
          result = responseMap['result'];

          namecontroller.text = result["name"];
          emailcontroller.text = result["email"];
        });
      if (responseMap['message'].runtimeType == String) {
      } else {
        List<Object> messageList = responseMap['message'];
        for (int i = 0; i < messageList.length; i++) {}
      }
      setState(() {});
      // if (emptyDataFlag) {
      //   print("emptydata flag:${emptyDataFlag}");
      //   setState(() {
      //     getAllContactCardInfo();
      //   });
      // }
      // emptyDataFlag =
      //     false; //when first record is inserted user can click on home icon
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
          ? BlocBuilder<DataBloc, UsersState>(
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
                        (_) => getProfileApiResponse(state.responseData));
                  if (editdone) {
                    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                      getUserProfile();
                    });
                  }
                  if (changepassword) {
                    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                      changepasswordapiresponse(state.responseData);
                    });
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
                              if (visibleBloc) getUserProfile();
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
                    height: 400,
                    //    height: MediaQuery.of(context).size.height / 2.15,
                    padding: EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          height: 130,
                          width: 130,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                image: NetworkImage(result["profile_pic"])),
                            shape: BoxShape.circle,
                            color: Colors.black,
                          ),
                        ),
                        Spacer(),
                        TextFormField(
                          style: Theme.of(context).textTheme.bodyText1,
                          controller: namecontroller,
                          decoration: InputDecoration(
                            labelText: "Name",
                          ),
                        ),
                        Spacer(),
                        TextFormField(
                          controller: emailcontroller,
                          style: Theme.of(context).textTheme.bodyText1,
                          decoration: InputDecoration(
                            labelText: "Email",
                          ),
                        ),
                        Spacer(),
                        Container(
                            height: 45,
                            width: 230,
                            margin: EdgeInsets.only(top: 10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30)),
                            child: ElevatedButton(
                                onPressed: () {
                                  edituserprofile();
                                },
                                child: Text(
                                  'Save Changes',
                                  style: Theme.of(context).textTheme.headline1,
                                ))),
                      ],
                    ),
                  ),
                  Form(
                    key: formkey,
                    child: Container(
                      height: 360,
                      padding: EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Spacer(),
                          TextFormField(
                            controller: currentpassword,
                            validator: (value) {
                              if (value.isEmpty) {
                                return "Current Password Should Not Be Empty";
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              labelText: "Current Password",
                            ),
                          ),
                          Spacer(),
                          TextFormField(
                            validator: (value) {
                              return fieldValidator.passwordValidator(value);
                            },
                            controller: newpassword,
                            decoration: InputDecoration(
                              labelText: "New Password",
                            ),
                          ),
                          Spacer(),
                          TextFormField(
                            validator: (value) {
                              if (value != newpassword.text) {
                                return "Password Not Match";
                              }
                              return null;
                            },
                            controller: confirmpassword,
                            decoration: InputDecoration(
                              labelText: "Re-type New Password",
                            ),
                          ),
                          Spacer(),
                          Container(
                              height: 45,
                              width: 230,
                              margin: EdgeInsets.only(top: 10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30)),
                              child: ElevatedButton(
                                  onPressed: () {
                                    if (formkey.currentState.validate()) {
                                      changeuserpassword();
                                    }
                                  },
                                  child: Text(
                                    'Update Password',
                                    style:
                                        Theme.of(context).textTheme.headline1,
                                  ))),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
