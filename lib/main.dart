import 'package:flutter/material.dart';
import 'package:holiday/views/holidaycalendar.dart';
import 'package:holiday/views/login.dart';
import 'package:holiday/views/register.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    //home: Register(),
//home: Login(),
home: HolidayCalendar(userData: null,),
  ));
}

