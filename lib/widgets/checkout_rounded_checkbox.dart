import 'package:flutter/material.dart';

class CheckoutRoundedCheckbox extends StatefulWidget{
  final checked;
  CheckoutRoundedCheckbox({this.checked});
  @override
  _CheckoutRoundedCheckboxState createState() => _CheckoutRoundedCheckboxState();
}

class _CheckoutRoundedCheckboxState extends State<CheckoutRoundedCheckbox> {
  @override
  Widget build(BuildContext context) {

    return  Container(
      width: 27,
      height: 27,
      margin: const EdgeInsets.only(right: 10),
      decoration: BoxDecoration(shape: BoxShape.circle, color:widget.checked?Colors.blue:Colors.white,
          border: Border.all(color: Colors.black)
      ),
      child: Padding(
        padding: const EdgeInsets.all(0.0),
        child: widget.checked
            ? Icon(
          Icons.check,
          size: 20.0,
          color: Colors.white,
        )
            : Icon(
          Icons.check_box_outline_blank,
          size: 25.0,
          color: Colors.white,
        ),
      ),
    );
  }
}