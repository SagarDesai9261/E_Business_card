
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ConstantMethod{
  static String formatTimeOfDay(TimeOfDay tod) {
    final now = new DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, tod.hour, tod.minute);
    final format = DateFormat.jm();  //"6:00 AM"
    return format.format(dt);
  }
  static String formatAMPMtoTimeOfDay(String time) {
    if(time.isEmpty)return '';
    if(!time.contains('AM') || !time.contains("PM"))
      return time;
    // // parse date
    DateTime date= DateFormat.jm().parse(time);
    // DateTime date2= DateFormat("hh:mma").parse("6:45PM"); // think this will work better for you
    // format date
    print('format data: $time');
    print('format1: '+DateFormat("HH:mm").format(date));
    // print('format2: '+DateFormat("HH:mm").format(date2));
    return '${DateFormat("HH:mm").format(date)}';
  }
}