import 'dart:io';

import 'package:flutter/material.dart';
import '../textfield_validator.dart';
import '../globals.dart' as globals;

class LeadingDropDownTextFormField extends StatefulWidget{
  
  final controller;
  final keyBoardType;
  // final textFieldLabel;
  final textFieldHint;
  final suffixIcon;
  final validator;
  final maxLength;
  final suffixIconOnTap;
  final textFieldReadOnlyFlag;
  LeadingDropDownTextFormField({
    this.controller,
    this.keyBoardType,
    // this.textFieldLabel,
    this.textFieldHint,
    this.suffixIcon,
    this.validator,
    this.maxLength,
    this.suffixIconOnTap,
    this.textFieldReadOnlyFlag
  });
  @override
  _LeadingDropDownTextFormFieldState createState() => _LeadingDropDownTextFormFieldState();
}

class _LeadingDropDownTextFormFieldState extends State<LeadingDropDownTextFormField> {
  FieldValidator fieldValidator=FieldValidator();
  String mobileEmailLeadingString='Work';
  @override
  Widget build(BuildContext context) {
      
    return  TextFormField(
      readOnly: widget.textFieldReadOnlyFlag,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator:widget.validator,
      controller: widget.controller,
      maxLength: widget.maxLength,
      keyboardType: widget.keyBoardType,
      style: Theme.of(context).textTheme.bodyText1,
      // textInputAction: TextInputAction.done,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        // labelText: widget.textFieldLabel,
        hintText: widget.textFieldHint,
        prefixIcon: Container(
          width:100,
          height: 60,
          margin: EdgeInsets.only(left: 2,top: 2,bottom: 2),
          child: DropdownButtonFormField<String>(
            // autovalidateMode: AutovalidateMode.onUserInteraction,
            // validator: (value)=>value==null?'Please Select Installment Type':null,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
            ),
            value: mobileEmailLeadingString,
            items: <String>['Work','Home'].map((String value) {
              return  DropdownMenuItem<String>(
                value: value,
                child: Container(
                    child: Text(value,style: TextStyle(fontSize: 14,fontFamily: 'Poppins',color: Color(0xFF546b8a)),)
                ),
              );
            }).toList(),
            onChanged: (value) =>setState((){
              mobileEmailLeadingString=value;
            }),
            isExpanded: true,
          ),
        ),
        suffixIcon:Container(
          child: InkWell(
            onTap:widget.suffixIconOnTap,
            child: widget.suffixIcon,
          ),
        ),
      ),
    );
  
  }
}