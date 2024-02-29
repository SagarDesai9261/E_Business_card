import 'package:flutter/material.dart';

class ContactUs extends StatelessWidget{
  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          titleSpacing: 0,
          leading: InkWell(
              onTap:()=>Navigator.of(context).pop(),
              child: Icon(Icons.arrow_back_ios,color: Colors.black,size: 18,)
          ),
          title: Text('Contact us',style: Theme.of(context).textTheme.headline5.copyWith(
              color: Colors.black,fontSize: 18
          ),),
        ),
        body:Container(
          margin: const EdgeInsets.only(top:30,left:15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
                Text('Phone :',style:Theme.of(context).textTheme.headline5.copyWith(
                    fontSize:16,color:Colors.black,fontWeight: FontWeight.w600
                  ) ,
                ),
              SizedBox(height:5 ,),
              Row(
                  children: [
                    Icon(Icons.phone,color: Color(0xFF3277bc),),
                    SizedBox(width:15 ,),
                    Text('+971 4 3873 522',style: Theme.of(context).textTheme.headline6
                    )
                  ],
                ),
              SizedBox(height:5 ,),
              Row(
                children: [
                  Icon(Icons.phone,color:Color(0xFF3277bc)),
                  SizedBox(width:15 ,),
                  Text('+971 55 2198 410',style: Theme.of(context).textTheme.headline6)
                ],
              ),
              SizedBox(height: 20,),
              Text('Email :',style:Theme.of(context).textTheme.headline5.copyWith(
                  fontSize:16,color:Colors.black,fontWeight: FontWeight.w600
                ) ,
              ),
              SizedBox(height:5 ,),
              Row(
                children: [
                  Icon(Icons.email,color: Color(0xFF3277bc),),
                  SizedBox(width:15 ,),
                  Text('info@wewant360.com',style: Theme.of(context).textTheme.headline6)
                ],
              ),
              SizedBox(height: 20,),
              Text('Address :',style:Theme.of(context).textTheme.headline5.copyWith(
                  fontSize:16,color:Colors.black,fontWeight: FontWeight.w600
                ) ,
              ),
              SizedBox(height:5 ,),
              Row(
                children: [
                  Icon(Icons.location_on ,color: Color(0xFF3277bc),),
                  SizedBox(width:15 ,),
                  Flexible(
                    child: Container(
                      padding: EdgeInsets.only(right:10),
                      child: Text('17 The Iridium Building, Umm Suqeim Road, Al Barsha, P.O. Box 391186, Dubai, UAE',
                          style: Theme.of(context).textTheme.headline6
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        )
    );
  }

}