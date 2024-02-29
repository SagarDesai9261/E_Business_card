import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../screens/checkout_screen.dart';
class YearlyPlans extends StatefulWidget{
  @override
  _YearlyPlansState createState() => _YearlyPlansState();
}

class _YearlyPlansState extends State<YearlyPlans> {
  @override
  Widget build(BuildContext context) {
   return SingleChildScrollView(
     child: Column(
       children: [
          Card(
            elevation: 10,
            margin: EdgeInsets.all(20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Container(
              margin: EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('Basic',style: Theme.of(context).textTheme.headline6.copyWith(fontSize: 14,fontWeight: FontWeight.w700 ),),
                  SizedBox(height: 8,),
                  Text('AED 0.00/Year',style: Theme.of(context).textTheme.headline6.copyWith(fontSize: 18,fontWeight: FontWeight.w500)),
                  SizedBox(height: 8,),
                  Container(
                      child: Text('Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque tellus tortor, venenatis non nulla nec, ullamcorper iaculis lorem Quisque tellus tortor, venenatis non nulla nec, ullamcorper iaculis lorem.'
                      ,textAlign: TextAlign.justify,
                      style: Theme.of(context).textTheme.headline5.copyWith(fontSize: 16,fontWeight: FontWeight.w300)
                      )
                  ),
                  SizedBox(height: 8,),
                  Text('Plan Features:',style: Theme.of(context).textTheme.headline6.copyWith(fontSize: 15,fontWeight: FontWeight.w500)),
                  SizedBox(height: 8,),
                  Text('1 Cards',style: Theme.of(context).textTheme.headline5.copyWith(fontSize: 20,fontWeight: FontWeight.w300)),
                  SizedBox(height: 8,),
                  ElevatedButton(
                      onPressed: (){
                        Navigator.of(context).push(CupertinoPageRoute(builder: (context)=>CheckoutScreen(
                          planName: "Classic",
                          planDescription: "Lorem ipsum dolor sit amet, lorem ipsum dolor sit amet commodo dolor pharetra rhoncus. Quisque libero eros, egestas quis porta ac, lorem ipsum dolor sit amet.",
                          planInvoiceInterval: "Month",
                          planInvoicePeriod: "1",
                          planPrice: "150.00 INR",
                        )));
                      }, child: Text('Choose Plan',style: Theme.of(context).textTheme.headline1)
                  )
                ],
              ),
            ),
          )
       ],
     ),
   );
  }
}