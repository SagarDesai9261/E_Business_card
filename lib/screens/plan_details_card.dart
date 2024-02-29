import 'package:flutter/material.dart';

class PlanDetailsCard extends StatelessWidget{
  final planStatus;
  PlanDetailsCard({this.planStatus});
  @override
  Widget build(BuildContext context) {
    return  Card(
      elevation: 5,
      margin: EdgeInsets.only(left:10,right: 10,bottom: 10,),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.all(15),
        // padding: EdgeInsets,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    height: 40,
                    width: 40,
                    padding: EdgeInsets.all(1),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.all(Radius.circular(40)),
                    ),
                    child: Container(
                        margin: EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          // color: Colors.black,
                          border: Border.all(
                              color: Colors.white,
                              width: 2
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        ),
                        child: Icon(Icons.format_list_bulleted, color: Color(0xFFffffff), )
                    )
                ),
                SizedBox(width: 8,),
                Expanded(
                  child: Column(
                    // crossAxisAlignment: CrossAxisAlignment.,
                    children: [
                      SizedBox(height: 8,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                              alignment: Alignment.centerLeft,
                              child: Text(planStatus?'Your Current Plan':'Plan',style: Theme.of(context).textTheme.headline5.copyWith(fontSize: 12,fontWeight: FontWeight.w300 ),)
                          ),
                          Row(
                            children: [
                              Container(
                                height: 10,width: 10,decoration: BoxDecoration(color:planStatus?Colors.green:Colors.deepOrange, borderRadius: BorderRadius.all(Radius.circular(10)),),
                              ),
                              SizedBox(width: 2,),
                              Text(planStatus?'Active':'Cancelled',style: Theme.of(context).textTheme.headline5.copyWith(fontSize: 12,fontWeight: FontWeight.w300 ),),
                            ],
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Premium',style: Theme.of(context).textTheme.headline6.copyWith(fontSize: 16,fontWeight: FontWeight.w700 ),),
                          Text('AED 100.00',style: Theme.of(context).textTheme.headline6.copyWith(fontSize: 16,fontWeight: FontWeight.w700 ),),
                        ],
                      ),
                      Container(alignment: Alignment.centerLeft,child: Text('2021-08-18 22:55:45',style: Theme.of(context).textTheme.headline5.copyWith(fontSize: 12,fontWeight: FontWeight.w400),)),
                      SizedBox(height: 10,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Card Limit',style: Theme.of(context).textTheme.headline5.copyWith(fontSize: 12,fontWeight: FontWeight.w400 ),),
                          Text('100',style: Theme.of(context).textTheme.headline5.copyWith(fontSize: 12),),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Uses Limit',style: Theme.of(context).textTheme.headline5.copyWith(fontSize: 12,fontWeight: FontWeight.w400 ),),
                          Text('45',style: Theme.of(context).textTheme.headline5.copyWith(fontSize: 12),),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Billing Period',style: Theme.of(context).textTheme.headline5.copyWith(fontSize: 12,fontWeight: FontWeight.w400),),
                          Text('Yearly',style: Theme.of(context).textTheme.headline5.copyWith(fontSize: 12),),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

}