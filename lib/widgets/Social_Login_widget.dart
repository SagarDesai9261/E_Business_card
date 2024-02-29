// import 'package:flutter/material.dart';
// import 'dart:async';
// import 'dart:convert' show json, jsonDecode;
// import "package:http/http.dart" as http;
// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:nfc_app/src/bloc/blocs.dart';
// import 'package:checkbox_formfield/checkbox_formfield.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// import '../screens/login_screen.dart';
// import '../textfield_validator.dart';
// import '../src/repositories/repositories.dart';
// import '../globals.dart' as globals;
// import '../screens/main_screen.dart';
//
//
//
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:flutter_facebook_login/flutter_facebook_login.dart';
//
// GoogleSignIn _googleSignIn = GoogleSignIn(
//   // Optional clientId
//   // clientId: '479882132969-9i9aqik3jfjd7qhci1nqf0bm2g71rm1u.apps.googleusercontent.com',
//   scopes: <String>[
//     'email',
//     'https://www.googleapis.com/auth/contacts.readonly',
//   ],
// );
//
//
// class SocialLoginWidget extends StatefulWidget
// {
//   @override
//   _SocialLoginWidgetState createState() => _SocialLoginWidgetState();
// }
//
// class _SocialLoginWidgetState extends State<SocialLoginWidget> {
//   DataBloc _dataBloc;
//   bool socialLoginBloc=false;
//   GoogleSignInAccount _currentUser;
//
//   void socialLoginApiCall(userEmail)
//   {
//     socialLoginBloc=true;
//
//     var url = '${globals.API_URL}/api/sociallogin';
//     var data = {
//       "user_email":userEmail,
//     };
//
//     _dataBloc=DataBloc(
//         dataRepository: DataRepository(
//             dataApiClient: DataApiClient(
//               url: url,
//               data: data,
//             )
//         )
//     );
//     _dataBloc.add(FetchData());
//   }
//
//   void socialLoginApiResponce(List<Object> responseData)async{
//
//
//     Map<String,Object> responseMap=responseData[0];
//
//     if(responseMap['status']=='Success'){
//       Map<String,Object> data=responseMap['data'];
//
//       globals.USER_ID=data['user_id'];
//       globals.USER_NAME=data['user_name'];
//       globals.USER_EMAIL=data['user_email'];
//       globals.USER_TOKEN=data['csrf_token'];
//       // globals.USER_PASSWORD=passwordController.text;
//       globals.REMEMBER_ME="no";
//       globals.LOGIN="login";
//
//       // if(checkBoxValue){
//       SharedPreferences preferences=await SharedPreferences.getInstance();
//       preferences.setString('user_id', globals.USER_ID);
//       preferences.setString('user_name', globals.USER_NAME);
//       preferences.setString('user_email', globals.USER_EMAIL);
//       preferences.setString('user_token', globals.USER_TOKEN);
//       preferences.setString('user_password', globals.USER_PASSWORD);
//       preferences.setString('remember_me', globals.REMEMBER_ME);
//       preferences.setString('user_login', globals.LOGIN);
//
//       Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>MainScreen()));
//     }else {
//       setState(() {
//         print('show msg response data: ${responseData[0].runtimeType}');
//         socialLoginBloc=false;
//       });
//
//       List<Object> messageList = responseMap['message'];
//       for (int i = 0; i < messageList.length; i++) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text(messageList[i]),
//             duration: const Duration(seconds: 2),
//           ),
//         );
//       }
//     }
//   }
//
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount account) {
//       setState(() {
//         _currentUser = account;
//         print("current user: ${_currentUser}");
//       });
//       // if (_currentUser != null) {
//       //   _handleGetContact(_currentUser);
//       // }
//     });
//     _googleSignIn.signInSilently();
//   }
//   Future<void> _handleSignIn() async {
//     Navigator.of(context).pop();
//     try {
//       var user =await _googleSignIn.signIn();
//
//       print("new login user:${user.email}");
//       if(user!=null)
//       {
//         setState(() {
//           _currentUser=user;
//           googleSignInDialog(context);
//         });
//       }
//
//     } catch (error) {
//       print("Sign in error :$error");
//     }
//   }
//   Future<void> _handleSignOut() {
//     Navigator.of(context).pop();
//     _googleSignIn.disconnect();
//   }
//   void googleSignInDialog(BuildContext ctx)
//   {
//     print('show dialog called');
//     WidgetsBinding.instance.addPostFrameCallback((_) =>
//         showDialog(
//             context: context,
//             barrierDismissible: false,
//             builder: (BuildContext context) {
//               GoogleSignInAccount user = _currentUser;
//
//               print("Google user :$user");
//               if (user != null) {
//                 return Dialog(
//                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
//                     child: Container(
//                         height: 300,
//                         width:350,
//                         child:Column(
//                           mainAxisAlignment: MainAxisAlignment.spaceAround,
//                           children: <Widget>[
//                             ListTile(
//                               leading: GoogleUserCircleAvatar(
//                                 identity: user,
//                               ),
//                               title: Text(user.displayName ?? ''),
//                               subtitle: Text(user.email),
//                             ),
//                             const Text("Signed in successfully."),
//                             TextButton(onPressed: googleContinueSignUpButton, child: Text('Continue',style:Theme.of(context).textTheme.headline5.copyWith(
//                               fontSize: 18,color:Color(0xFF006ade),
//                             ))),
//                             // Text(_contactText),
//                             ElevatedButton(
//                               child: Text('SIGN OUT',style:Theme.of(context).textTheme.headline1),
//                               onPressed: _handleSignOut,
//                             ),
//                             // ElevatedButton(
//                             //   child: const Text('REFRESH'),
//                             //   onPressed: () => _handleGetContact(user),
//                             // ),
//                           ],
//                         )
//                     ));
//               } else {
//                 return Dialog(
//                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
//                     child: Container(
//                         height: 400,
//                         width:350,
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.spaceAround,
//                           children: <Widget>[
//                             const Text("You are not currently signed in."),
//                             ElevatedButton(
//                               child: Text('SIGN IN',style:Theme.of(context).textTheme.headline1,),
//                               onPressed: (){
//                                 setState(() {
//                                   _handleSignIn();
//                                 });
//
//                               },
//                             ),
//                           ],
//                         )));
//               }
//             }
//         ));
//   }
//
//   void googleContinueSignUpButton(){
//     setState(() {
//       // googleSignInContinueFlag=true;
//       socialLoginApiCall(_currentUser.email);
//     });
//     Navigator.of(context).pop();
//   }
//
//   void facebookSignUpButton()async
//   {
//     final facebookLogin = FacebookLogin();
//     facebookLogin.loginBehavior = FacebookLoginBehavior.webViewOnly;
//     final result = await  facebookLogin.logIn(['email','public_profile']);
//     print("facebook result:$result");
//     final token = result.accessToken.token;
//     final graphResponse = await http.get(
//         'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email&access_token=${token}');
//     final profile = jsonDecode(graphResponse.body);
//     if(profile!=null){
//       setState(() {
//         socialLoginApiCall(profile['email']);
//       });
//     }
//
//     print("FaceBook Profile details: ${profile}");
//     print("FaceBook Profile details: ${profile['email']}");
//
//     switch (result.status) {
//       case FacebookLoginStatus.loggedIn:
//       // _sendTokenToServer(result.accessToken.token);
//       // _showLoggedInUI();
//         break;
//       case FacebookLoginStatus.cancelledByUser:
//       // _showCancelledMessage();
//         break;
//       case FacebookLoginStatus.error:
//       // _showErrorOnUI(result.errorMessage);
//         break;
//     }
//   }
//   @override
//   Widget build(BuildContext context) {
//     return  Row(
//       mainAxisAlignment: MainAxisAlignment.spaceAround,
//       children: [
//         Container(
//           height:60,
//           width: 60,
//           // margin: EdgeInsets.only(top:10),
//           decoration: BoxDecoration(
//               color:Color(0xFFeef2fb) ,
//               // border: Border.all(color: Colors.blueGrey),
//               borderRadius: BorderRadius.circular(30)
//           ),
//           child:IconButton(
//             onPressed: ()=>googleSignInDialog(context),
//             // label: Text('', style: Theme.of(context).textTheme.headline1.copyWith(color: Colors.blue),),
//             icon: Image.asset("./assets/images/google_PNG.png"),
//             // style: ElevatedButton.styleFrom(primary: Colors.white),
//           ),
//         ),
//         Container(
//           height:60,
//           width: 60,
//           // margin: EdgeInsets.only(top:10),
//           decoration: BoxDecoration(
//               color:Color(0xFFeef2fb) ,
//               borderRadius: BorderRadius.circular(30)
//           ),
//           child: IconButton(
//             onPressed: ()=>facebookSignUpButton(),
//             // label: Text('', style: Theme.of(context).textTheme.headline1.copyWith(color: Colors.blue),),
//             icon: Image.asset("./assets/images/facebook_PNG.png",width: 300,height: 300,),
//             // style: ElevatedButton.styleFrom(primary: Colors.white),
//           ),
//         ),
//         Container(
//           height:60,
//           width: 60,
//           // margin: EdgeInsets.only(top:10),
//           decoration: BoxDecoration(
//               color:Color(0xFFeef2fb) ,
//               borderRadius: BorderRadius.circular(30)
//           ),
//           child: IconButton(
//             onPressed: ()=>googleSignInDialog(context),
//             // label: Text('', style: Theme.of(context).textTheme.headline1.copyWith(color: Colors.blue),),
//             icon: Image.asset("./assets/images/linkedin_PNG.png",width: 40,height: 40,),
//             // style: ElevatedButton.styleFrom(primary: Colors.white),
//           ),
//         ),
//       ],
//     ) ;
//   }
// }