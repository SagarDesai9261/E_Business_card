import 'package:flutter/material.dart';

class History extends StatelessWidget{
  @override
  Widget build(BuildContext context) {

    return LayoutBuilder(builder: (BuildContext ctx,BoxConstraints constraints){
      return Column(
        children: [
          Container(
            width: double.infinity,
            height:constraints.maxHeight*0.2,
            padding:  const EdgeInsets.only(left: 20),
            child: Text('History',style: Theme.of(context).textTheme.headline5.copyWith(
              fontSize: 20,
              color: Colors.black
            ),),
          ),
          Container(
            width: double.infinity,
            height:constraints.maxHeight*0.8,
            child: Center(
              child: Text('Your Profile reading history is empty!',style: Theme.of(context).textTheme.headline3.copyWith(
                fontSize: 14,
                color:Colors.black
              ),),
            ),
          ),
        ],
      );
    });
  }

}