import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:study_hub/pages/AddScreens/AddAssessment.dart';
import 'package:study_hub/pages/AddScreens/AddTask.dart';
import 'package:study_hub/pages/AfterLogin/Drawer.dart';
import 'package:study_hub/services/auth.dart';
import '../BeforeLogin/login_page.dart' as loginPage;
import 'schedule.dart';
import 'package:intl/intl.dart';
import 'package:study_hub/pages/EditScreens/EditTask.dart';
var currentTasksDropdownItemSelected = "2020 - 2021";

class TasksPage extends StatefulWidget {
  @override
  _TasksPageState createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
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
    final appBarHeight = 1.0 / 11 * contextHeight;
    BuildContext context2;

    return Scaffold(
      drawer: SideDrawer(page: "tasks"),
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
                      onChanged: (String val) async {
                        print("CHANGED!");
                        print(val);
                        currentTasksDropdownItemSelected = val;
                        setState(() {});
                      },
                      value: currentTasksDropdownItemSelected,
                    ),
                  ),
                ),
              )
            ],
          ),
          SizedBox(
            height: 20 / 850.9090909090909 * contextHeight,
          ),
          BuildTasksView(),
        ]);
      }),
      backgroundColor: Color(0xFFDEF3FF),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => AddTaskPage()));
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
                "ALL TASKS",
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
    );
  }
}

class BuildTasksView extends StatefulWidget {
  @override
  _BuildTasksViewState createState() => _BuildTasksViewState();
}

