import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:study_hub/pages/AddScreens/AddClass.dart';
import 'package:study_hub/pages/AfterLogin/ClassScreen.dart';
import 'package:study_hub/pages/AfterLogin/Drawer.dart';
import 'package:study_hub/services/auth.dart';
import '../BeforeLogin/login_page.dart' as loginPage;
import 'package:url_launcher/url_launcher.dart';
import 'package:study_hub/services/firestore.dart';
import 'package:intl/intl.dart';
var currentDropdownItemSelected = "2020 - 2021";
String email = loginPage.email;
FirestoreService firestoreService = new FirestoreService();
class SchedulePage extends StatefulWidget {
  @override
  _SchedulePageState createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  @override
  Widget build(BuildContext context) {
    DateTime now = new DateTime.now();
    List<String> yearOptions = [
      (now.year - 5).toString() + " - " + (now.year - 4).toString(),
      (now.year - 4).toString() + " - " + (now.year - 3).toString(),
      (now.year - 3).toString() + " - " + (now.year - 2).toString(),
      (now.year - 2).toString() + " - " + (now.year - 1).toString(),
      (now.year - 1).toString() + " - " + now.year.toString(),
      now.year.toString() + " - " + (now.year + 1).toString(),
      (now.year + 1).toString() + " - " + (now.year + 2).toString(),
      (now.year + 2).toString() + " - " + (now.year + 3).toString(),
      (now.year + 3).toString() + " - " + (now.year + 4).toString(),
      (now.year + 4).toString() + " - " + (now.year + 5).toString(),
      (now.year + 5).toString() + " - " + (now.year + 6).toString(),
    ];
    final contextHeight = MediaQuery.of(context).size.height;
    var preTextWidth = MediaQuery.of(context).size.width *
        (1.0 / 19.0) /
        850.9090909090909 *
        contextHeight;
    AuthService _auth = AuthService();
    final appBarHeight = 1.0 / 11 * contextHeight;
    BuildContext context2;
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        drawer: SideDrawer(page: "schedule"),
        body: Builder(builder: (context) {
          context2 = context;
          return Column(mainAxisAlignment: MainAxisAlignment.start, children: [
            SizedBox(
              height: 1.0 / 100.0 * contextHeight,
            ),
            Row(
              children: [
                SizedBox(
                  width: preTextWidth,
                ),
                Text(
                  "Year: ",
                  style: TextStyle(
                    fontSize: (18.0) / 850.9090909090909 * contextHeight,
                    color: Theme.of(context).primaryColor,
                    fontFamily: 'Abel',
                  ),
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(
                      5 / 850.9090909090909 * contextHeight),
                  child: SizedBox(
                    height: 30 / 850.9090909090909 * contextHeight,
                    child: Container(
                      color: Theme.of(context).primaryColor,
                      child: DropdownButton<String>(
                        dropdownColor: Theme.of(context).primaryColor,
                        iconEnabledColor: Colors.white,
                        iconDisabledColor: Colors.white,
                        items: yearOptions.map((String yearOption) {
                          return DropdownMenuItem(
                            value: yearOption,
                            child: Text(
                              "  " + yearOption,
                              style: TextStyle(
                                fontSize:
                                    18.0 / 850.9090909090909 * contextHeight,
                                color: Colors.white,
                                fontFamily: 'Abel',
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (String val) async{
                          currentDropdownItemSelected = val;
                          await firestoreService.getClasses(currentDropdownItemSelected);
                          await firestoreService.getClasses(currentDropdownItemSelected);
                          setState(() {});
                        },
                        value: currentDropdownItemSelected,
                      ),
                    ),
                  ),
                )
              ],
            ),
            SizedBox(height: 20.0,),
          BuildScheduleView(),
          ]);
        }),
        backgroundColor: Color(0xFFDEF3FF),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => AddClassPage()));
          },
          child: Image.asset("images/Add.png"),
          backgroundColor: Color(0xFFDEF3FF),
        ),
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(appBarHeight),
          child: ClipRRect(
            borderRadius:
                BorderRadius.circular(10 / 850.9090909090909 * contextHeight),
            child: AppBar(
              automaticallyImplyLeading: false,
              leading: Column(children: [
                SizedBox(
                  height: 16 / 850.9090909090909 * contextHeight,
                ),
                GestureDetector(
                  onTap: () {
                    Scaffold.of(context2).openDrawer();
                  },
                  child: Image.asset(
                    "images/MenuIcon.png",
                    scale: 1.25 * 850.9090909090909 / contextHeight,
                  ),
                ),
              ]),
              centerTitle: true,
              title: Column(children: [
                SizedBox(
                  height: (16) / 850.9090909090909 * contextHeight,
                ),
                Text(
                  "SCHEDULE",
                  style: TextStyle(
                    fontSize: (24.0) / 850.9090909090909 * contextHeight,
                    color: Colors.white,
                    fontFamily: 'Abel',
                  ),
                ),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}

class BuildScheduleView extends StatefulWidget {
  @override
  _BuildScheduleViewState createState() => _BuildScheduleViewState();
}

class _BuildScheduleViewState extends State<BuildScheduleView> {
  final firestoreInstance = FirebaseFirestore.instance;
  Future getClassesTwice() async {
    await firestoreService.getClasses(currentDropdownItemSelected);
    await firestoreService.getClasses(currentDropdownItemSelected);
  }
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final contextHeight = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
      child: SizedBox(
        height: 680/850.9090909090909 * contextHeight,
        width: 360/850.9090909090909 * contextHeight,
        child: FutureBuilder(
          future: getClassesTwice(),
          builder: (context, snapshot){
            if(snapshot.connectionState==ConnectionState.done) {
              if(firestoreService.returnList.isNotEmpty)return RefreshIndicator(
                onRefresh: () async{
                  print(currentDropdownItemSelected);
                  firestoreService.getClasses(
                    currentDropdownItemSelected);
                },
                child: ListView.builder(
                  physics: AlwaysScrollableScrollPhysics(),
                  itemCount: (firestoreService.returnList.length),
                  itemBuilder: (context, index) {
                    String DaysString = "";
                    List days = ["Su", "M", "Tu", "W", "Th", "F", "S"];
                    for (var i = 0; i < firestoreService.returnList[index].length; i++) {
                      if (firestoreService.returnList[index][1][i]) DaysString += days[i];
                    }
                    String startTime = "${DateFormat.jm("en").format(
                        firestoreService.returnList[index][4].toDate())}";
                    String endTime = "${DateFormat.jm("en").format(
                        firestoreService.returnList[index][5].toDate())}";
                    final Link = firestoreService.returnList[index][6].toString();
                    return Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            color: Color(0XFFEFEEEE),
                            child: SizedBox(
                              height: 75/850.9090909090909 * contextHeight,
                              width: MediaQuery.of(context).size.width,
                              child: ListTile(
                                onTap: (){
                                  List x = firestoreService.returnList[index][1];
                                  List<bool>weekDays = x.cast<bool>();
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=>ClassScreen(className: firestoreService.returnList[index][0], daysOfWeek: weekDays,startTime: firestoreService.returnList[index][4],endTime: firestoreService.returnList[index][5],startDate: firestoreService.returnList[index][2],endDate: firestoreService.returnList[index][3],link: Link,)));
                                },
                                trailing: Text(
                                  DaysString,
                                  style: TextStyle(
                                    fontFamily: 'Abel',
                                    fontSize: 12.0/850.9090909090909 * contextHeight,
                                  ),
                                ),
                                leading: Column(
                                  children: [
                                    Text(
                                      startTime,
                                      style: TextStyle(
                                        fontFamily: 'Abel',
                                        fontSize: 12.0/850.9090909090909 * contextHeight,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 20/850.9090909090909 * contextHeight,
                                    ),
                                    Text(
                                      endTime,
                                      style: TextStyle(
                                        fontFamily: 'Abel',
                                        fontSize: 12.0/850.9090909090909 * contextHeight,
                                      ),
                                    ),
                                  ],
                                ),
                                title: Text(
                                  "${firestoreService.returnList[index][0]}",
                                  style: TextStyle(
                                    fontFamily: 'Abel',
                                    fontSize: 18.0/850.9090909090909 * contextHeight,
                                  ),
                                ),
                                subtitle: InkWell(
                                  onTap: () async {
                                    if (await canLaunch(Link))
                                      await launch(Link);
                                    else {
                                      if (await canLaunch("https://" + Link))
                                        await launch("https://" + Link);
                                      else if (await canLaunch("http://" + Link))
                                        await launch("http://" + Link);
                                      else
                                        throw "Could not launch ${Link}";
                                    }
                                  },
                                  child: Text(
                                    Link,
                                    style: TextStyle(
                                      fontFamily: 'Abel',
                                      fontSize: 12.0/850.9090909090909 * contextHeight,
                                      color: Colors.blue,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 10.0/850.9090909090909 * contextHeight,)
                      ],
                    );
                  },
                ),
              );
              else{
                final contextHeight = MediaQuery.of(context).size.height;
                final appBarHeight = 1.0 / 11 * contextHeight;
                return Column(
                  children: [
                    SizedBox(
                      height: (contextHeight -
                          appBarHeight -
                          100 / 850.9090909090909 * contextHeight) /
                          2.0 -
                          1.0 / 100.0 * contextHeight,
                    ),
                    Center(
                      child: Text(
                        "No classes here!",
                        style: TextStyle(
                          fontSize: 24.0 / 850.9090909090909 * contextHeight,
                          color: Theme.of(context).primaryColor,
                          fontFamily: 'Abel',
                        ),
                      ),
                    ),
                  ],
                );
              }
            }
            return Center(
              child: SizedBox(
                height: 10,
                child: LinearProgressIndicator(backgroundColor: Theme.of(context).primaryColor,),
              ),
            );
          },
        ),
      ),
    );
  }
}