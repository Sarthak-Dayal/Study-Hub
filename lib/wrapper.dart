import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'file:///C:/Users/dayal/AndroidStudioProjects/study_hub/lib/pages/BeforeLogin/login_page.dart';
import 'file:///C:/Users/dayal/AndroidStudioProjects/study_hub/lib/pages/AfterLogin/schedule.dart';

class Wrapper extends StatefulWidget {
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  @override
  void initState() {
    super.initState();
    Firebase.initializeApp().whenComplete(() {
      setState(() {});
    });
  }
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return user==null ? LoginPage():SchedulePage();
  }
}
