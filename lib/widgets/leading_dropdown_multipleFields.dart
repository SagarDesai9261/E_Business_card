import 'dart:io';

import 'package:flutter/material.dart';
import '../textfield_validator.dart';
import '../globals.dart' as globals;

class LeadingDropDownMultipleFields extends StatefulWidget{

  final controller;
  final keyBoardType;
  // final textFieldLabel;
  final textFieldHint;
  final suffixIcon;
  final validator;
  final maxLength;
  final suffixIconOnTap;
  final textFieldReadOnlyFlag;
  final List<String> leadingDropDownItems;
  final int index;
  final Function onTextFieldTypeChange;
  final String selectedDropDownValue;
  LeadingDropDownMultipleFields({
    this.controller,
    this.keyBoardType,
    // this.textFieldLabel,
    this.textFieldHint,
    this.suffixIcon,
    this.validator,
    this.maxLength,
    this.suffixIconOnTap,
    this.textFieldReadOnlyFlag,
    this.leadingDropDownItems=const[],
    this.index,
    @required this.onTextFieldTypeChange,
    this.selectedDropDownValue='Select Type'
  });
  @override
  _LeadingDropDownMultipleFieldsState createState() => _LeadingDropDownMultipleFieldsState();
}

class _LeadingDropDownMultipleFieldsState extends State<LeadingDropDownMultipleFields> {
  FieldValidator fieldValidator=FieldValidator();
  String mobileEmailLeadingString='Select Type';
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
      // focusNode: FocusNode(canRequestFocus: false),
      // textInputAction: TextInputAction.done,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        // labelText: widget.textFieldLabel,
        hintText: widget.textFieldHint,
        prefixIcon: InkWell(
          onTap: (){
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          child: Container(
            width:110,
            height: 60,
            margin: EdgeInsets.only(left: 2,top: 2,bottom: 2),
            child: DropdownButtonFormField<String>(
              // autovalidateMode: AutovalidateMode.onUserInteraction,
              // validator: (value)=>value==null?'Please Select Installment Type':null,
              // focusNode: FocusNode(canRequestFocus: false),
              decoration: InputDecoration(
                border: OutlineInputBorder(),
              ),
              value: widget.selectedDropDownValue,
              items:widget.leadingDropDownItems.map((String value) {
                return  DropdownMenuItem<String>(
                  value: value,
                  child: Container(
                      child: Text(value,style: TextStyle(fontSize: 14,fontFamily: 'Poppins',color: Color(0xFF546b8a)),)
                  ),
                );
              }).toList(),
              onChanged: (value) =>setState((){
                mobileEmailLeadingString=value;
                widget.onTextFieldTypeChange(index:widget.index,type:value);
                FocusScope.of(context).requestFocus(new FocusNode());
              }),
              isExpanded: true,
            ),
          ),
        ),
        contentPadding: EdgeInsets.zero,
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