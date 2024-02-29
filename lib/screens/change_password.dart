import 'package:flutter/material.dart';

import './login_screen.dart';
import '../textfield_validator.dart';

class ChangePasswordScreen extends StatefulWidget {
  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final passwordController = TextEditingController();
  final confirmPassController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final FieldValidator fieldValidator = FieldValidator();
  bool _passwordVisible = true;
  bool _confirmPassVisible = true;

   PreferredSizeWidget appbar;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbar,
      body: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
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
                'Change Password',
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
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        return fieldValidator.passwordValidator(value.toString());
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
                    TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        return fieldValidator.passwordValidator(value.toString());
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
                    Padding(padding: const EdgeInsets.all(8)),
                    Container(
                        height: 45,
                        width: 230,
                        margin: EdgeInsets.only(top: 10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30)),
                        child: ElevatedButton(
                            onPressed: () {},
                            child: Text(
                              'Change Password',
                              style: Theme.of(context).textTheme.headline1,
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
                            style:
                                Theme.of(context).textTheme.headline5.copyWith(
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
