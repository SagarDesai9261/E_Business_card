import 'dart:async';
import 'dart:convert' show json, jsonDecode;
import 'dart:math';
import 'package:e_business_card/src/bloc/Data_Bloc.dart';
import 'package:e_business_card/src/bloc/Data_Events.dart';
import "package:http/http.dart" as http;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:checkbox_formfield/checkbox_formfield.dart';
import 'package:shared_preferences/shared_preferences.dart';



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

import '../src/bloc/Data_State.dart';
import './login_screen.dart';
import '../textfield_validator.dart';
import '../src/repositories/repositories.dart';
import '../globals.dart' as globals;
import './main_screen.dart';


import 'package:google_sign_in/google_sign_in.dart';
// import 'package:flutter_facebook_login/flutter_facebook_login.dart';

GoogleSignIn _googleSignIn = GoogleSignIn(
  // Optional clientId
  // clientId: '479882132969-9i9aqik3jfjd7qhci1nqf0bm2g71rm1u.apps.googleusercontent.com',
  scopes: <String>[
    'profile',
    'email',
    'https://www.googleapis.com/auth/contacts',
    'https://www.googleapis.com/auth/contacts.readonly',
    'https://www.googleapis.com/auth/profile.language.read',
    'https://www.googleapis.com/auth/user.addresses.read',
    'https://www.googleapis.com/auth/user.birthday.read',
    'https://www.googleapis.com/auth/user.emails.read',
    'https://www.googleapis.com/auth/user.phonenumbers.read',
    'https://www.googleapis.com/auth/user.organization.read',
    'https://www.googleapis.com/auth/userinfo.profile',
    'https://www.googleapis.com/auth/userinfo.email',
    'https://www.googleapis.com/auth/directory.readonly'
  ],
);

class RegistrationScreen extends StatefulWidget{
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final usernameController=TextEditingController();
  final emailController=TextEditingController();
  final userTypeController=TextEditingController(text: 'Company');
  final passwordController=TextEditingController();
  final confirmPassController=TextEditingController();
  final _formKey=GlobalKey<FormState>();
  final FieldValidator fieldValidator=FieldValidator();
  bool _passwordVisible=true;
  bool _confirmPassVisible=true;
  bool iAgreeFlag=false;
  bool visibleBloc=false;
  bool socialLoginBloc=false;
  bool autoValidatorForCheckBox=false;
  bool googleSignInContinueFlag=false;
  DataBloc _dataBloc;
  String socialType;
  GoogleSignInAccount _currentUser;
  String _contactText = '';
  String firstName,lastName,pageUrl,officeNumber,mobile1,mobile2,email1,email2,address,city,country,state,postalCode,avatarFile,companyFile;

  final String linkedinRedirectUrl = 'http://localhost:3001/eBusinessCard';
  final String linkedinClientId = '788wrk62sv1q6w';
  final String linkedinClientSecret = 'Mt6bGX9jEUHSwhk2';
  var userTypeItems = [
    'Company',
    'User'
  ];
  void registerButtonClick()
  {
    print("User name: ${emailController.text}");

    visibleBloc=true;

    var url = '${globals.API_URL}/api/register';
    var data = {
      "name": usernameController.text,
      "email":emailController.text,
      "type":userTypeController.text.toLowerCase(),
      "password":passwordController.text,
    };

    _dataBloc=DataBloc(
        dataRepository: DataRepository(
            dataApiClient: DataApiClient(
              url: url,
              data: data,
            )
        )
    );
    _dataBloc.add(FetchData());
  }

