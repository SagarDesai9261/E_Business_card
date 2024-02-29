import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
class TimePickerWidget extends StatefulWidget {

  final bool textFieldReadOnlyFlag;
  final TextEditingController timeController;

  const TimePickerWidget({Key key, this.textFieldReadOnlyFlag=false, this.timeController}) : super(key: key);
  @override
  _TimePickerWidgetState createState()
  {
    return _TimePickerWidgetState();
  }
}

class _TimePickerWidgetState extends State<TimePickerWidget> {
  TimeOfDay selectedTime = TimeOfDay.now();

  @override
  void initState() {
    super.initState();
    if(widget.timeController.text.isNotEmpty
        && !widget.timeController.text.toLowerCase().contains('am')
        && !widget.timeController.text.toLowerCase().contains('pm')
    ){
      var s=widget.timeController.text;
      setState(() {
        selectedTime=TimeOfDay(hour:int.parse(s.split(":")[0]),minute: int.parse(s.split(":")[1]));
      });
      widget.timeController.text=formatTimeOfDay(selectedTime);
    }
  }
  @override
  Widget build(BuildContext context) {
    return  Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        InkWell(
          onTap: () {
            _selectTime(context);
          },
          child: TextFormField(
            onTap: () {
              _selectTime(context);
            },
            readOnly: true,
            autofocus: false,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            // validator: (value){
            //   return fieldValidator.titleValidator(value);
            // },
            controller: widget.timeController,
            keyboardType: TextInputType.text,
            style: Theme.of(context).textTheme.bodyText1,
            decoration: InputDecoration(
              isDense: true,
              border: OutlineInputBorder(),
              // labelText: 'First Name',
              hintText: '00:00',
              suffixIcon: Icon(Icons.access_time)
            ),
          ),
        ),
        // Text("${formatTimeOfDay(selectedTime)}"),
      ],
    );
  }
  _selectTime(BuildContext context) async {
    final TimeOfDay timeOfDay = await showTimePicker(
      context: context,
      initialTime: selectedTime,
      initialEntryMode: TimePickerEntryMode.dial,
    );

    print('selected Time :$timeOfDay');
    if(timeOfDay != null
        // && timeOfDay != selectedTime
    )
    {
      setState(() {
        selectedTime = timeOfDay;
        widget.timeController.text=formatTimeOfDay(selectedTime);
      });
    }
  }
  String formatTimeOfDay(TimeOfDay tod) {
    final now = new DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, tod.hour, tod.minute);
    final format = DateFormat.jm();  //"6:00 AM"
    return format.format(dt);
  }

}