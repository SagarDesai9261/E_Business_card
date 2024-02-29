import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import './login_screen.dart';
import '../textfield_validator.dart';
import '../src/repositories/repositories.dart';
import '../src/bloc/blocs.dart';
import '../globals.dart' as globals;

import '../util/show_message.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final emailController = TextEditingController();
  final otpController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final FieldValidator fieldValidator = FieldValidator();
   PreferredSizeWidget appbar;

  bool visibleBloc = false;
   DataBloc _dataBloc;

  @override
  void initState() {
    super.initState();

    appbar = AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      leading: new IconButton(
        icon: new Icon(Icons.arrow_back_ios, color: Colors.black),
        onPressed: () => Navigator.of(context).pop(),
      ),
    );
  }

  void requestNewPassword() {
    visibleBloc = true;
    var url = '${globals.API_URL}/api/forgot_password';
    var data = {
      "email": emailController.text,
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
    setState(() {
      print('api response data: $responseData');
      visibleBloc = false;
    });

    Map<String, Object> responseMap = responseData[0] as Map<String, Object>;

    if (responseMap['message'].runtimeType == String) {
      ShowMessage().showSnack(responseMap['message'].toString(), context);
      return;
    }
    List<Object> messageList = responseMap['message'] as List<Object>;
    for (int i = 0; i < messageList.length; i++) {
      ShowMessage().showSnack(messageList[i].toString(), context);
    }

    if (responseMap['status'].toString() == '1') {
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbar,
      body: visibleBloc == true
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
          : Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height -
                  appbar.preferredSize.height -
                  MediaQuery.of(context).padding.top,
              child: ListView(
                children: [
                  Container(
                      alignment: Alignment.center,
                      height: (MediaQuery.of(context).size.height -
                              appbar.preferredSize.height -
                              MediaQuery.of(context).padding.top) *
                          0.25,
                      child: Image.asset(
                        'assets/images/logo.png',
                        height: 200,
                        width: 200,
                      )),
                  Container(
                    alignment: Alignment.center,
                    height: (MediaQuery.of(context).size.height -
                            appbar.preferredSize.height -
                            MediaQuery.of(context).padding.top) *
                        0.1,
                    width: double.infinity,
                    child: Text(
                      'Forgot Password',
                      style: Theme.of(context).textTheme.headline2,
                    ),
                  ),
                  Container(
                    height: (MediaQuery.of(context).size.height -
                            appbar.preferredSize.height -
                            MediaQuery.of(context).padding.top) *
                        0.65,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(60),
                          topRight: Radius.circular(60)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 10,
                          blurRadius: 5,
                          offset: Offset(0, 7), // changes position of shadow
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(20),
                    child: Form(
                      key: formKey,
                      child: Column(
                        children: [
                          Container(
                            height: 3,
                            width: 30,
                            decoration: BoxDecoration(color: Color(0xFFeef2fb)),
                            alignment: Alignment.center,
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          TextFormField(
                            autofocus: false,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (value) {
                              return fieldValidator.emailValidator(value.toString());
                            },
                            controller: emailController,
                            keyboardType: TextInputType.emailAddress,
                            style: Theme.of(context).textTheme.bodyText1,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              // labelText: 'Email Address',
                              hintText: 'Email Address',
                            ),
                          ),
                          // Padding(padding: EdgeInsets.all(10),),
                          // TextFormField(
                          //   autofocus: false,
                          //   autovalidateMode: AutovalidateMode.onUserInteraction,
                          //   validator: (value){
                          //     if(value.isEmpty)
                          //       return 'Please enter Your OTP.';
                          //     return null;
                          //   },
                          //   controller: otpController,
                          //   keyboardType: TextInputType.visiblePassword,
                          //   style: Theme.of(context).textTheme.bodyText1,
                          //   decoration: InputDecoration(
                          //     border: OutlineInputBorder(),
                          //     hintText: 'Enter OTP',
                          //   ),
                          // ),
                          Padding(padding: const EdgeInsets.all(8)),

                          Container(
                              height: 45,
                              width: 230,
                              margin: EdgeInsets.only(top: 10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30)),
                              child: ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      requestNewPassword();
                                    });
                                  },
                                  child: Text(
                                    'Request New Password',
                                    style:
                                        Theme.of(context).textTheme.headline1,
                                  ))),
                          Padding(
                            padding: EdgeInsets.all(10),
                          ),
                          TextButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => LoginScreen()));
                              },
                              child: Text('Login',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline5
                                      .copyWith(
                                        fontSize: 14,
                                        color: Color(0xFF006ade),
                                      )))
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
    );
  }
}
