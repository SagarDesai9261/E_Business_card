import 'package:flutter/material.dart';
import './plan_details_card.dart';

class PlanHistory extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.black),
          title: Text('Plan History',style: Theme.of(context).textTheme.headline6.copyWith(fontSize: 20,fontWeight: FontWeight.w600 ),) ,
        ),
        body: ListView.builder(itemBuilder: (context,index){
          return Column(
            children: [
              Container(
                margin: EdgeInsets.only(left: 10),
                alignment: Alignment.centerLeft,
                  child: Text('Aug 2021',style: Theme.of(context).textTheme.headline5.copyWith(fontSize: 16,fontWeight: FontWeight.w500 ),)),
              SizedBox(height: 10,),
              PlanDetailsCard(planStatus:index==0?true: false,),
              if(index!=0)Container(alignment: Alignment.center,child: Text('Cancelled on 2021-08-20 05:28:25',style: Theme.of(context).textTheme.headline5.copyWith(fontSize: 12),)),
              SizedBox(height: 10,),
            ],
          );
        },
        itemCount: 10,
        ),
      );
  }

}