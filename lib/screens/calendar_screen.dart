import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../src/bloc/Data_Bloc.dart';
import '../globals.dart' as globals;
import 'package:flutter_bloc/flutter_bloc.dart';

import '../src/bloc/Data_Events.dart';
import '../src/bloc/Data_State.dart';
import '../src/repositories/DataApiClient.dart';
import '../src/repositories/Data_Repository.dart';

class CalenderScreen extends StatefulWidget {
  const CalenderScreen({Key key}) : super(key: key);

  @override
  State<CalenderScreen> createState() => _CalenderScreenState();
}

class _CalenderScreenState extends State<CalenderScreen> {
   DataBloc _dataBloc;
  bool visibleBloc = false;
  List<dynamic> appointmentlist = [];

  @override
  void initState() {
    getAllCalender();
    super.initState();
  }

  void getAllCalender() {
    visibleBloc = true;

    var url = '${globals.API_URL}/api/get_calander_appointment_details';

    _dataBloc = DataBloc(
        dataRepository: DataRepository(
            dataApiClient: DataApiClient(
      url: url,
    )));
    _dataBloc.add(FetchData());
    setState(() {
      // editdone = false;
    });
  }

  Future apiResponse(List<Object> responseData) async {
    print("Calling");
    setState(() {
      print('api response data: ${responseData}');
      visibleBloc = false;
    });

    Map<String, dynamic> responseMap = responseData[0] as Map<String, dynamic>;

    if (responseMap['status'].toString() == '1') {
      setState(() {
        appointmentlist = responseMap['result'];
      });
      if (responseMap['message'].runtimeType == String) {
      } else {
        List<Object> messageList = responseMap['message'];
        for (int i = 0; i < messageList.length; i++) {}
      }
      setState(() {});
      // if (emptyDataFlag) {
      //   print("emptydata flag:${emptyDataFlag}");
      //   setState(() {
      //     getAllContactCardInfo();
      //   });
      // }
      // emptyDataFlag =
      //     false; //when first record is inserted user can click on home icon
    }

    print('userid: ${globals.USER_ID}');
    print('token : ${globals.USER_TOKEN}');
  }

  Future getAllCardApiResponse(List<Object> responseData) async {
    print('Main Screen List responce: $responseData');
    setState(() {
      visibleBloc = false;
    });

    Map<String, Object> responseMap = responseData[0] as Map<String, Object>;
    if (responseMap['status'] == '1') {
      appointmentlist = responseMap['result'] as List<dynamic>;
    } else {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60.0),
          child: AppBar(
            systemOverlayStyle: SystemUiOverlayStyle.dark,
            automaticallyImplyLeading: false,
            title: Image.asset(
              'assets/images/logo.png',
              height: 210,
              width: 210,
            ),
            centerTitle: false,
          ),
        ),
        body: visibleBloc
            ? BlocBuilder<DataBloc, UsersState>(
                bloc: _dataBloc,
                builder: (context, state) {
                  print(state);
                  if (state is UsersLoading) {
                    return Center(
                      child: CircularProgressIndicator(
                        backgroundColor: Theme.of(context).primaryColorDark,
                      ),
                    );
                  }
                  if (state is UsersLoaded) {
                    if (visibleBloc)
                      WidgetsBinding.instance.addPostFrameCallback(
                          (_) => apiResponse(state.responseData));
                    else
                      WidgetsBinding.instance.addPostFrameCallback(
                          (_) => getAllCardApiResponse(state.responseData));
                  }
                  if (state is UsersError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Something went Wrong, Lets Try Again..',
                            style: Theme.of(context).textTheme.headline6,
                          ),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                if (visibleBloc) getAllCalender();
                                if (visibleBloc) visibleBloc = false;
                              });
                            },
                            child: Text(
                              "Retry",
                              style: Theme.of(context).textTheme.headline2,
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  return Container();
                })
            : SfCalendar(
                view: CalendarView.month,
                dataSource: MeetingDataSource(_getDataSource()),
                // by default the month appointment display mode set as Indicator, we can
                // change the display mode as appointment using the appointment display
                // mode property
                monthViewSettings: const MonthViewSettings(
                    showAgenda: true,
                    appointmentDisplayMode:
                        MonthAppointmentDisplayMode.indicator),
              ));
  }
   List<Meeting> _getDataSource() {
     final List<Meeting> meetings = <Meeting>[];

     for (var i = 0; i < appointmentlist.length; i++) {
       try {
         DateTime enddate = DateTime.parse(appointmentlist[i]["end_date_time"].replaceAll('  ', ' '));
         print("End  $enddate");

         DateTime startdate = DateTime.parse(appointmentlist[i]["start_date_time"].replaceAll('  ', ' '));
         print("start $startdate");

         final DateTime today = DateTime.now();
         final DateTime startTime = DateTime(today.year, today.month, today.day, 9);
         print("Start $startTime");

         final DateTime endTime = startTime.add(const Duration(hours: 2));

         meetings.add(Meeting(
             appointmentlist[i]["name"], startTime, endTime, const Color(0xFF0F8644), false));
       } catch (e) {
         print("Error parsing date: ${appointmentlist[i]["start_date_time"]}");
         // Handle the error as needed, you might want to skip this item or log the error
       }
     }

     return meetings;
   }



}

/// An object to set the appointment collection data source to calendar, which
/// used to map the custom appointment data to the calendar appointment, and
/// allows to add, remove or reset the appointment collection.
class MeetingDataSource extends CalendarDataSource {
  /// Creates a meeting data source, which used to set the appointment
  /// collection to the calendar
  MeetingDataSource(List<Meeting> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return _getMeetingData(index).from;
  }

  @override
  DateTime getEndTime(int index) {
    return _getMeetingData(index).to;
  }

  @override
  String getSubject(int index) {
    return _getMeetingData(index).eventName;
  }

  @override
  Color getColor(int index) {
    return _getMeetingData(index).background;
  }

  @override
  bool isAllDay(int index) {
    return _getMeetingData(index).isAllDay;
  }

  Meeting _getMeetingData(int index) {
    final dynamic meeting = appointments[index];
     Meeting meetingData;
    if (meeting is Meeting) {
      meetingData = meeting;
    }

    return meetingData;
  }
}

/// Custom business object class which contains properties to hold the detailed
/// information about the event data which will be rendered in calendar.
class Meeting {
  /// Creates a meeting class with required details.
  Meeting(this.eventName, this.from, this.to, this.background, this.isAllDay);

  /// Event name which is equivalent to subject property of [Appointment].
  String eventName;

  /// From which is equivalent to start time property of [Appointment].
  DateTime from;

  /// To which is equivalent to end time property of [Appointment].
  DateTime to;

  /// Background which is equivalent to color property of [Appointment].
  Color background;

  /// IsAllDay which is equivalent to isAllDay property of [Appointment].
  bool isAllDay;
}
