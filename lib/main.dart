import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:study_hub/services/auth.dart';
import 'package:study_hub/wrapper.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:study_hub/services/notifications.dart';

FlutterLocalNotificationsPlugin fltrNotification;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    initializeDateFormatting('az');
    return StreamProvider<User>.value(
        value:AuthService().user,
        child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
              primaryColor: Color(0xFF00417D),
              visualDensity: VisualDensity.adaptivePlatformDensity,
              textTheme: TextTheme(headline1: TextStyle(fontFamily: 'Abel'),)
          ),
          home: Wrapper(),
        ),
      );
  }
}
