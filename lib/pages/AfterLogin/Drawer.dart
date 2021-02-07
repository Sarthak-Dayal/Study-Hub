import 'package:flutter/material.dart';
import 'package:study_hub/pages/AfterLogin/Assessments.dart';
import 'package:study_hub/pages/AfterLogin/Dashboard.dart';
import 'package:study_hub/pages/AfterLogin/Tasks.dart';
import 'package:study_hub/services/auth.dart';
import '../BeforeLogin/login_page.dart' as loginPage;
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'Materials.dart';
import 'schedule.dart' as schedule;

class SideDrawer extends StatefulWidget {
  String page;
  SideDrawer({@required this.page});
  @override
  _SideDrawerState createState() => _SideDrawerState(page:page,);
}

class _SideDrawerState extends State<SideDrawer> {
  String page;
  _SideDrawerState({@required this.page});
  AuthService _auth = AuthService();
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    String email = user!=null?user.email:"";
    bool isSchedule;
    bool isAssessments;
    bool isDashboard;
    bool isTasks;
    bool isMaterials;
    switch(page){
      case "schedule":{
        isSchedule = true;
        break;
      }
      case "assessments":{
        isAssessments = true;
        break;
      }
      case "dashboard":{
        isDashboard = true;
        break;
      }
      case "tasks":{
        isTasks = true;
        break;
      }
      case "materials":{
      isMaterials = true;
      break;
    }
    }
    final contextHeight = MediaQuery.of(context).size.height;
    return Drawer(
      child: Container(
        color: Color(0xFFDEF3FF),
        child: ListView(
          children: [
            Container(
              height: 1.0 / 9 * contextHeight,
              child: DrawerHeader(
                child: Center(
                  child: Text(
                    'Study Hub',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 36.0*contextHeight/850.9090909090909,
                        color: Colors.white,
                        fontFamily: 'Abel'),
                  ),
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
            ExpansionTile(
                leading: Icon(
                  Icons.account_box,
                  color: Theme.of(context).primaryColor,
                ),
                title: Text(
                  "Account",
                  style: TextStyle(
                    fontSize: 24.0/850.9090909090909*contextHeight,
                    fontFamily: 'Abel',
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                children: [
                  Container(
                    color: Theme.of(context).primaryColor,
                    child: Column(
                      children: [
                        ListTile(
                          onTap: () {
                            Navigator.of(context).popUntil((route) => route.isFirst);
                            _auth.signOutFromApp();
                          },
                          leading: Icon(
                            Icons.person,
                            color: Colors.white,
                          ),
                          title: Text(
                            "Sign out",
                            style: TextStyle(
                              fontSize: 24.0/850.9090909090909*contextHeight,
                              fontFamily: 'Abel',
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Theme(
                          data: ThemeData(
                            accentColor: Colors.white,
                            unselectedWidgetColor: Colors.white,
                          ),
                          child: ExpansionTile(
                            leading: Icon(
                              Icons.email,
                              color: Colors.white,
                            ),
                            title: Text(
                              "Email:",
                              style: TextStyle(
                                fontSize: 24.0/850.9090909090909*contextHeight,
                                fontFamily: 'Abel',
                                color: Colors.white,
                              ),
                            ),
                            children: [
                              Container(
                                color: Colors.white,
                                child: ListTile(
                                  title: Text(
                                    email,
                                    style: TextStyle(
                                      fontSize: 24.0/850.9090909090909*contextHeight,
                                      fontFamily: 'Abel',
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ]),
            Container(
              color: isSchedule==true?Color(0xFFDEF3DD):null,
              child: ListTile(
                onTap: (){
                  isSchedule==true?Navigator.pop(context):Navigator.push(context, MaterialPageRoute(builder: (context)=>schedule.SchedulePage()));
                },
                leading: Icon(
                  Icons.schedule,
                  color: Theme.of(context).primaryColor,
                ),
                title: Text(
                  "Schedule",
                  style: TextStyle(
                    fontSize: 24.0/850.9090909090909*contextHeight,
                    color: Theme.of(context).primaryColor,
                    fontFamily: 'Abel',
                  ),
                ),
              ),
            ),
            Container(
              color: isAssessments==true?Color(0xFFDEF3DD):null,
              child: ListTile(
                onTap: () {
                  isAssessments==true?Navigator.pop(context):Navigator.push(context, MaterialPageRoute(builder: (context)=>AssessmentsPage()));
                },
                leading: Icon(
                  Icons.assessment,
                  color: Theme.of(context).primaryColor,
                ),
                title: Text(
                  "Assessments",
                  style: TextStyle(
                    fontSize: 24.0/850.9090909090909*contextHeight,
                    color: Theme.of(context).primaryColor,
                    fontFamily: 'Abel',
                  ),
                ),
              ),
            ),
            Container(
              color: isDashboard==true?Color(0xFFDEF3DD):null,
              child: ListTile(
                onTap: () {
                  isDashboard==true?Navigator.pop(context):Navigator.push(context, MaterialPageRoute(builder: (context)=>DashboardPage()));
                },
                leading: Icon(
                  Icons.dashboard,
                  color: Theme.of(context).primaryColor,
                ),
                title: Text(
                  "Dashboard",
                  style: TextStyle(
                    fontSize: 24.0/850.9090909090909*contextHeight,
                    color: Theme.of(context).primaryColor,
                    fontFamily: 'Abel',
                  ),
                ),
              ),
            ),
            Container(
              color: isTasks==true?Color(0xFFDEF3DD):null,
              child: ListTile(
                onTap: () {
                  isTasks==true?Navigator.pop(context):Navigator.push(context, MaterialPageRoute(builder: (context)=>TasksPage()));
                },
                leading: Icon(
                  Icons.check_circle,
                  color: Theme.of(context).primaryColor,
                ),
                title: Text(
                  "Tasks",
                  style: TextStyle(
                    fontSize: 24.0/850.9090909090909*contextHeight,
                    color: Theme.of(context).primaryColor,
                    fontFamily: 'Abel',
                  ),
                ),
              ),
            ),
            Container(
              color: isMaterials==true?Color(0xFFDEF3DD):null,//TODO: Change to new isMaterials variable
              child: ListTile(
                onTap: () {
                  isMaterials==true?Navigator.pop(context):Navigator.push(context, MaterialPageRoute(builder: (context)=>MaterialsPage()));
                },
                leading: Icon(
                  Icons.book,
                  color: Theme.of(context).primaryColor,
                ),
                title: Text(
                  "Materials",
                  style: TextStyle(
                    fontSize: 24.0/850.9090909090909*contextHeight,
                    color: Theme.of(context).primaryColor,
                    fontFamily: 'Abel',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
