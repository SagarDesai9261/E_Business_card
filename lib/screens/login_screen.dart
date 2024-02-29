import 'dart:async';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import './forgot_password.dart';
import './main_screen.dart';
import './registration.dart';
import '../textfield_validator.dart';
import '../src/repositories/repositories.dart';
import '../src/bloc/blocs.dart';
import '../globals.dart' as globals;
import 'package:google_sign_in/google_sign_in.dart';


// import 'package:flutter_linkedin/config/api_routes.dart';
// import 'package:flutter_linkedin/data_model/auth_error_response.dart';
// import 'package:flutter_linkedin/data_model/auth_success_response.dart';
// import 'package:flutter_linkedin/data_model/email_response.dart';
// import 'package:flutter_linkedin/data_model/profile_error.dart';
// import 'package:flutter_linkedin/data_model/profile_response.dart';
// import 'package:flutter_linkedin/helpers/access_token_helper.dart';
// import 'package:flutter_linkedin/helpers/authorization_helper.dart';
// import 'package:flutter_linkedin/helpers/email_helper.dart';
// import 'package:flutter_linkedin/helpers/profile_helper.dart';
// import 'package:flutter_linkedin/linkedloginflutter.dart';
// import 'package:flutter_linkedin/widgets/linked_in_web_view.dart';