class _BuildTasksViewState extends State<BuildTasksView> {
  int scoreInput;
  Future getAllTasks() async {
    await firestoreService
        .getAllTasks();
    await firestoreService
        .getAllTasks();
    await firestoreService
        .getAllTasks();
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
        height: 680 / 850.9090909090909 * contextHeight,
        width: 360 / 850.9090909090909 * contextHeight,
        child: FutureBuilder(
          future: getAllTasks(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (firestoreService.tasksMap[currentTasksDropdownItemSelected].isNotEmpty)
                return RefreshIndicator(
                  onRefresh: () async {
                    print(currentDropdownItemSelected);
                    await firestoreService.getAllTasks();
                    setState(() {});
                  },
                  child: ListView.builder(
                    physics: AlwaysScrollableScrollPhysics(),
                    itemCount: firestoreService
                        .tasksMap[currentTasksDropdownItemSelected]
                        .length,
                    itemBuilder: (context, index) {
                      final tasksName = firestoreService.tasksMap[
                      currentTasksDropdownItemSelected][index][0];
                      final dueDate = firestoreService.tasksMap[
                      currentTasksDropdownItemSelected][index][1];
                      final type = firestoreService.tasksMap[
                      currentTasksDropdownItemSelected][index][4];
                      final className = firestoreService.tasksMap[
                      currentTasksDropdownItemSelected][index][5];
                      return Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              color: Color(0XFFEFEEEE),
                              child: SizedBox(
                                height: 90 / 850.9090909090909 * contextHeight,
                                width: MediaQuery.of(context).size.width,
                                child: ListTile(

                                  isThreeLine: true,
                                  trailing: Theme(
                                    data: Theme.of(context).copyWith(
                                      cardColor: Color(0XFFEFEEEE),
                                    ),
                                    child: PopupMenuButton(
                                      onSelected: (i) async {
                                        if (i == 2) {
                                          await firestoreService.deleteTask(tasksName, dueDate, type, className);
                                          firestoreService.tasksMap[currentTasksDropdownItemSelected] = [];
                                          await firestoreService
                                              .getAllTasks()
                                              .then((_) {
                                            setState(() {});
                                          });
                                          await firestoreService
                                              .getAllTasks()
                                              .then((_) {
                                            setState(() {});
                                          });
                                          await firestoreService
                                              .getAllTasks()
                                              .then((_) {
                                            setState(() {});
                                          });
                                        }
                                        if(i==1){
                                          Navigator.of(context).push(MaterialPageRoute(builder: (context)=>EditTaskPage(taskName: tasksName,className: className, dueDate: dueDate.toDate(),type: type,ogDueDate: dueDate.toDate(),ogTaskName: tasksName,ogType: type,)));
                                        }
                                        if(i==0){
                                          showDialog(context: context, builder: (context){
                                            return AlertDialog(
                                              title: Text(
                                                "Mark as Done",
                                                style: TextStyle(
                                                  fontSize: 24.0 /
                                                      850.9090909090909 *
                                                      contextHeight,
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  fontFamily: 'Abel',
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              content: Text(
                                                "Are you sure you want to mark this task and done and discard it?",
                                                style: TextStyle(
                                                  fontSize: 18.0 /
                                                      850.9090909090909 *
                                                      contextHeight,
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  fontFamily: 'Abel',
                                                ),
                                              ),
                                              actions: [
                                                FlatButton(
                                                  onPressed:() async{
                                                    await firestoreService.deleteTask(tasksName, dueDate, type, className);
                                                    firestoreService.tasksMap[currentTasksDropdownItemSelected] = [];
                                                    await firestoreService
                                                        .getAllTasks()
                                                        .then((_) {
                                                      setState(() {});
                                                    });
                                                    await firestoreService
                                                        .getAllTasks()
                                                        .then((_) {
                                                      setState(() {});
                                                    });
                                                    await firestoreService
                                                        .getAllTasks()
                                                        .then((_) {
                                                      setState(() {});
                                                    });
                                                    Navigator.pop(context);
                                                  },
                                                  child: Text(
                                                    "Confirm",
                                                    style: TextStyle(
                                                      fontSize: 18.0 /
                                                          850.9090909090909 *
                                                          contextHeight,
                                                      color: Theme.of(context)
                                                          .primaryColor,
                                                      fontFamily: 'Abel',
                                                    ),
                                                  ),
                                                )
                                              ],
                                            );
                                          });
                                        }
                                      },
                                      itemBuilder: (BuildContext context) =>
                                      <PopupMenuItem>[
                                        PopupMenuItem(
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.check_circle,
                                                color: Theme.of(context)
                                                    .primaryColor,
                                              ),
                                              Text(
                                                'Done',
                                                style: TextStyle(
                                                  fontSize: 18.0 /
                                                      850.9090909090909 *
                                                      contextHeight,
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  fontFamily: 'Abel',
                                                ),
                                              ),
                                            ],
                                          ),
                                          value: 0,
                                        ),
                                        PopupMenuItem(
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.edit,
                                                color: Theme.of(context)
                                                    .primaryColor,
                                              ),
                                              Text(
                                                'Edit',
                                                style: TextStyle(
                                                  fontSize: 18.0 /
                                                      850.9090909090909 *
                                                      contextHeight,
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  fontFamily: 'Abel',
                                                ),
                                              ),
                                            ],
                                          ),
                                          value: 1,
                                        ),
                                        PopupMenuItem(
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.delete,
                                                color: Theme.of(context)
                                                    .primaryColor,
                                              ),
                                              Text(
                                                'Delete',
                                                style: TextStyle(
                                                  fontSize: 18.0 /
                                                      850.9090909090909 *
                                                      contextHeight,
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  fontFamily: 'Abel',
                                                ),
                                              ),
                                            ],
                                          ),
                                          value: 2,
                                        ),
                                      ],
                                      child: Icon(
                                        Icons.more_horiz,
                                        size: 40,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                    ),
                                  ),
                                  leading: Icon(
                                    type == "Revision"
                                        ? Icons.book
                                        : (type == "Assignment"
                                        ? Icons.assignment
                                        : Icons.view_agenda),
                                    color: Theme.of(context).primaryColor,
                                    size: 45,
                                  ),
                                  title: Text(
                                    tasksName,
                                    style: TextStyle(
                                      fontFamily: 'Abel',
                                      fontSize: 16.0 /
                                          850.9090909090909 *
                                          contextHeight,
                                    ),
                                  ),
                                  subtitle: Text(
                                    type +
                                        " - " +
                                        className +
                                        "\n" +
                                        "${DateFormat.yMMMd("en").format(dueDate.toDate())}" +
                                        " at "+"${DateFormat.jm("en").format(dueDate.toDate())}",
                                    style: TextStyle(
                                      fontFamily: 'Abel',
                                      fontSize: 14.0 /
                                          850.9090909090909 *
                                          contextHeight,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10.0 / 850.9090909090909 * contextHeight,
                          )
                        ],
                      );
                    },
                  ),
                );
              else {
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
                        "No tasks here!",
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
                child: LinearProgressIndicator(
                  backgroundColor: Theme.of(context).primaryColor,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
