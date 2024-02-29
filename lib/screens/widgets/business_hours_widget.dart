
import 'package:e_business_card/screens/widgets/time_picker_widget.dart';
import 'package:flutter/material.dart';

class BusinessHourWidget extends StatefulWidget{
  final List<dynamic> businessHourWidgetList;

  const BusinessHourWidget({Key key, this.businessHourWidgetList=const[]}) : super(key: key);

  @override
  State<BusinessHourWidget> createState() => _BusinessHourWidgetState();
}

class _BusinessHourWidgetState extends State<BusinessHourWidget> {

  @override
  Widget build(BuildContext context,) {

    return Column(
      children: [
        for(int i=0;i<widget.businessHourWidgetList.length;i++)
        Column(
          children: [
            Tooltip(
              message: 'On/Off',
              child: CheckboxListTile(
                  controlAffinity: ListTileControlAffinity.leading,
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                  value: widget.businessHourWidgetList[i]['status']??false,
                  onChanged: (val){
                    setState(() {
                      widget.businessHourWidgetList[i]['status']=val;
                    });
                   },
                  title: Text(
                    '${widget.businessHourWidgetList[i]['title']}'
                  ),
              ),
            ),
            Row(
              children: [
                Container(
                    width: MediaQuery.of(context).size.width*0.25,
                    padding: EdgeInsets.only(left: 5,right: 10),
                    child: Text('Start Time',style: Theme.of(context).textTheme.headline6?.copyWith(color:Color(0xFF8897a8)),)
                ),
                Expanded(
                  child:
                  // DateTimePicker(
                  //   type: DateTimePickerType.time,
                  //   controller: widget.businessHourWidgetList[i]['start_time'],
                  //   use24HourFormat: false,
                  //   // initialTime: ,
                  //   // timePickerEntryModeInput: true,
                  //   decoration: InputDecoration(
                  //     contentPadding: EdgeInsets.only(left: 15),
                  //     suffixIcon: Icon(Icons.access_time),
                  //     border: OutlineInputBorder(
                  //       borderRadius: BorderRadius.circular(4),
                  //       borderSide: BorderSide(
                  //         width: 4.0,
                  //         color: Colors.black,
                  //       ),
                  //     ),
                  //     floatingLabelBehavior: FloatingLabelBehavior.always,
                  //   ),
                  //   // dateMask: 'd MMM, yyyy',
                  //   // initialValue: DateTime.now().toString(),
                  //   // initialValue: '00:00',
                  //   locale: const Locale('en', 'US'),
                  //   firstDate: DateTime(2000),
                  //   lastDate: DateTime(2100),
                  //   // icon: Icon(Icons.event),
                  //   dateLabelText: '',
                  //   timeLabelText: "",
                  //   selectableDayPredicate: (date) {
                  //     // Disable weekend days to select from the calendar
                  //     if (date.weekday == 6 || date.weekday == 7) {
                  //       return false;
                  //     }
                  //
                  //     return true;
                  //   },
                  //   onChanged: (val) {
                  //     setState(() {
                  //       print(val);
                  //     });
                  //   },
                  //   validator: (val) {
                  //     print(val);
                  //     setState(() {
                  //       print(val);
                  //     });
                  //     return null;
                  //   },
                  //   onSaved: (val) {
                  //     print(val);
                  //     setState(() {
                  //       print(val);
                  //     });
                  //   },
                  // ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8,right: 8),
                    child: TimePickerWidget(
                      textFieldReadOnlyFlag: false,
                      timeController: widget.businessHourWidgetList[i]['start_time'],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10,),
            Row(
              children: [
                Container(
                    width: MediaQuery.of(context).size.width*0.25,
                    padding: EdgeInsets.only(left: 5,right: 10),
                    child: Text('End Time',style: Theme.of(context).textTheme.headline6?.copyWith(color:Color(0xFF8897a8)),)
                ),
                Expanded(
                  child:
                  // DateTimePicker(
                  //   type: DateTimePickerType.time,
                  //   controller: widget.businessHourWidgetList[i]['end_time'],
                  //   use24HourFormat: false,
                  //   decoration: InputDecoration(
                  //     contentPadding: EdgeInsets.only(left: 15),
                  //     suffixIcon: Icon(Icons.access_time)
                  //   ),
                  //   // dateMask: 'd MMM, yyyy',
                  //   // initialValue: DateTime.now().toString(),
                  //   // initialValue: '00:00',
                  //   locale: const Locale('en', 'US'),
                  //   firstDate: DateTime(2000),
                  //   lastDate: DateTime(2100),
                  //   // icon: Icon(Icons.event),
                  //   dateLabelText: '',
                  //   timeLabelText: "",
                  //   selectableDayPredicate: (date) {
                  //     // Disable weekend days to select from the calendar
                  //     if (date.weekday == 6 || date.weekday == 7) {
                  //       return false;
                  //     }
                  //     return true;
                  //   },
                  //
                  //   onChanged: (val) {
                  //     setState(() {
                  //       print("on Change:${val.runtimeType}");
                  //     });
                  //   },
                  //   validator: (val) {
                  //     print(val);
                  //     return null;
                  //   },
                  //   onSaved: (val) => print("on save:$val"),
                  // ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8,right: 8),
                    child: TimePickerWidget(
                      textFieldReadOnlyFlag: false,
                      timeController: widget.businessHourWidgetList[i]['end_time'],
                    ),
                  ),
                ),
              ],
            )
          ],
        )
      ],
    );
  }


}