GoogleSignIn _googleSignIn = GoogleSignIn(
  // Optional clientId
  // clientId: '479882132969-9i9aqik3jfjd7qhci1nqf0bm2g71rm1u.apps.googleusercontent.com',
  scopes: <String>[
    'email',
    'https://www.googleapis.com/auth/contacts.readonly',
  ],
);

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();
  final FieldValidator fieldValidator = FieldValidator();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool _passwordVisible = true;
  bool checkBoxValue = false;
  bool visibleBloc = false;
   DataBloc _dataBloc;
   String socialType;

  bool socialLoginBloc = false;
   GoogleSignInAccount _currentUser;

  final String linkedinRedirectUrl = 'http://localhost:3001/eBusinessCard';
  final String linkedinClientId = '788wrk62sv1q6w';
  final String linkedinClientSecret = 'Mt6bGX9jEUHSwhk2';

  void socialLoginApiCall(userEmail, userToken, type) {
    print("Social api call");
    print("User name: ${userEmail.toString()}");
    print("User UserToken: ${userToken.toString()}");
    print("User type: ${type.toString()}");

    socialLoginBloc = true;

    var url = '${globals.API_URL}/api/sociallogin';
    var data = {
      "user_email": userEmail.toString(),
      "access_token": userToken.toString(),
      "type": type.toString(),
    };

    _dataBloc = DataBloc(
        dataRepository: DataRepository(
            dataApiClient: DataApiClient(
      url: url,
      data: data,
    )));
    _dataBloc.add(FetchData());
  }

  void socialLoginApiResponce(List<Object> responseData) async {
    Map<String, Object> responseMap = responseData[0] as Map<String, Object>;

    if (responseMap['status'] == 'Success') {
      Map<String, Object> data = responseMap['data'] as Map<String, Object>;

      globals.USER_ID = data['user_id'].toString();
      globals.USER_NAME = data['user_name'].toString();
      globals.USER_EMAIL = data['user_email'].toString();
      globals.USER_TOKEN = data['csrf_token'].toString();
      globals.USER_PASSWORD = passwordController.text;
      globals.REMEMBER_ME = "no";
      globals.LOGIN = "login";
      globals.SOCIAL_TYPE = socialType;
      globals.primaryImage = data['avatar'].toString();

      // if(checkBoxValue){
      SharedPreferences preferences = await SharedPreferences.getInstance();
      preferences.setString('user_id', globals.USER_ID);
      preferences.setString('user_name', globals.USER_NAME);
      preferences.setString('user_email', globals.USER_EMAIL);
      preferences.setString('user_token', globals.USER_TOKEN);
      preferences.setString('user_password', globals.USER_PASSWORD);
      preferences.setString('remember_me', globals.REMEMBER_ME);
      preferences.setString('user_login', globals.LOGIN);
      preferences.setString('social_type', globals.SOCIAL_TYPE);
      preferences.setString('avatar', globals.primaryImage);

      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => MainScreen()));
    } else {
      setState(() {
        print('show msg response data: ${responseData[0].runtimeType}');
        socialLoginBloc = false;
      });

      List<Object> messageList = responseMap['message'] as List<Object>;
      for (int i = 0; i < messageList.length; i++) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(messageList[i].toString()),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    setFields(); //set remembered fields when user log out
    // _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount account) {
    //   setState(() {
    //     _currentUser = account;
    //     print("current user: ${_currentUser}");
    //   });
    //   // if (_currentUser != null) {
    //   //   _handleGetContact(_currentUser);
    //   // }
    // });
    // _googleSignIn.signInSilently();
    _googleSignIn.disconnect();
    //DS need to see
    //_currentUser = ;

  }

  Future<void> _handleSignIn() async {
    // Navigator.of(context).pop();
    String googleToken = "";
    try {
      var user1 = await _googleSignIn.signIn().then((result) {
        result.authentication.then((googleKey) async {
          print("google all:${googleKey}");
          print("id token: ${googleKey.idToken}");
          print("google token :${googleKey.accessToken}");

          setState(() {
            googleToken = googleKey.accessToken;
          });
          var user = await _googleSignIn.signIn();
          print("new login user:${googleToken}");
          if (user != null) {
            setState(() {
              _currentUser = user;
              googleSignInDialog(context, googleToken);
            });
            // _getAllGoogleInfo(_currentUser);
          }
        }).catchError((err) {
          print('inner error');
        });
      }).catchError((err) {
        print('error occured');
      });
    } catch (error) {
      print("Sign in error :$error");
    }
  }

  Future<void> _handleSignOut() async {
    _googleSignIn.disconnect();
    //DS need to change
    _currentUser = null;
    Navigator.of(context).pop();
  }

  void googleSignInDialog(BuildContext ctx, googleToken) {
    print('show dialog called');
    WidgetsBinding.instance.addPostFrameCallback((_) => showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          GoogleSignInAccount user = _currentUser;

          print("Google user :$user");
          print("Google Token :$googleToken");
          if (user != null) {
            return Dialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0)),
                child: Container(
                    height: 300,
                    width: 350,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        ListTile(
                          leading: GoogleUserCircleAvatar(
                            identity: user,
                          ),
                          title: Text(user.displayName ?? ''),
                          subtitle: Text(user.email),
                        ),
                        const Text("Signed in successfully."),
                        TextButton(
                            onPressed: () =>
                                googleContinueSignUpButton(googleToken),
                            child: Text('Continue',
                                style: Theme.of(context)
                                    .textTheme
                                    .headline5
                                    .copyWith(
                                      fontSize: 18,
                                      color: Color(0xFF006ade),
                                    ))),
                        // Text(_contactText),
                        ElevatedButton(
                          child: Text('Sign Out',
                              style: Theme.of(context).textTheme.headline1),
                          onPressed: _handleSignOut,
                        ),
                        // ElevatedButton(
                        //   child: const Text('REFRESH'),
                        //   onPressed: () => _handleGetContact(user),
                        // ),
                      ],
                    )));
          } else {
            return Dialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0)),
                child: Container(
                    height: 400,
                    width: 350,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        const Text("You are not currently signed in."),
                        ElevatedButton(
                          child: Text(
                            'SIGN IN',
                            style: Theme.of(context).textTheme.headline1,
                          ),
                          onPressed: () {
                            setState(() {
                              _handleSignIn();
                            });
                          },
                        ),
                      ],
                    )));
          }
        }));
  }

  void googleContinueSignUpButton(googleToken) {
    // usernameController.text=_currentUser.displayName;
    // emailController.text=_currentUser.email;
    // passwordController.text=_currentUser.id;
    setState(() {
      // googleSignInContinueFlag=true;
      socialType = "google";
      socialLoginApiCall(_currentUser.email, googleToken, "google");
    });
    Navigator.of(context).pop();
  }

  void facebookSignUpButton() async {
    // final facebookLogin = FacebookLogin();
    //
    // facebookLogin.loginBehavior = FacebookLoginBehavior.webViewOnly;
    // final result = await  facebookLogin.logIn(
    //     [
    //       'email','public_profile','user_birthday','user_hometown','user_location','user_link'
    //     ]);
    // print("facebook result:${result}");
    // final token = result.accessToken.token;
    // print("FaceBook token:$token");
    //
    //
    // final graphResponse = await http.get(
    //     'https://graph.facebook.com/me?fields=name,first_name,last_name,email,birthday,address&access_token=${token}');
    // final profile = jsonDecode(graphResponse.body);
    // if(profile!=null){
    //   setState(() {
    //     socialType="facebook";
    //     socialLoginApiCall(profile['email'],token,"facebook");
    //   });
    // }
    //
    // print("FaceBook Profile details: ${profile}");
    // print("FaceBook Profile details: ${profile['email']}");
    //
    // switch (result.status) {
    //   case FacebookLoginStatus.loggedIn:
    //   // _sendTokenToServer(result.accessToken.token);
    //   // _showLoggedInUI();
    //     break;
    //   case FacebookLoginStatus.cancelledByUser:
    //   // _showCancelledMessage();
    //     break;
    //   case FacebookLoginStatus.error:
    //   // _showErrorOnUI(result.errorMessage);
    //     break;
    // }
  }
  void linkedinSignUpButton() {
    getAllInfoFromLinkedIn();
    return;
    // LinkedInLogin.getEmail(
    //     destroySession: true,
    //     forceLogin: true,
    //     appBar: AppBar(
    //       title: Text('LinkedIn Login'),
    //     )
    // ) .then((email) {
    //   var userEmail=email.elements.elementAt(0).elementHandle.emailAddress;
    //   print("Linked in email:${userEmail}");
    //   if(userEmail!=null){
    //     setState(() {
    //       socialType="linkedin";
    //       // socialLoginApiCall(userEmail);
    //     });
    //   }
    //
    // }
    // ).catchError((error){
    //   print(" linked in login issue${error.errorDescription}");
    // });
  }

  void getAllInfoFromLinkedIn() {
    // LinkedInLogin.loginForAccessToken(
    //     destroySession: true,
    //     // forceLogin : true ,
    //     appBar: AppBar(
    //       title: Text('linkedin'),
    //     )
    // ) .then((accessToken) async{
    //   print("Linkedin Token:$accessToken");
    //   LinkedInLogin.getEmail(
    //       destroySession: true,
    //       // forceLogin: true,
    //       appBar: AppBar(
    //         title: Text('LinkedIn Login'),
    //       )
    //   ) .then((email) {
    //     var userEmail=email.elements.elementAt(0).elementHandle.emailAddress;
    //     print("Linked in email:${userEmail}");
    //     if(userEmail!=null){
    //       setState(() {
    //         socialType="linkedin";
    //         socialLoginApiCall(userEmail,accessToken,"linkedin");
    //       });
    //     }
    //
    //   }
    //   ).catchError((error){
    //     print(" linked in login issue${error.errorDescription}");
    //   });
    //
    //   // final response = await http.get(
    //   //     'https://api.linkedin.com/v2/me',
    //   //     headers: {"Authorization":"Bearer $accessToken"});
    //   // final profile = jsonDecode(response.body);
    //   // print("linkedin response:${profile}");
    //   // final response1 = await http.get(
    //   //     'GET https://api.linkedin.com/v2/people/(id:${profile['id']})?projection=(email)',
    //   //     headers: {"Authorization":"Bearer $accessToken"});
    //   // final profile1 = jsonDecode(response1.body);
    //   // print("linkedin response2:${profile1}");
    //   //
    //   // if(profile!=null){
    //   //   setState(() {
    //   //     socialType="linkedin";
    //   //     // socialLoginApiCall(userEmail);
    //   //   });
    //   // }
    // } )
    //     .catchError((error){
    //   print("error Linkedin${error.errorDescription}");
    // });
  }

  Future<bool> _onWillPop() async {
    SystemNavigator.pop();
    return true;
  }

  void loginButtonClick() {
    print("User name: ${emailController.text}");

    visibleBloc = true;

    var url = '${globals.API_URL}/api/login';
    var data = {
      "email": emailController.text,
      "password": passwordController.text,
    };

    _dataBloc = DataBloc(
        dataRepository: DataRepository(
            dataApiClient: DataApiClient(
      url: url,
      data: data,
    )));
    _dataBloc.add(FetchData());
  }

  Future showMsg(List<Object> responseData, BuildContext ctx) async {
    Map<String, dynamic> responseMap = responseData[0] as Map<String, Object>;

    if (responseMap['success'] == 1) {
      Map<String, Object> data = responseMap['result'][0];

      globals.USER_ID = data['id'].toString();
      globals.USER_NAME = data['name'].toString();
      globals.USER_EMAIL = data['email'].toString();
      globals.USER_TOKEN = data['token'].toString();
      globals.USER_PASSWORD = passwordController.text;
      globals.REMEMBER_ME = checkBoxValue ? "yes" : "no";
      globals.LOGIN = "login";
      globals.primaryImage = data['avatar'].toString();

      // if(checkBoxValue){
      SharedPreferences preferences = await SharedPreferences.getInstance();
      preferences.setString('user_id', globals.USER_ID);
      preferences.setString('user_name', globals.USER_NAME);
      preferences.setString('user_email', globals.USER_EMAIL);
      preferences.setString('user_token', globals.USER_TOKEN);
      preferences.setString('user_password', globals.USER_PASSWORD);
      preferences.setString('remember_me', globals.REMEMBER_ME);
      preferences.setString('user_login', globals.LOGIN);
      preferences.setString('avatar', globals.primaryImage);
      // preferences.setString('img', globals.IMG);
      // }

      // ScaffoldMessenger.of(ctx).showSnackBar(
      //   SnackBar( content: Text(responseMap['message']),
      //     duration: const Duration(seconds: 2),
      //   ),
      // );

      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => MainScreen()));
    } else {
      setState(() {
        print('show msg response data: ${responseData[0].runtimeType}');
        visibleBloc = false;
      });
      if (responseMap['message'].runtimeType == String) {
        showSnackBar(responseMap['message']);
      } else {
        List<Object> messageList = responseMap['message'];

        for (int i = 0; i < messageList.length; i++) {
          showSnackBar(messageList[i]);
        }
      }
    }
  }

  Future setFields() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    var userEmail = preferences.getString('user_email');
    var userPassword = preferences.getString('user_password');
    var rememberMe = preferences.getString('remember_me');
    // img=preferences.getString('img');
    if (rememberMe == "yes") {
      emailController.text = userEmail.toString();
      passwordController.text = userPassword.toString();
      setState(() {
        checkBoxValue = true;
      });
      // globals.IMG=img;
    }
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
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        body: visibleBloc == true || socialLoginBloc
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
                    if (socialLoginBloc)
                      WidgetsBinding.instance.addPostFrameCallback(
                          (_) => socialLoginApiResponce(state.responseData));
                    else
                      WidgetsBinding.instance.addPostFrameCallback(
                          (_) => showMsg(state.responseData, context));
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
            : SingleChildScrollView(
                child: Container(
                  width: double.infinity,
                  // height: MediaQuery.of(context).size.height,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // SizedBox(height:(MediaQuery.of(context).size.height-MediaQuery.of(context).padding.top)*0.05,),
                      Container(
                          alignment: Alignment.center,

                          // height:(MediaQuery.of(context).size.height-MediaQuery.of(context).padding.top)*0.25,
                          child: Image.asset(
                            'assets/images/logo.png',
                            height: 200,
                            width: 200,
                          )),
                      Container(
                        alignment: Alignment.center,
                        height: (MediaQuery.of(context).size.height -
                                MediaQuery.of(context).padding.top) *
                            0.1,
                        width: double.infinity,
                        child: Text(
                          'Login',
                          style: Theme.of(context).textTheme.headline2,
                        ),
                      ),
                      // SizedBox(height:(MediaQuery.of(context).size.height-MediaQuery.of(context).padding.top)*0.05,),
                      Container(
                        height: (MediaQuery.of(context).size.height -
                                MediaQuery.of(context).padding.top) *
                            0.75,
                        width: double.infinity,
                        // height: double.infinity,
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
                              offset:
                                  Offset(0, 7), // changes position of shadow
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
                                decoration:
                                    BoxDecoration(color: Color(0xFFeef2fb)),
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
                              Padding(padding: const EdgeInsets.all(8)),
                              TextFormField(
                                autofocus: false,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                validator: (value) {
                                  return fieldValidator
                                      .passwordValidator(value.toString());
                                },
                                controller: passwordController,
                                obscureText: _passwordVisible,
                                keyboardType: TextInputType.visiblePassword,
                                style: Theme.of(context).textTheme.bodyText1,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  // labelText:'Designation',
                                  hintText: 'Password',
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
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Padding(padding: EdgeInsets.all(5)),
                                  SizedBox(
                                    width: 20,
                                    child: Checkbox(
                                      activeColor:
                                          Theme.of(context).primaryColor,
                                      value: this.checkBoxValue,
                                      onChanged: (value) {
                                        setState(() {
                                          this.checkBoxValue = value;
                                        });
                                      },
                                    ),
                                  ),
                                  Padding(padding: EdgeInsets.all(5)),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        checkBoxValue = !checkBoxValue;
                                      });
                                    },
                                    child: Text(
                                      "Remember me",
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline6
                                          .copyWith(color: Color(0xFF546b8a)),
                                    ),
                                  )
                                ],
                              ),
                              Container(
                                  height: 45,
                                  width: 150,
                                  margin: EdgeInsets.only(top: 10),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30)),
                                  child: ElevatedButton(
                                      onPressed: () {
                                        print("DS>> I am here1");
                                       /* if (formKey.currentState.validate()) {
                                          setState(() {
                                            print("DS>> I am here");
                                            loginButtonClick();
                                          });
                                        }*/
                                        //if (formKey.currentState.validate()) {
                                          setState(() {
                                            //mprint("DS>> I am here");
                                            loginButtonClick();
                                          });
                                        //}
                                      },
                                      child: Text(
                                        'Login',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline1,
                                      ))),
                              SizedBox(
                                height: 15,
                              ),
                              RichText(
                                text: TextSpan(
                                  children: <TextSpan>[
                                    TextSpan(
                                        text: 'Forgot Password?',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline3
                                            .copyWith(fontSize: 14),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        ForgotPasswordScreen()));
                                          }),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 7,
                              ),
                              Visibility(
                                visible: false,
                                child: InkWell(
                                  onTap: () {
                                    print('tapped');
                                  },
                                  child: RichText(
                                    text: TextSpan(
                                      children: <TextSpan>[
                                        TextSpan(
                                          text: 'Don\'t Have an Account ? ',
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline3
                                              .copyWith(fontSize: 14),
                                        ),
                                        TextSpan(
                                            text: 'Sign Up',
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline2
                                                .copyWith(fontSize: 14),
                                            recognizer: TapGestureRecognizer()
                                              ..onTap = () {
                                                Navigator.pushReplacement(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            RegistrationScreen()));
                                              }),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              // Padding(padding: EdgeInsets.all(5),),
                              // Text("OR",style:Theme.of(context).textTheme.headline3.copyWith(fontSize: 16),),
                              // Padding(padding: EdgeInsets.all(5),),
                              Visibility(
                                visible: false,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Container(
                                      height: 60,
                                      width: 60,
                                      // margin: EdgeInsets.only(top:10),
                                      decoration: BoxDecoration(
                                          color: Color(0xFFeef2fb),
                                          // border: Border.all(color: Colors.blueGrey),
                                          borderRadius:
                                              BorderRadius.circular(30)),
                                      child: IconButton(
                                        onPressed: _handleSignIn,
                                        // label: Text('', style: Theme.of(context).textTheme.headline1.copyWith(color: Colors.blue),),
                                        icon: Image.asset(
                                            "./assets/images/google_PNG.png"),
                                        // style: ElevatedButton.styleFrom(primary: Colors.white),
                                      ),
                                    ),
                                    Container(
                                      height: 60,
                                      width: 60,
                                      // margin: EdgeInsets.only(top:10),
                                      decoration: BoxDecoration(
                                          color: Color(0xFFeef2fb),
                                          borderRadius:
                                              BorderRadius.circular(30)),
                                      child: IconButton(
                                        onPressed: () => facebookSignUpButton(),
                                        // label: Text('', style: Theme.of(context).textTheme.headline1.copyWith(color: Colors.blue),),
                                        icon: Image.asset(
                                          "./assets/images/facebook_PNG.png",
                                          width: 300,
                                          height: 300,
                                        ),
                                        // style: ElevatedButton.styleFrom(primary: Colors.white),
                                      ),
                                    ),
                                    Container(
                                      height: 60,
                                      width: 60,
                                      // margin: EdgeInsets.only(top:10),
                                      decoration: BoxDecoration(
                                          color: Color(0xFFeef2fb),
                                          borderRadius:
                                              BorderRadius.circular(30)),
                                      child: IconButton(
                                        onPressed: linkedinSignUpButton,
                                        // label: Text('', style: Theme.of(context).textTheme.headline1.copyWith(color: Colors.blue),),
                                        icon: Image.asset(
                                          "./assets/images/linkedin_PNG.png",
                                          width: 40,
                                          height: 40,
                                        ),
                                        // style: ElevatedButton.styleFrom(primary: Colors.white),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  void showSnackBar(str) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("$str"),
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
