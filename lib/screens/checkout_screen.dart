import 'dart:io';

import 'package:flutter/material.dart';
// import 'package:flutter_braintree/flutter_braintree.dart';
// import 'package:razorpay_flutter/razorpay_flutter.dart';
// import 'package:stripe_payment/stripe_payment.dart';
import '../widgets/checkout_rounded_checkbox.dart';



class CheckoutScreen extends StatefulWidget {
  final planName;
  final planDescription;
  final planPrice;
  final planInvoicePeriod;
  final planInvoiceInterval;

  CheckoutScreen(
      {this.planDescription,
      this.planInvoiceInterval,
      this.planInvoicePeriod,
      this.planName,
      this.planPrice});
  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  bool stripeCheck = false;
  bool paypalCheck = false;
  bool razorpayCheck = false;
   PreferredSize appbar;
  // Razorpay _razorpay;
  bool paypalIndecatorFlag = false;

  // Token _stripePaymentToken;
  // PaymentMethod _stripePaymentMethod;
  // String _stripeError;

  //this client secret is typically created by a backend system
  //check https://stripe.com/docs/payments/payment-intents#passing-to-client

  // PaymentIntentResult _paymentIntent;
  // Source _source;
  ScrollController _controller = ScrollController();
  @override
  void initState() {
    super.initState();
    appbar = PreferredSize(
      preferredSize: const Size.fromHeight(50.0),
      child: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          'Checkout',
          style: TextStyle(
              color: Colors.black,
              fontFamily: "Poppins",
              fontSize: 20,
              fontWeight: FontWeight.w600),
        ),
      ),
    );

    // _razorpay = Razorpay();
    // _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    // _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    // _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);

    // StripePayment.setOptions(StripeOptions(
    //     publishableKey: "pk_test_51JItG0SDalmtDyePvWEYviMtRwQCBRzaG7mBhhwmfGI7WXIlpMgyjTBl2AozFzqCbBqGJLbwkg5FmkRVuEoFg5Xy00urbbO2kb",
    //     merchantId: "Test",
    //     androidPayMode: 'test'));
  }

  // void _handlePaymentSuccess(PaymentSuccessResponse response) {
  //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Payment Success'),duration: const Duration(seconds: 2),),);
  //   Navigator.popUntil(context, (route) => route.isFirst);
  // }
  //
  // void _handlePaymentError(PaymentFailureResponse response) {
  //   print("razorpay error response:$response");
  //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Payment Failed'),duration: const Duration(seconds: 2),),);
  //   // Navigator.popUntil(context, (route) => route.isFirst);
  // }
  //
  // void _handleExternalWallet(ExternalWalletResponse response) {
  //   // Do something when an external wallet was selected
  // }
  void stripeSetError(dynamic error) {
    print("stripe error:$error");
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("Payment Failed")));
    setState(() {
      // _stripeError = error.toString();
    });
    // Navigator.popUntil(context, (route) => route.isFirst);
  }

  void stripe() {
    if (Platform.isIOS) {
      _controller.jumpTo(450);
    }

    // StripePayment.paymentRequestWithNativePay(
    //   androidPayOptions: AndroidPayPaymentRequest(
    //     totalPrice: "1.10",
    //     currencyCode: "INR",
    //   ),
    //   applePayOptions: ApplePayPaymentOptions(
    //     countryCode: 'IN',
    //     currencyCode: 'INR',
    //     items: [
    //       ApplePayItem(
    //         label: '${widget.planName}',
    //         amount: '1.00',
    //       )
    //     ],
    //   ),
    // ).then((token) {
    //   setState(() {
    //     ScaffoldMessenger.of(context).showSnackBar(
    //         SnackBar(content: Text('Received ${token.tokenId}')));
    //     _stripePaymentToken = token;
    //   });
    //
    //   StripePayment.completeNativePayRequest().then((_) {
    //     ScaffoldMessenger.of(context).showSnackBar(
    //         SnackBar(content: Text('Payment Completed successfully')));
    //   }).catchError(stripeSetError);
    //
    // }).catchError(stripeSetError);
  }

  void payPal() async {
    setState(() {
      paypalIndecatorFlag = true;
    });

    /*
    print("paypal call");
    final request = BraintreePayPalRequest(amount: '1',currencyCode: "USD",displayName:"eBusinessCard",billingAgreementDescription: "");
    BraintreePaymentMethodNonce result = await Braintree.requestPaypalNonce(
      'sandbox_zj9pfm8h_fvrwvyvzc96f7p58',
      request,
    ).then((value) {
      print("then paypal: $value");
      if(value==null){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Payment Cancelled !")));
        // Navigator.popUntil(context, (route) => route.isFirst);
      }
      setState(() {
        paypalIndecatorFlag=false;
      });
      return;
    });*/

    // final request = BraintreeDropInRequest(
    //   // clientToken: 'access_token\$production\$nj2dwpnqgrw9t2k7\$1bcad14c01b8201150a8fcda2aacdf11',
    //   tokenizationKey: "sandbox_zj9pfm8h_fvrwvyvzc96f7p58",
    //   collectDeviceData: true,
    //   paypalRequest: BraintreePayPalRequest(
    //     amount: '100.20',
    //     displayName: 'eBusinessCard',
    //     currencyCode: "INR",
    //   ),
    // );
    // BraintreeDropInResult result = await BraintreeDropIn.start(request).then((value){ Navigator.of(context).pop();});

    /*
    if (result != null) {
      print('Nonce: ${result}');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Payment Success")));
      Navigator.popUntil(context, (route) => route.isFirst);
    } else {
      print('PayPal flow was cancelled.');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Payment Failed")));
    }*/
  }

  void razorPay() {
    print("razorpay call");
    var options = {
      'key': 'rzp_live_yoBumfcK9ZTq4C',
      'amount': 100,
      'name': 'Premium',
      'description': 'Test Plan',
      'prefill': {'contact': '8780155870', 'email': 'shiyalalpesh99@gmail.com'},
      "external": {
        "wallets": ["paytm"]
      }
    };

    try {
      // _razorpay.open(options);
    } catch (e) {
      print('Razorpay exception:$e');
    }
  }

  void proceedButtonOnClick() {
    if (paypalCheck) {
      setState(() {
        payPal();
      });
    } else if (razorpayCheck) {
      setState(() {
        razorPay();
      });
    } else if (stripeCheck) {
      setState(() {
        stripe();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Please select payment method !")));
    }
  }

  @override
  void dispose() {
    super.dispose();
    // _razorpay.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbar,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              // height: MediaQuery.of(context).size.height-MediaQuery.of(context).padding.top-appbar.preferredSize.height,
              padding: const EdgeInsets.only(
                left: 15,
                right: 15,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    // mainAxisAlignment: MainAxisAlignment.start,
                    // crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Selected Plan name',
                            style: Theme.of(context)
                                .textTheme
                                .headline6
                                .copyWith(
                                    fontSize: 14, fontWeight: FontWeight.w700),
                          ),
                          Text(
                            widget.planName.toString(),
                            style: Theme.of(context)
                                .textTheme
                                .headline5
                                .copyWith(fontSize: 12),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Plan description',
                            style: Theme.of(context)
                                .textTheme
                                .headline6
                                .copyWith(
                                    fontSize: 14, fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                      Text(
                        widget.planDescription.toString(),
                        textAlign: TextAlign.justify,
                        style: Theme.of(context)
                            .textTheme
                            .headline5
                            .copyWith(fontSize: 12),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Plan Price',
                            style: Theme.of(context)
                                .textTheme
                                .headline6
                                .copyWith(
                                    fontSize: 14, fontWeight: FontWeight.w700),
                          ),
                          Text(
                            widget.planPrice.toString(),
                            style: Theme.of(context)
                                .textTheme
                                .headline5
                                .copyWith(fontSize: 12),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Plan invoice period',
                            style: Theme.of(context)
                                .textTheme
                                .headline6
                                .copyWith(
                                    fontSize: 14, fontWeight: FontWeight.w700),
                          ),
                          Text(
                            widget.planInvoicePeriod,
                            style: Theme.of(context)
                                .textTheme
                                .headline5
                                .copyWith(fontSize: 12),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Plan invoice interval',
                            style: Theme.of(context)
                                .textTheme
                                .headline6
                                .copyWith(
                                    fontSize: 14, fontWeight: FontWeight.w700),
                          ),
                          Text(
                            widget.planInvoiceInterval.toString(),
                            style: Theme.of(context)
                                .textTheme
                                .headline5
                                .copyWith(fontSize: 12),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Divider(
                        color: Colors.black,
                      ),
                      Container(
                        padding: const EdgeInsets.only(left: 12),
                        width: double.infinity,
                        alignment: Alignment.centerLeft,
                        height: 60,
                        color: Color(0xFFeef2fb),
                        child: Text(
                          'Select payment option',
                          style: Theme.of(context).textTheme.headline6.copyWith(
                              fontSize: 18, fontWeight: FontWeight.w600),
                        ),
                      ),
                      Divider(
                        color: Colors.black,
                      ),
                    ],
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        stripeCheck = true;
                        paypalCheck = false;
                        razorpayCheck = false;
                      });
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          child: ClipRRect(
                              child: Image.asset(
                            "./assets/images/stripe.png",
                            width: 200,
                            height: 200,
                          )),
                        ),
                        Text(
                          'Stripe',
                          style: Theme.of(context).textTheme.headline6.copyWith(
                              fontSize: 14, fontWeight: FontWeight.w700),
                        ),
                        SizedBox(
                          width: 150,
                        ),
                        CheckoutRoundedCheckbox(
                          checked: stripeCheck,
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    color: Colors.black,
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        stripeCheck = false;
                        paypalCheck = true;
                        razorpayCheck = false;
                      });
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          child: ClipRRect(
                              child: Image.asset("./assets/images/paypal.png")),
                        ),
                        Text(
                          'Paypal',
                          style: Theme.of(context).textTheme.headline6.copyWith(
                              fontSize: 14, fontWeight: FontWeight.w700),
                        ),
                        SizedBox(
                          width: 150,
                        ),
                        CheckoutRoundedCheckbox(
                          checked: paypalCheck,
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    color: Colors.black,
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        stripeCheck = false;
                        paypalCheck = false;
                        razorpayCheck = true;
                      });
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                            width: 60,
                            height: 60,
                            child: ClipRRect(
                                child: Image.asset(
                                    "./assets/images/razorpay.png",
                                    width: 200,
                                    height: 200))),
                        Text(
                          'Razorpay',
                          style: Theme.of(context).textTheme.headline6.copyWith(
                              fontSize: 14, fontWeight: FontWeight.w700),
                        ),
                        SizedBox(
                          width: 140,
                        ),
                        CheckoutRoundedCheckbox(
                          checked: razorpayCheck,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 120,
                    // padding: EdgeInsets.only(top: 100,bottom: 100),
                    height: 50,
                    child: ElevatedButton(
                        onPressed: proceedButtonOnClick,
                        child: Text('Proceed',
                            style: Theme.of(context).textTheme.headline1)),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
            Visibility(
              visible: paypalIndecatorFlag,
              child: Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height -
                    appbar.preferredSize.height -
                    MediaQuery.of(context).padding.top,
                color: Color.fromRGBO(0, 0, 0, 0.4),
                child: Center(
                    // child: Container(
                    //   height: 100,
                    //   width: 100,
                    //     padding: EdgeInsets.all(30),
                    //     decoration: BoxDecoration(
                    //       color: Color.fromRGBO(0, 0, 0, 0.4),
                    //       borderRadius: BorderRadius.all(Radius.circular(10))
                    //     ),
                    child: CircularProgressIndicator.adaptive()
                    // ),
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