  void showMsg(List<Object> responseData){

    setState(() {
      print('show msg response data: ${responseData[0].runtimeType}');
      visibleBloc=false;
    });

    Map<String,dynamic> responseMap=responseData[0];
    print('show msg response Map: ${responseMap['status']}');
    if(responseMap['message'].runtimeType==String){
      showSnackBar(responseMap['message']);
    }else{
      List<Object> messageList=responseMap['message'];
      for(int i=0;i<messageList.length;i++)
      {
        showSnackBar(messageList[i]);
      }
    }


    if(responseMap['status']==1){
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>LoginScreen()));
    }




    //Google Sign in
    // if(googleSignInContinueFlag){
    //   if(responseMap['status']=='Success'){
    //     ScaffoldMessenger.of(context).showSnackBar(
    //       SnackBar( content: Text("SuccessFully Registered with Google"),
    //         duration: const Duration(seconds: 3),
    //       ),
    //     );
    //     Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>LoginScreen()));
    //   }
    // }
    // //




  }
  void socialLoginApiCall(userEmail,userToken,type)
  {
    print("Social api call");
    print("User name: ${userEmail.toString()}");
    print("User UserToken: ${userToken.toString()}");
    print("User type: ${type.toString()}");

    socialLoginBloc=true;

    var url = '${globals.API_URL}/api/sociallogin';
    var data = {
      "user_email":userEmail.toString(),
      "access_token":userToken.toString(),
      "type":type.toString(),
    };

    _dataBloc=DataBloc(
        dataRepository: DataRepository(
            dataApiClient: DataApiClient(
              url: url,
              data: data,
            )
        )
    );
    _dataBloc.add(FetchData());
  }

  void socialLoginApiResponce(List<Object> responseData)async{


    Map<String,Object> responseMap=responseData[0];

    if(responseMap['status']=='Success'){
      Map<String,Object> data=responseMap['data'];

      globals.USER_ID=data['user_id'];
      globals.USER_NAME=data['user_name'];
      globals.USER_EMAIL=data['user_email'];
      globals.USER_TOKEN=data['csrf_token'];
      globals.USER_PASSWORD=passwordController.text;
      globals.REMEMBER_ME="no";
      globals.LOGIN="login";
      globals.SOCIAL_TYPE=socialType;

      // if(checkBoxValue){
      SharedPreferences preferences=await SharedPreferences.getInstance();
      preferences.setString('user_id', globals.USER_ID);
      preferences.setString('user_name', globals.USER_NAME);
      preferences.setString('user_email', globals.USER_EMAIL);
      preferences.setString('user_token', globals.USER_TOKEN);
      preferences.setString('user_password', globals.USER_PASSWORD);
      preferences.setString('remember_me', globals.REMEMBER_ME);
      preferences.setString('user_login', globals.LOGIN);
      preferences.setString('social_type', globals.SOCIAL_TYPE);

      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>MainScreen()));
    }else {
      setState(() {
        print('show msg response data: ${responseData[0].runtimeType}');
        socialLoginBloc=false;
      });

      List<Object> messageList = responseMap['message'];
      for (int i = 0; i < messageList.length; i++) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(messageList[i]),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount account) {
      setState(() {
        _currentUser = account;
        print("current user: ${_currentUser}");
      });
      // if (_currentUser != null) {
      //   _handleGetContact(_currentUser);
      // }
    });
    _googleSignIn.signInSilently();
    // LinkedInLogin.initialize(context,
    //     clientId: linkedinClientId,
    //     clientSecret: linkedinClientSecret,
    //     redirectUri: linkedinRedirectUrl,
    // );
  }
  // Future<void> _handleGetContact(GoogleSignInAccount user) async {
  //   setState(() {
  //     _contactText = "Loading contact info...";
  //   });
  //   final http.Response response = await http.get(
  //     Uri.parse('https://people.googleapis.com/v1/people/me/connections'
  //         '?requestMask.includeField=person.names'),
  //     headers: await user.authHeaders,
  //   );
  //   if (response.statusCode != 200) {
  //     setState(() {
  //       _contactText = "People API gave a ${response.statusCode} "
  //           "response. Check logs for details.";
  //     });
  //     print('People API ${response.statusCode} response: ${response.body}');
  //     return;
  //   }
  //   final Map<String, dynamic> data = json.decode(response.body);
  //
  //   print("Google Contacts: $data");
  //   final String namedContact = _pickFirstNamedContact(data);
  //   setState(() {
  //     if (namedContact != null) {
  //       _contactText = "I see you know $namedContact!";
  //     } else {
  //       _contactText = "No contacts to display.";
  //     }
  //   });
  // }

  Future<void> _getAllGoogleInfo(GoogleSignInAccount user) async {



    final http.Response response = await http.get(
      Uri.parse('https://people.googleapis.com/v1/people/${user.id}'
          '?personFields=addresses,ageRanges,biographies,birthdays,calendarUrls,clientData,coverPhotos,emailAddresses,events,externalIds,genders,imClients,interests,locales,locations,memberships,miscKeywords,names,nicknames,occupations,organizations,phoneNumbers,relations,sipAddresses,skills,urls,userDefined'),
      headers: await user.authHeaders,
    );




    print("user header:${user}");
    if (response.statusCode != 200) {
      setState(() {
        _contactText = "People API gave a ${response.statusCode} response. Check logs for details.";
      });
      print('People API ${response.statusCode} response: ${response.body}');
      return;
    }
    final Map<String, dynamic> data = json.decode(response.body);
    data.map((key, value) {
      print("$key : $value");return;
    });
    // print("google response data: $data}");
    avatarFile=user.photoUrl;
    var displayName=user.displayName.split(" ");
    firstName=displayName[0];
    lastName=displayName[1];
    print("First name:$firstName");
    print("last name:$lastName");

    pageUrl=user.email.toString().replaceAll(" ","_");
    pageUrl=user.email.toString().replaceAll(".","");
    // pageUrl=user.email.toString().replaceAll(" ","_");
    // pageUrl=pageUrl.replaceAll(r"[\-\+\.\^:,]","_");
    pageUrl=pageUrl.split("@")[0];
    pageUrl="$pageUrl${Random().nextInt(9999)}";

    print("Page Url :$pageUrl");

    // print("Google all Info: $data");
    if(data['names']!=null) {
      List<Object> names = data['names'];
      // print("Names object :${names}");
    }
    if(data['phoneNumbers']!=null) {
      List<dynamic> phoneNumbers = data['phoneNumbers'];
      mobile1=phoneNumbers[0]['value'];
      if(phoneNumbers.length<=2)
        mobile2=phoneNumbers[1]['value'];
      print("Mobile 1:${mobile1}");
      print("Mobile 2:${mobile2}");
    }
    if(data['emailAddresses']!=null) {
      List<dynamic> emailAddresses = data['emailAddresses'];
      email1=emailAddresses[0]['value'];
      email2="";
      // if(emailAddresses.length<=2)
      //   email2=emailAddresses[1]['value'];
      print("email 1:${email1}");
      print("email 2:${email2}");
    }
    if(data['addresses']!=null) {
      List<dynamic> addresses = data['addresses'];
      address=addresses[0]['formattedValue'];
      print("address :${address}");
    }
    if(data['coverPhotos']!=null) {
      List<dynamic> coverPhotos = data['coverPhotos'];
      companyFile=coverPhotos[0]['url'];
      print("avatar Url :${avatarFile}");
      print("Cover Url :${companyFile}");
    }

    data.forEach((key, value) {
      // print("$key :$value ");

    });
  }

  String _pickFirstNamedContact(Map<String, dynamic> data) {
    final List<dynamic> connections = data['connections'];
    final Map<String, dynamic> contact = connections?.firstWhere(
          (dynamic contact) => contact['names'] != null,
      orElse: () => null,
    );
    if (contact != null) {
      final Map<String, dynamic> name = contact['names'].firstWhere(
            (dynamic name) => name['displayName'] != null,
        orElse: () => null,
      );
      if (name != null) {
        return name['displayName'];
      }
    }
    return null;
  }

  Future<void> _handleSignIn() async {
    // Navigator.of(context).pop();
    String googleToken="";
    try {
      var user1 =await _googleSignIn.signIn().then((result){
        result.authentication.then((googleKey)async{
          print("google all:${googleKey}");
          print("id token: ${googleKey.idToken}");
          print("google token :${googleKey.accessToken}");

          setState(() {
            googleToken=googleKey.accessToken;
          });
          var user =await _googleSignIn.signIn();
          print("new login user:${googleToken}");
          if(user!=null)
          {
            setState(() {
              _currentUser=user;
              googleSignInDialog(context,googleToken);
            });
            // _getAllGoogleInfo(_currentUser);
          }

        }).catchError((err){
          print('inner error');
        });
      }).catchError((err){
        print('error occured');
      });


    } catch (error) {
      print("Sign in error :$error");
    }
  }
  Future<void> _handleSignOut() {
     Navigator.of(context).pop();
     setState(() {
       _googleSignIn.disconnect();
       _currentUser.clearAuthCache();
     });
  }
  void googleSignInDialog(BuildContext ctx,googleToken)
  {
    print('show dialog called');
    WidgetsBinding.instance.addPostFrameCallback((_) =>
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            GoogleSignInAccount user = _currentUser;

            print("Google user :$user");
            print("Google Token :$googleToken");
            if (user != null) {
              return Dialog(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
            child: Container(
            height: 300,
            width:350,
            child:Column(
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
                  TextButton(onPressed:()=> googleContinueSignUpButton(googleToken), child: Text('Continue',style:Theme.of(context).textTheme.headline5.copyWith(
                    fontSize: 18,color:Color(0xFF006ade),
                  ))),
                  // Text(_contactText),
                  ElevatedButton(
                    child: Text('Sign Out',style:Theme.of(context).textTheme.headline1),
                    onPressed: _handleSignOut,
                  ),
                  // ElevatedButton(
                  //   child: const Text('REFRESH'),
                  //   onPressed: () => _handleGetContact(user),
                  // ),
                ],
              )
              ));
            } else {
              return Dialog(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                child: Container(
                height: 400,
                width:350,
                child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  const Text("You are not currently signed in."),
                  ElevatedButton(
                    child: Text('SIGN IN',style:Theme.of(context).textTheme.headline1,),
                    onPressed: (){
                      setState(() {
                        _handleSignIn();
                      });

                    },
                  ),
                ],
            )));
          }
        }
    ));
  }

  void googleContinueSignUpButton(googleToken){
      // usernameController.text=_currentUser.displayName;
      // emailController.text=_currentUser.email;
      // passwordController.text=_currentUser.id;
      setState(() {
        // googleSignInContinueFlag=true;
        socialType="google";
        socialLoginApiCall(_currentUser.email,googleToken,"google");
      });
      Navigator.of(context).pop();
  }

  void facebookSignUpButton()async
  {
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
    //     // _sendTokenToServer(result.accessToken.token);
    //     // _showLoggedInUI();
    //     break;
    //   case FacebookLoginStatus.cancelledByUser:
    //     // _showCancelledMessage();
    //     break;
    //   case FacebookLoginStatus.error:
    //     // _showErrorOnUI(result.errorMessage);
    //     break;
    // }
  }
  void linkedinSignUpButton(){
    getAllInfoFromLinkedIn();return;
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

  void getAllInfoFromLinkedIn(){

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
    //
    // } )
    //     .catchError((error){
    //   print("error Linkedin${error.errorDescription}");
    // });
    //


  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body:
      visibleBloc==true||socialLoginBloc? BlocBuilder<DataBloc, UsersState>(
          bloc: _dataBloc,
          builder: (context, state) {
            if (state is UsersLoading) {
              return Center(
                child: CircularProgressIndicator(backgroundColor: Theme.of(context).primaryColorDark,),
              );
            }
            if (state is UsersLoaded) {
              if(socialLoginBloc)
              WidgetsBinding.instance.addPostFrameCallback((_) =>
                  socialLoginApiResponce(state.responseData));
              else
              WidgetsBinding.instance.addPostFrameCallback((_) =>
                  showMsg(state.responseData));
            }
            if (state is UsersError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Something went Wrong, Lets Try Again..',
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    TextButton(onPressed:(){
                      setState(() {
                        visibleBloc=false;
                      });
                    },
                      child: Text("Retry",
                        style: Theme.of(context).textTheme.headline2,
                      ),
                    ),
                  ],
                ),
              );
            }
            return Container();
          }):
      Container(
        width: double.infinity,
        child: ListView(
          children: [
            Container(
              alignment: Alignment.center,
              height:(MediaQuery.of(context).size.height-MediaQuery.of(context).padding.top)*0.3,
              child: Column(
                children: [
                  Image.asset('assets/images/logo.png',height: 180,width: 180,),
                  Text('Register Your Account',style: Theme.of(context).textTheme.headline2,),
                ],
              ),
            ),
            Padding(padding:const EdgeInsets.all(3)),
            // Container(
            //   alignment: Alignment.center,
            //   height:(MediaQuery.of(context).size.height-MediaQuery.of(context).padding.top)*0.1,
            //   width: double.infinity,
            //   child:Text('Register Your Account',style: Theme.of(context).textTheme.headline2,),
            // ),
            // SizedBox(height:(MediaQuery.of(context).size.height-MediaQuery.of(context).padding.top)*0.05,),
            Container(
              // height:(MediaQuery.of(context).size.height-MediaQuery.of(context).padding.top)*0.85,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(60),topRight: Radius.circular(60)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 10,
                    blurRadius: 5,
                    offset: Offset(0, 7), // changes position of shadow
                  ),
                ],
              ),
              padding:const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Container(height: 3,width: 30,decoration: BoxDecoration(color: Color(0xFFeef2fb)),alignment: Alignment.center,),
                    SizedBox(height: 15,),
                    TextFormField(
                      autofocus: false,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value){
                        return fieldValidator.nameValidator(value);
                      },
                      controller: usernameController,
                      keyboardType: TextInputType.text,
                      style: Theme.of(context).textTheme.bodyText1,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        // labelText: 'Email Address',
                        hintText: 'Username',
                      ),
                    ),
                    Padding(padding:const EdgeInsets.all(8)),
                    TextFormField(
                      autofocus: false,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value){
                        return fieldValidator.emailValidator(value);
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
                    Padding(padding:const EdgeInsets.all(8)),
                    DropdownButtonFormField(
                      // Initial Value
                      value: userTypeController.text,
                      // Down Arrow Icon
                      icon: const Icon(Icons.keyboard_arrow_down),
                      // Array list of items
                      items: userTypeItems.map((String items) {
                        return DropdownMenuItem(
                          value: items,
                          child: Text(items,style: Theme.of(context).textTheme.bodyText1?.copyWith(

                          ),),
                        );
                      }).toList(),
                      // After selecting the desired option,it will
                      // change button value to selected value
                      onChanged: (String newValue) {
                        setState(() {
                          userTypeController.text = newValue;
                        });
                      },
                    ),
                    Padding(padding:const EdgeInsets.all(8)),
                    TextFormField(
                      autofocus: false,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value){
                        return fieldValidator.passwordValidator(value);
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
                            _passwordVisible?Icons.visibility:Icons.visibility_off,
                          ),
                          color:  Color(0xFF546b8a),
                          onPressed: (){
                            setState(() {
                              _passwordVisible=!_passwordVisible;
                            });
                          },
                        ),
                      ),
                    ),
                    Padding(padding:const EdgeInsets.all(8)),
                    TextFormField(
                      autofocus: false,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value){
                        if(value.isEmpty)
                          return 'Confirm Password cant\'t  be  Empty.';
                        else if(value!=passwordController.text)
                          return 'Password do not match!';
                        return null;
                      },
                      controller: confirmPassController,
                      obscureText: _confirmPassVisible,
                      keyboardType: TextInputType.visiblePassword,
                      style: Theme.of(context).textTheme.bodyText1,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        // labelText:'Designation',
                        hintText: 'Confirm Password',
                        suffixIcon: IconButton(
                          icon: Icon(
                            _confirmPassVisible?Icons.visibility:Icons.visibility_off,
                          ),
                          color:  Color(0xFF546b8a),
                          onPressed: (){
                            setState(() {
                              _confirmPassVisible=!_confirmPassVisible;
                            });
                          },
                        ),
                      ),
                    ),
                   CheckboxListTileFormField(
                     initialValue: iAgreeFlag,
                      title:  Text(
                        "I agree with Privacy Policy.",
                        style: Theme.of(context).textTheme.headline6.copyWith(color:Color(0xFF546b8a)),
                      ),
                      activeColor: Theme.of(context).primaryColor,
                      onSaved: (bool value) {
                        // value=autoValidatorForCheckBox
                        print('i agree:$value');
                      },
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (bool value) {
                        iAgreeFlag=value;

                        if (value) {
                          return null;
                        } else {
                          return 'You Must Agree To Our Terms And Condition !';
                        }
                      },
                    ),
                    // CheckboxListTileFormField(
                    //   title: Text('I agree to the terms and condition'),
                    //   activeColor: Theme.of(context).primaryColor,
                    //   onSaved: (bool value) {},
                    //   autovalidate: true,
                    //   validator: (bool value) {
                    //     if (value) {
                    //       return null;
                    //     } else {
                    //       return 'You Must Agree To Our Terms And Condition !';
                    //     }
                    //   },
                    // ),
                    Container(
                        height:45,
                        width: 150,
                        margin: EdgeInsets.only(top:10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30)
                        ),
                        child: ElevatedButton(
                            onPressed: (){
                              setState(() {
                                autoValidatorForCheckBox=true;
                              });
                              if(_formKey.currentState.validate()){
                                setState(() {
                                  registerButtonClick();
                                });
                                print("register button click");
                              }
                            },
                            child: Text('Register',style: Theme.of(context).textTheme.headline1,))
                    ),
                    Padding(padding: EdgeInsets.all(10),),
                    RichText(
                      text: TextSpan(
                        style: TextStyle(fontSize: 15,fontWeight: FontWeight.normal,color: Theme.of(context).primaryColorDark),
                        children: <TextSpan>[
                          TextSpan(text: 'Already have a membership ? ',
                            style: Theme.of(context).textTheme.headline3.copyWith(
                            fontSize: 14
                            ),
                          ),
                          TextSpan(
                             text: 'Login',
                              style: Theme.of(context).textTheme.headline2.copyWith(
                                  fontSize: 14
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginScreen()));
                                }),
                        ],
                      ),
                    ),
                    Padding(padding: EdgeInsets.all(5),),
                    Visibility(
                        visible: false,
                        child: Text("OR",style:Theme.of(context).textTheme.headline3.copyWith(fontSize: 16),)
                    ),
                    Padding(padding: EdgeInsets.all(5),),
                    // SocialLoginWidget(),
                    Visibility(
                      visible: false,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                              height:60,
                              width: 60,
                              // margin: EdgeInsets.only(top:10),
                              decoration: BoxDecoration(
                                  color:Color(0xFFeef2fb) ,
                                  // border: Border.all(color: Colors.blueGrey),
                                  borderRadius: BorderRadius.circular(30)
                              ),
                            child:IconButton(
                                  onPressed: (){
                                    setState(() {
                                      _handleSignIn();
                                    });
                                  },
                                    // label: Text('', style: Theme.of(context).textTheme.headline1.copyWith(color: Colors.blue),),
                                    icon: Image.asset("./assets/images/google_PNG.png"),
                                    // style: ElevatedButton.styleFrom(primary: Colors.white),
                            ),
                          ),
                          Container(
                            height:60,
                            width: 60,
                            // margin: EdgeInsets.only(top:10),
                            decoration: BoxDecoration(
                                color:Color(0xFFeef2fb) ,
                                borderRadius: BorderRadius.circular(30)
                            ),
                            child: IconButton(
                                    onPressed: ()=>facebookSignUpButton(),
                                    // label: Text('', style: Theme.of(context).textTheme.headline1.copyWith(color: Colors.blue),),
                                    icon: Image.asset("./assets/images/facebook_PNG.png",width: 300,height: 300,),
                                    // style: ElevatedButton.styleFrom(primary: Colors.white),
                            ),
                          ),
                          Container(
                            height:60,
                            width: 60,
                            // margin: EdgeInsets.only(top:10),
                            decoration: BoxDecoration(
                                color:Color(0xFFeef2fb) ,
                                borderRadius: BorderRadius.circular(30)
                            ),
                            child: IconButton(
                                    onPressed: linkedinSignUpButton,
                                    // label: Text('', style: Theme.of(context).textTheme.headline1.copyWith(color: Colors.blue),),
                                    icon: Image.asset("./assets/images/linkedin_PNG.png",width: 40,height: 40,),
                                    // style: ElevatedButton.styleFrom(primary: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 60,),
                  ],
                ),
              ),
            )
          ],
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