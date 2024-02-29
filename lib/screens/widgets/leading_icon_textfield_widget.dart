import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../textfield_validator.dart';
import '../../globals.dart' as globals;

class LeadingIconTextFieldWidget extends StatefulWidget{

  final controller;
  final keyBoardType;
  final textFieldHint;
  final suffixIcon;
  final validator;
  final maxLength;
  final suffixIconOnTap;
  final textFieldReadOnlyFlag;
  final int index;
  final String prefixIcon;
  LeadingIconTextFieldWidget({
    this.controller,
    this.keyBoardType,
    // this.textFieldLabel,
    this.textFieldHint,
    this.suffixIcon,
    @required this.validator,
    this.maxLength,
    this.suffixIconOnTap,
    this.textFieldReadOnlyFlag,
    this.index,
    this.prefixIcon
  });
  @override
  _LeadingIconTextFieldWidgetState createState() => _LeadingIconTextFieldWidgetState();
}

class _LeadingIconTextFieldWidgetState extends State<LeadingIconTextFieldWidget> {
  FieldValidator fieldValidator=FieldValidator();
  String mobileEmailLeadingString='Select Type';
  @override
  Widget build(BuildContext context) {

    return  TextFormField(
      readOnly: widget.textFieldReadOnlyFlag,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator:(value)=>widget.validator(value),
      controller: widget.controller,
      maxLength: widget.maxLength,
      keyboardType: widget.keyBoardType,
      style: Theme.of(context).textTheme.bodyText1,
      focusNode: FocusNode(canRequestFocus: false),
      // textInputAction: TextInputAction.done,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        // labelText: widget.textFieldLabel,
        hintText: widget.textFieldHint,
        prefixIcon:Container(
          padding: EdgeInsets.all(5),
          child: SvgPicture.asset('${widget.prefixIcon}',
              // height: 35,width: 35,fit: BoxFit.contain,
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