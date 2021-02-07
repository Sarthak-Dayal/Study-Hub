import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class LogInFormData{
  String email;
  String password;

  LogInFormData({this.email, this.password});
}
class SignUpFormData{
  String email;
  String password;
  String confirmPassword;

  SignUpFormData({this.email, this.password, this.confirmPassword});
}
class ResetPasswordFormData{
  String email;
  ResetPasswordFormData({this.email});
}
class AddClassFormData{
  String className;
  DateTime startDate;
  DateTime endDate;
  TimeOfDay startTime;
  TimeOfDay endTime;
  List<bool> daysOfWeek;
  String classLink;

  AddClassFormData({this.className, this.startDate, this.endDate, this.startTime, this.endTime, this.daysOfWeek, this.classLink});
}
class AddAssessmentFormData{
  String assessmentName;
  DateTime date;
  TimeOfDay time;
  bool regRev;
  dynamic regRevStartDate;
  dynamic regRevInterval;
  String className;
  String type;
  AddAssessmentFormData({this.assessmentName, this.date, this.time, this.regRev, this.regRevStartDate, this.regRevInterval, this.className, this.type});
}

class AddTaskFormData{
  String TaskName;
  String className;
  Timestamp dateTime;
  bool remindMe;
  String type;

  AddTaskFormData({this.TaskName, this.className, this.dateTime, this.remindMe, this.type});
}
class ScoreData{
  String Type;
  int Score;
  Timestamp TimeEntered;
  String Year;
  ScoreData({this.Score, this.TimeEntered, this.Type, this.Year});
}
