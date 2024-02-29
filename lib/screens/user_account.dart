import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../textfield_validator.dart';
import '../src/repositories/repositories.dart';
import '../src/bloc/blocs.dart';
import '../globals.dart' as globals;

class UserAccount extends StatefulWidget {
  @override
  _UserAccountState createState() => _UserAccountState();
}

class _UserAccountState extends State<UserAccount> {
  bool visibleBloc = false;
  bool editdone = false;
  bool changepassword = false;
  final FieldValidator fieldValidator = FieldValidator();
  bool _currentPasswordVisible = true;
  bool _passwordVisible = true;
  bool _confirmPassVisible = true;
  bool changePassVisibleBloc = false;
  bool changeEmailVisibleBloc = false;
  TextEditingController namecontroller = TextEditingController();
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController currentpassword = TextEditingController();
  TextEditingController newpassword = TextEditingController();

  TextEditingController confirmpassword = TextEditingController();

  dynamic result;

  DataBloc _dataBloc;
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
    print("hello");
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

    Map<String, Object> responseMap = responseData[0];
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
    Map<String, Object> responseMap = responseData[0];

    //showSnack(responseMap["message"]);
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

    Map<String, dynamic> responseMap = responseData[0];

    if (responseMap['status'].toString() == '1') {
      if (responseMap["message"] != "Users details") {
        showSnack(responseMap["message"]);
      }

      if (changepassword) {
        newpassword.clear();
        confirmpassword.clear();
        currentpassword.clear();
      } else
        setState(() {
          result = responseMap['result'];

          namecontroller.text = result["name"];
          emailcontroller.text = result["email"];
        });
      // showSnack(responseMap["message"]);

      if (responseMap['message'].runtimeType == String) {
        // showSnack(responseMap["message"]);
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
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          'My account',
          style: Theme.of(context)
              .textTheme
              .headline6
              .copyWith(fontSize: 20, fontWeight: FontWeight.w600),
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
          : ListView(
              children: [
                // Container(
                //     alignment: Alignment.centerRight,
                //     margin: EdgeInsets.only(right: 10),
                //     child: TextButton(
                //         onPressed: () =>
                //             Navigator.of(context).push(PageRouteBuilder(
                //               pageBuilder:
                //                   (context, animation, secondaryAnimation) =>
                //                       PlanHistory(),
                //               transitionsBuilder: (context, animation,
                //                   secondaryAnimation, child) {
                //                 const begin = Offset(0.0, 1.0);
                //                 const end = Offset.zero;
                //                 const curve = Curves.ease;
                //                 var tween = Tween(begin: begin, end: end)
                //                     .chain(CurveTween(curve: curve));
                //                 return SlideTransition(
                //                   position: animation.drive(tween),
                //                   child: child,
                //                 );
                //               },
                //             )),
                //         child: Text(
                //           'View all',
                //           style: Theme.of(context).textTheme.headline2.copyWith(
                //               fontSize: 14, fontWeight: FontWeight.w400),
                //         ))),
                // PlanDetailsCard(planStatus: true,),
                // Container(
                //     alignment: Alignment.center,
                //     child: Text(
                //       'Expire on 2022-08-18 22:55:45',
                //       style: Theme.of(context)
                //           .textTheme
                //           .headline5
                //           .copyWith(fontSize: 12),
                //     )),
                Card(
                  elevation: 5,
                  margin: EdgeInsets.all(10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: Container(
                    margin: EdgeInsets.all(20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Edit User Detail',
                          style: Theme.of(context).textTheme.headline2.copyWith(
                              fontSize: 14, fontWeight: FontWeight.w700),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          style: Theme.of(context).textTheme.bodyText1,
                          controller: namecontroller,
                          decoration: InputDecoration(
                            labelText: "Name",
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          child: TextFormField(
                            autofocus: false,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (value) {
                              return fieldValidator.emailValidator(value);
                            },
                            controller: emailcontroller,
                            keyboardType: TextInputType.emailAddress,
                            style: Theme.of(context).textTheme.bodyText1,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                               labelText: 'Email',
                              hintText: 'Email Address',
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        ElevatedButton(
                            onPressed: () {
                              edituserprofile();
                            },
                            child: Text('Submit',
                                style: Theme.of(context).textTheme.headline1))
                      ],
                    ),
                  ),
                ),
                Card(
                  elevation: 5,
                  margin: EdgeInsets.all(10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: Container(
                    margin: EdgeInsets.all(20),
                    child: Form(
                      key: formkey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Change Password',
                            style: Theme.of(context)
                                .textTheme
                                .headline2
                                .copyWith(
                                    fontSize: 14, fontWeight: FontWeight.w700),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          TextFormField(
                            autofocus: false,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (value) {
                              if (value.isEmpty) {
                                return "Please enter your current password";
                              }
                              return null;
                            },
                            controller: currentpassword,
                            obscureText: _currentPasswordVisible,
                            keyboardType: TextInputType.visiblePassword,
                            style: Theme.of(context).textTheme.bodyText1,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              // labelText:'Designation',
                              hintText: 'Current Password',
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _currentPasswordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
                                color: Color(0xFF546b8a),
                                onPressed: () {
                                  setState(() {
                                    _currentPasswordVisible =
                                        !_currentPasswordVisible;
                                  });
                                },
                              ),
                            ),
                          ),
                          Padding(padding: const EdgeInsets.all(8)),
                          TextFormField(
                            autofocus: false,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (value) {
                              if (value.isEmpty) {
                                return "Please enter your new password";
                              }
                              return null;
                            },
                            controller: newpassword,
                            obscureText: _passwordVisible,
                            keyboardType: TextInputType.visiblePassword,
                            style: Theme.of(context).textTheme.bodyText1,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              // labelText:'Designation',
                              hintText: 'New Password',
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _passwordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
                                color: Color(0xFF546b8a),
                                onPressed: () {
                                  setState(() {
                                    _passwordVisible = !_passwordVisible;
                                  });
                                },
                              ),
                            ),
                          ),
                          Padding(padding: const EdgeInsets.all(8)),
                          TextFormField(
                            autofocus: false,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (value) {
                              if (value.isEmpty)
                                return 'Confirm Password cant\'t  be  Empty.';
                              else if (value != newpassword.text)
                                return 'Password do not match!';
                              return null;
                            },
                            controller: confirmpassword,
                            obscureText: _confirmPassVisible,
                            keyboardType: TextInputType.visiblePassword,
                            style: Theme.of(context).textTheme.bodyText1,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              // labelText:'Designation',
                              hintText: 'Confirm Password',
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _confirmPassVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
                                color: Color(0xFF546b8a),
                                onPressed: () {
                                  setState(() {
                                    _confirmPassVisible = !_confirmPassVisible;
                                  });
                                },
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          ElevatedButton(
                              onPressed: () {
                               /*
                                if(currentpassword.text.isEmpty){
                                  Fluttertoast.showToast(msg: "please insert current password");
                                }
                                 if(newpassword.text.isEmpty){
                                  Fluttertoast.showToast(msg: "please insert newpassword");
                                }
                                 if(confirmpassword.text.isEmpty){
                                   Fluttertoast.showToast(msg: "Please insert Confirm-password");
                                 }
                                 else if(newpassword.)*/

                                if (formkey.currentState.validate()) {
                                //  print("hello");
                                  changeuserpassword();
                                }
                              },
                              child: Text('Submit new password',
                                  style: Theme.of(context).textTheme.headline1))
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
    );
  }
}
