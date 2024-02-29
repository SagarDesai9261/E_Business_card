  import 'package:e_business_card/screens/widgets/time_picker_widget.dart';
import 'package:flutter/material.dart';

class AppointmentWidget extends StatefulWidget {
  final List<dynamic> appointmentWidgetList;

  const AppointmentWidget({Key key, this.appointmentWidgetList = const []})
      : super(key: key);

  @override
  State<AppointmentWidget> createState() => _AppointmentWidgetState();
}

class _AppointmentWidgetState extends State<AppointmentWidget> {
  void removeAppointmentWidget(index) {
    setState(() {
      widget.appointmentWidgetList.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Table(
      columnWidths: const <int, TableColumnWidth>{
        0: FlexColumnWidth(),
        1: FlexColumnWidth(),
        2: FixedColumnWidth(64),
      },
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: [
        TableRow(children: [
          Text('Staring Hour',
              style: Theme.of(context)
                  .textTheme
                  .headline6
                  ?.copyWith(color: Color(0xFF8897a8))),
          Text('Ending Hour',
              style: Theme.of(context)
                  .textTheme
                  .headline6
                  ?.copyWith(color: Color(0xFF8897a8))),
          Container(
              height: 50,
              alignment: Alignment.center,
              child: Text('Delete',
                  style: Theme.of(context)
                      .textTheme
                      .headline6
                      ?.copyWith(color: Color(0xFF8897a8)))),
        ]),
        for (int i = 0; i < widget.appointmentWidgetList.length; i++)
          TableRow(children: [
            Padding(
              padding: const EdgeInsets.only(top: 8, right: 8),
              child: TimePickerWidget(
                textFieldReadOnlyFlag: false,
                timeController: widget.appointmentWidgetList[i]['start_hour'],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8, right: 8),
              child: TimePickerWidget(
                textFieldReadOnlyFlag: false,
                timeController: widget.appointmentWidgetList[i]['end_hour'],
              ),
            ),
            IconButton(
                onPressed: () => removeAppointmentWidget(i),
                icon: Icon(
                  Icons.delete,
                  color: Colors.red,
                ))
          ])
      ],
    );
  }
}
