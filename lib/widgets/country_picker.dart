import 'package:flutter/material.dart';
// import 'package:country_picker/country_picker.dart';
// import 'package:country_state_city_picker/country_state_city_picker.dart';

class CountryPickerWidget extends StatefulWidget {

  final textFieldReadOnlyFlag;
  final countryController;
  CountryPickerWidget({this.textFieldReadOnlyFlag,this.countryController});
  @override
  _CountryPickerWidgetState createState() => _CountryPickerWidgetState();
}

class _CountryPickerWidgetState extends State<CountryPickerWidget> {
  DateTime _selectedDate;
  @override
  Widget build(BuildContext context) {

    return TextFormField(
      readOnly: widget.textFieldReadOnlyFlag,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: widget.countryController,
      keyboardType: TextInputType.text,
      style: Theme.of(context).textTheme.bodyText1,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        hintText: 'Country',
      ),
      focusNode: AlwaysDisabledFocusNode(),
      onTap: () {
        _selectCountry(context);
      },
    );
  }

  _selectCountry(BuildContext context) async {
    // SelectState(
    //   onCountryChanged: (value) {
    //     setState(() {
    //       widget.countryController.text+= value;
    //     });
    //   },
    //   onStateChanged:(value) {
    //     setState(() {
    //       widget.countryController.text+= value;
    //     });
    //   },
    //   onCityChanged:(value) {
    //     setState(() {
    //       widget.countryController.text+= value;
    //     });
    //   },
    //
    // );
    //  showCountryPicker(
    //    countryListTheme:CountryListThemeData(
    //      inputDecoration:  InputDecoration(
    //        border: OutlineInputBorder(),
    //        hintText: 'Search',
    //        prefixIcon: Icon(Icons.search)
    //      ),
    //    ),
    //   context: context,
    //   showPhoneCode: true, // optional. Shows phone code before the country name.
    //   onSelect: (Country country) {
    //     print('Select country: ${country.displayName}');
    //     widget.countryController.text=country.displayName;
    //   },
    // );
    //
    // if (newSelectedDate != null) {
    //   _selectedDate = newSelectedDate;
    //   widget.dateController
    //     ..text = DateFormat('y-MM-dd').format(_selectedDate)
    //     ..selection = TextSelection.fromPosition(TextPosition(
    //         offset: widget.dateController.text.length,
    //         affinity: TextAffinity.upstream));
    // }
  }
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}