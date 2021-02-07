import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:study_hub/pages/AfterLogin/Materials.dart';
import 'package:study_hub/pages/AfterLogin/Tasks.dart';
import 'package:study_hub/pages/AfterLogin/Assessments.dart';
import 'package:collection/collection.dart';
import 'package:study_hub/pages/AfterLogin/schedule.dart';
Function eq = const ListEquality().equals;
final firestoreInstance = FirebaseFirestore.instance;
class FirestoreService {
  var firebaseUser = FirebaseAuth.instance.currentUser;
  List returnList = [];
  var assessmentsMap = {
    "2015 - 2016": [],
    "2016 - 2017": [],
    "2017 - 2018": [],
    "2018 - 2019": [],
    "2019 - 2020": [],
    "2020 - 2021": [],
    "2021 - 2022": [],
    "2022 - 2023": [],
    "2023 - 2024": [],
    "2024 - 2025": [],
    "2025 - 2026": [],
  };
  var tasksMap = {
    "2015 - 2016": [],
    "2016 - 2017": [],
    "2017 - 2018": [],
    "2018 - 2019": [],
    "2019 - 2020": [],
    "2020 - 2021": [],
    "2021 - 2022": [],
    "2022 - 2023": [],
    "2023 - 2024": [],
    "2024 - 2025": [],
    "2025 - 2026": [],
  };
  var materialsMap = {
    "2015 - 2016": [],
    "2016 - 2017": [],
    "2017 - 2018": [],
    "2018 - 2019": [],
    "2019 - 2020": [],
    "2020 - 2021": [],
    "2021 - 2022": [],
    "2022 - 2023": [],
    "2023 - 2024": [],
    "2024 - 2025": [],
    "2025 - 2026": [],
  };
  var scoresMap =
  {
    "Quiz":{
      "2015 - 2016": [],
      "2016 - 2017": [],
      "2017 - 2018": [],
      "2018 - 2019": [],
      "2019 - 2020": [],
      "2020 - 2021": [],
      "2021 - 2022": [],
      "2022 - 2023": [],
      "2023 - 2024": [],
      "2024 - 2025": [],
      "2025 - 2026": [],
    },
    "Test":{
      "2015 - 2016": [],
      "2016 - 2017": [],
      "2017 - 2018": [],
      "2018 - 2019": [],
      "2019 - 2020": [],
      "2020 - 2021": [],
      "2021 - 2022": [],
      "2022 - 2023": [],
      "2023 - 2024": [],
      "2024 - 2025": [],
      "2025 - 2026": [],
    },
    "Other":{
      "2015 - 2016": [],
      "2016 - 2017": [],
      "2017 - 2018": [],
      "2018 - 2019": [],
      "2019 - 2020": [],
      "2020 - 2021": [],
      "2021 - 2022": [],
      "2022 - 2023": [],
      "2023 - 2024": [],
      "2024 - 2025": [],
      "2025 - 2026": [],
    }
  };
  addUser() async {
    // ignore: non_constant_identifier_names
    String UID = firebaseUser.uid;
    await firestoreInstance.collection("users").doc(firebaseUser.uid).set(
        {
          "ID": UID,
        }).then((_) {
      print("success!");
    });
  }

  getClasses(String currentYearSelected) async {
    // ignore: non_constant_identifier_names
    String UID = firebaseUser.uid;
    await firestoreInstance
        .collection("Users")
        .where("ID", isEqualTo: UID)
        .get()
        .then((snapshot) {
      snapshot.docs.forEach((element) async {
        await firestoreInstance
            .collection("Users")
            .doc(element.id)
            .collection("years")
            .doc(currentYearSelected)
            .collection("Classes")
            .get()
            .then((snapshot) {
          returnList = [];
          snapshot.docs.forEach((element) {
            var data = element;
            returnList.add([
              data.data()["ClassName"],
              data.data()["DaysOfWeek"],
              data.data()["StartDate"],
              data.data()["EndDate"],
              data.data()["StartTime"],
              data.data()["EndTime"],
              data.data()["Link"],
            ]);
          });
        }).catchError((error) {
          print(error);
        });
      });
    });
//    print(returnList);
  }

  addClass(String currentYearSelected, String className, List daysOfWeek, DateTime startDate, DateTime endDate, TimeOfDay startTime, TimeOfDay endTime, String Link) async {
    // ignore: non_constant_identifier_names
    String UID = firebaseUser.uid;
    Timestamp startDateTimestamp = Timestamp.fromDate(startDate);
    Timestamp endDateTimestamp = Timestamp.fromDate(endDate);
    final now = DateTime.now();
    Timestamp startTimeTimestamp = Timestamp.fromDate(DateTime(now.year, now.month, now.day, startTime.hour, startTime.minute));
    Timestamp endTimeTimestamp = Timestamp.fromDate(DateTime(now.year, now.month, now.day, endTime.hour, endTime.minute));
    await firestoreInstance
        .collection("Users")
        .where("ID", isEqualTo: UID)
        .get()
        .then((snapshot) {
      snapshot.docs.forEach((element) async {
        await firestoreInstance
            .collection("Users")
            .doc(element.id)
            .collection("years")
            .doc(currentYearSelected)
            .collection("Classes")
            .add(
            {
              "ClassName": className,
              "DaysOfWeek": daysOfWeek,
              "StartDate":startDateTimestamp,
              "EndDate": endDateTimestamp,
              "StartTime": startTimeTimestamp,
              "EndTime": endTimeTimestamp,
              "Link": Link,
            }).then((value) {
        });
      });
    });
  }
  deleteClass(String className)async {
    String UID = firebaseUser.uid;
    final now = DateTime.now();
    await firestoreInstance
        .collection("Users")
        .where("ID", isEqualTo: UID)
        .get()
        .then((snapshot) {
      snapshot.docs.forEach((element) async {
        await firestoreInstance
            .collection("Users")
            .doc(element.id)
            .collection("years")
            .doc(currentDropdownItemSelected)
            .collection("Classes")
            .where("ClassName", isEqualTo: className)
            .get()
            .then((snapshot){
              snapshot.docs.forEach((e) async{
                await firestoreInstance
                    .collection("Users")
                    .doc(element.id)
                    .collection("years")
                    .doc(currentDropdownItemSelected)
                    .collection("Classes")
                    .doc(e.id)
                    .delete().then((value) => print(className+" Deleted!"));
              });
        });
      });
    });
  }
  editClass(String className, String ogClassName, List<bool> daysOfWeek, Timestamp endDate, Timestamp endTime, String link, Timestamp startDate, Timestamp startTime)async{
    String UID = firebaseUser.uid;
    await firestoreInstance
        .collection("Users")
        .where("ID", isEqualTo: UID)
        .get()
        .then((snapshot) {
      snapshot.docs.forEach((element) async {
        await firestoreInstance
            .collection("Users")
            .doc(element.id)
            .collection("years")
            .doc(currentDropdownItemSelected)
            .collection("Classes")
            .where("ClassName", isEqualTo: ogClassName)
            .get()
            .then((snapshot){
          snapshot.docs.forEach((e) async{
            await firestoreInstance
                .collection("Users")
                .doc(element.id)
                .collection("years")
                .doc(currentDropdownItemSelected)
                .collection("Classes")
                .doc(e.id)
                .update({
                "ClassName": className,
                "DaysOfWeek": daysOfWeek,
                "EndDate": endDate,
                "EndTime": endTime,
                "Link": link,
                "StartDate": startDate,
                "StartTime": startTime
            })
                .then((value) => print(className+" Deleted!"));
          });
        });
      });
    });
  }
  addAssessment(String className, String assessmentName, DateTime date, TimeOfDay time, String type, String currentYearSelected, bool regRev, dynamic regRevInterval, dynamic regRevStartDate) async {
    String UID = firebaseUser.uid;
    await firestoreInstance
    .collection("Users")
    .where("ID", isEqualTo: UID)
    .get()
    .then((snapshot){
      snapshot.docs.forEach((e) async {
        await firestoreInstance
            .collection("Users")
            .doc(e.id)
            .collection("years")
            .doc(currentYearSelected)
            .collection("Classes")
            .where("ClassName", isEqualTo: className)
            .get()
            .then((snapshot) {
              snapshot.docs.forEach((element) async {
                await firestoreInstance
                    .collection("Users")
                    .doc(e.id)
                    .collection("years")
                    .doc(currentYearSelected)
                    .collection("Classes")
                    .doc(element.id)
                    .collection("Assessments")
                    .add(
                    {
                    "Name": assessmentName,
                    "Date": Timestamp.fromDate(date),
                    "RegRev": regRev,
                    "RegRevInterval": regRevInterval,
                    "RegRevStart": regRevStartDate!=null?Timestamp.fromDate(regRevStartDate):null,
                    "Score": 0,
                    "ScoreEntered": false,
                    "Time": Timestamp.fromDate(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, time.hour, time.minute)),
                    "Type": type,
                 });
              });
        });
      });
    }).catchError((error){print(error);});
  }
  editAssessment(String className, String assessmentName, DateTime date, TimeOfDay time, String type, String currentYearSelected, bool regRev, dynamic regRevInterval, dynamic regRevStartDate, String ogAssessmentName, DateTime ogDate, TimeOfDay ogTime, String ogType, bool ogRegRev, dynamic ogRegRevInterval, dynamic ogRegRevStartDate) async {
    String UID = firebaseUser.uid;
    await firestoreInstance
        .collection("Users")
        .where("ID", isEqualTo: UID)
        .get()
        .then((snapshot){
      snapshot.docs.forEach((e) async {
        print("Found User");
        await firestoreInstance
            .collection("Users")
            .doc(e.id)
            .collection("years")
            .doc(currentYearSelected)
            .collection("Classes")
            .where("ClassName", isEqualTo: className)
            .get()
            .then((snapshot) {
          snapshot.docs.forEach((element) async {
            print("Found Class");
            await firestoreInstance
                .collection("Users")
                .doc(e.id)
                .collection("years")
                .doc(currentYearSelected)
                .collection("Classes")
                .doc(element.id)
                .collection("Assessments")
                .where("Name", isEqualTo: ogAssessmentName)
                .where("Date", isEqualTo: Timestamp.fromDate(ogDate))
                .where("RegRev", isEqualTo: ogRegRev)
                .where("RegRevInterval", isEqualTo: ogRegRevInterval)
                .where(
                "RegRevStart", isEqualTo: ogRegRevStartDate != null ? Timestamp
                .fromDate(ogRegRevStartDate) : null)
                .where("Type", isEqualTo: type)
                .get()
                .then((snapshot) async {
                snapshot.docs.forEach((y) async{
                  print("Found Assessment");
                  await firestoreInstance
                      .collection("Users")
                      .doc(e.id)
                      .collection("years")
                      .doc(currentYearSelected)
                      .collection("Classes")
                      .doc(element.id)
                      .collection("Assessments")
                      .doc(y.id)
                      .update(
                      {
                        "Name": assessmentName,
                        "Date": Timestamp.fromDate(date),
                        "RegRev": regRev,
                        "RegRevInterval": regRevInterval,
                        "RegRevStart": regRevStartDate != null ? Timestamp.fromDate(
                            regRevStartDate) : null,
                        "Score": 0,
                        "ScoreEntered": false,
                        "Time": Timestamp.fromDate(DateTime(DateTime
                            .now()
                            .year, DateTime
                            .now()
                            .month, DateTime
                            .now()
                            .day, time.hour, time.minute)),
                        "Type": type,
                      }).catchError((error){print(error);});
                });
            }).catchError((error){print(error);});
          });
        }).catchError((error){print(error);});
      });
    }).catchError((error){print(error);});
  }
  editTask(String className, String taskName, DateTime dueDate, String type, String ogTaskName, DateTime ogDueDate, String ogType,) async {
    String UID = firebaseUser.uid;
    await firestoreInstance
        .collection("Users")
        .where("ID", isEqualTo: UID)
        .get()
        .then((snapshot){
      snapshot.docs.forEach((e) async {
        print("Found User");
        await firestoreInstance
            .collection("Users")
            .doc(e.id)
            .collection("years")
            .doc(currentTasksDropdownItemSelected)
            .collection("Classes")
            .where("ClassName", isEqualTo: className)
            .get()
            .then((snapshot) {
          snapshot.docs.forEach((element) async {
            print("Found Class");
            await firestoreInstance
                .collection("Users")
                .doc(e.id)
                .collection("years")
                .doc(currentTasksDropdownItemSelected)
                .collection("Classes")
                .doc(element.id)
                .collection("Tasks")
                .where("Name", isEqualTo: ogTaskName)
                .where("DueDate", isEqualTo: Timestamp.fromDate(ogDueDate))
                .where("Type", isEqualTo: ogType)
                .get()
                .then((snapshot) async {
              snapshot.docs.forEach((y) async{
                print("Found Task");
                await firestoreInstance
                    .collection("Users")
                    .doc(e.id)
                    .collection("years")
                    .doc(currentTasksDropdownItemSelected)
                    .collection("Classes")
                    .doc(element.id)
                    .collection("Tasks")
                    .doc(y.id)
                    .update(
                    {
                      "Name": taskName,
                      "DueDate": Timestamp.fromDate(dueDate),
                      "Type": type,
                    }).catchError((error){print(error);});
              });
            }).catchError((error){print(error);});
          });
        }).catchError((error){print(error);});
      });
    }).catchError((error){print(error);});
  }
  getAllAssessments(String currentItemSelected) async {
    String UID = firebaseUser.uid;
    await firestoreInstance
    .collection("Users")
    .where("ID", isEqualTo: UID)
    .get()
    .then((snapshot) {
      snapshot.docs.forEach((element) async {
        await firestoreInstance
            .collection("Users")
            .doc(element.id)
            .collection("years")
            .doc(currentAssessmentDropdownItemSelected)
            .collection("Classes")
            .get()
            .then((snapshot){
              snapshot.docs.forEach((e) async {
                await firestoreInstance
                    .collection("Users")
                    .doc(element.id)
                    .collection("years")
                    .doc(currentItemSelected)
                    .collection("Classes")
                    .doc(e.id)
                    .collection("Assessments")
                    .get()
                    .then((snapshot){
                    print(snapshot.docs.length);
                      snapshot.docs.forEach((data) {
                        List ListToadd = [data.data()["Name"], data.data()["Type"], data.data()["Date"],data.data()["Time"], data.data()["RegRev"], data.data()["RegRevInterval"], data.data()["RegRevStart"], data.data()["Score"], data.data()["ScoreEntered"], e.data()["ClassName"]];
                        bool contains = false;
                        for(var i = 0; i<assessmentsMap[currentAssessmentDropdownItemSelected].length; i++){
                          if(eq(assessmentsMap[currentAssessmentDropdownItemSelected][i], ListToadd)){
                            contains = true;
                          }
                        }
                        if(!contains){
                          assessmentsMap[currentAssessmentDropdownItemSelected].add(ListToadd);
                        }
                      });
                      print(assessmentsMap[currentItemSelected]);
                }).catchError((error){print(error);});
//                print(assessmentsList);
              });
//              print(assessmentsList);
        }).catchError((error){print(error);});
//        print(assessmentsList);
      });
    }).catchError((error){print(error);});
  }

  deleteAssessment(String name, String className, String type, Timestamp time, Timestamp date) async {
    String UID = firebaseUser.uid;
    await firestoreInstance
        .collection("Users")
        .where("ID", isEqualTo: UID)
        .get()
        .then((snapshot) {
      snapshot.docs.forEach((element) async {
        await firestoreInstance
            .collection("Users")
            .doc(element.id)
            .collection("years")
            .doc(currentAssessmentDropdownItemSelected)
            .collection("Classes")
            .where("ClassName", isEqualTo: className)
            .get()
            .then((snapshot){
          snapshot.docs.forEach((e) async {
            await firestoreInstance
                .collection("Users")
                .doc(element.id)
                .collection("years")
                .doc(currentAssessmentDropdownItemSelected)
                .collection("Classes")
                .doc(e.id)
                .collection("Assessments")
                .where("Name", isEqualTo: name)
                .where("Date", isEqualTo: date)
                .where("Type", isEqualTo: type)
                .where("Time", isEqualTo: time)
                .get()
                .then((snapshot){
                  snapshot.docs.forEach((y) async{
                    await firestoreInstance
                        .collection("Users")
                        .doc(element.id)
                        .collection("years")
                        .doc(currentAssessmentDropdownItemSelected)
                        .collection("Classes")
                        .doc(e.id)
                        .collection("Assessments")
                        .doc(y.id)
                        .delete();
                  });
              });
            });
          });
         });
    });
  }

  addScore(int score, String type) async {
    String UID = firebaseUser.uid;
    await firestoreInstance
        .collection("Users")
        .where("ID", isEqualTo: UID)
        .get()
        .then((snapshot){
          snapshot.docs.forEach((element) async {
            await firestoreInstance
                .collection("Users")
                .doc(element.id)
                .collection("Scores")
                .add({
                  "Score": score,
                  "TimeEntered": Timestamp.fromDate(DateTime.now()),
                  "Type": type,
                  "Year": currentAssessmentDropdownItemSelected,
            });
          });
    });
  }
  getScores(String type)async{
    String UID = firebaseUser.uid;
    await firestoreInstance
        .collection("Users")
        .where("ID", isEqualTo: UID)
        .get()
        .then((snapshot) {
          snapshot.docs.forEach((element) async{
            await firestoreInstance
                .collection("Users")
                .doc(element.id)
                .collection("Scores")
                .where("Type", isEqualTo: type)
                .where("Year", isEqualTo: currentAssessmentDropdownItemSelected)
                .get()
                .then((snapshot){
                  snapshot.docs.forEach((data)async{
                    List ListToadd = [data.data()["Score"], data.data()["TimeEntered"], data.data()["Type"],data.data()["Year"]];
                    bool contains = false;
                    for(var i = 0; i<scoresMap[type][currentAssessmentDropdownItemSelected].length; i++){
                      if(eq(scoresMap[type][currentAssessmentDropdownItemSelected][i], ListToadd)){
                        contains = true;
                      }
                    }
                    if(!contains&&ListToadd.isNotEmpty){
                      scoresMap[type][currentAssessmentDropdownItemSelected].add(ListToadd);
                    }
                  });
                  print(scoresMap[type][currentAssessmentDropdownItemSelected]);
            });
          });
    });
  }
  addTask(String name, Timestamp dueDate, bool remindMe, bool completed, String type, String className) async {
    String UID = firebaseUser.uid;
    await firestoreInstance
        .collection("Users")
        .where("ID", isEqualTo: UID)
        .get()
        .then((snapshot){
          snapshot.docs.forEach((element) async {
            await firestoreInstance
                .collection("Users")
                .doc(element.id)
                .collection("years")
                .doc(currentTasksDropdownItemSelected)
                .collection("Classes")
                .where("ClassName", isEqualTo: className)
                .get()
                .then((snapshot){
              snapshot.docs.forEach((e) async {
                await firestoreInstance
                    .collection("Users")
                    .doc(element.id)
                    .collection("years")
                    .doc(currentTasksDropdownItemSelected)
                    .collection("Classes")
                    .doc(e.id)
                    .collection("Tasks")
                    .add({
                  "Completed": completed,
                  "DueDate": dueDate,
                  "Name": name,
                  "RemindMe": remindMe,
                  "Type": type,
                });
              });
            });
          });
    });
  }
  getAllTasks() async {
    String UID = firebaseUser.uid;
    await firestoreInstance
        .collection("Users")
        .where("ID", isEqualTo: UID)
        .get()
        .then((snapshot) {
      snapshot.docs.forEach((element) async {
        await firestoreInstance
            .collection("Users")
            .doc(element.id)
            .collection("years")
            .doc(currentTasksDropdownItemSelected)
            .collection("Classes")
            .get()
            .then((snapshot){
          snapshot.docs.forEach((e) async {
            await firestoreInstance
                .collection("Users")
                .doc(element.id)
                .collection("years")
                .doc(currentTasksDropdownItemSelected)
                .collection("Classes")
                .doc(e.id)
                .collection("Tasks")
                .get()
                .then((snapshot){
              snapshot.docs.forEach((data) {
                List ListToadd = [data.data()["Name"], data.data()["DueDate"], data.data()["RemindMe"],data.data()["Completed"], data.data()["Type"], e.data()["ClassName"]];
                bool contains = false;
                for(var i = 0; i<tasksMap[currentTasksDropdownItemSelected].length; i++){
                  if(eq(tasksMap[currentTasksDropdownItemSelected][i], ListToadd)){
                    contains = true;
                  }
                }
                if(!contains){
                  tasksMap[currentTasksDropdownItemSelected].add(ListToadd);
                }
              });
              print(tasksMap[currentTasksDropdownItemSelected]);
            }).catchError((error){print(error);});
          });
        }).catchError((error){print(error);});
      });
    }).catchError((error){print(error);});
  }
  deleteTask(String name, Timestamp dateTime, String type, String className) async{
    String UID = firebaseUser.uid;
    await firestoreInstance
        .collection("Users")
        .where("ID", isEqualTo: UID)
        .get()
        .then((snapshot) {
      snapshot.docs.forEach((element) async {
        await firestoreInstance
            .collection("Users")
            .doc(element.id)
            .collection("years")
            .doc(currentTasksDropdownItemSelected)
            .collection("Classes")
            .where("ClassName", isEqualTo: className)
            .get()
            .then((snapshot){
          snapshot.docs.forEach((e) async {
            await firestoreInstance
                .collection("Users")
                .doc(element.id)
                .collection("years")
                .doc(currentTasksDropdownItemSelected)
                .collection("Classes")
                .doc(e.id)
                .collection("Tasks")
                .where("Name", isEqualTo: name)
                .where("Type", isEqualTo: type)
                .where("DueDate", isEqualTo: dateTime)
                .get()
                .then((snapshot){
              snapshot.docs.forEach((y) async{
                await firestoreInstance
                    .collection("Users")
                    .doc(element.id)
                    .collection("years")
                    .doc(currentTasksDropdownItemSelected)
                    .collection("Classes")
                    .doc(e.id)
                    .collection("Tasks")
                    .doc(y.id)
                    .delete();
              });
            });
          });
        });
      });
    });
  }
  addMaterial(String name,String link, String className, String type) async {
    String UID = firebaseUser.uid;
    await firestoreInstance
        .collection("Users")
        .where("ID", isEqualTo: UID)
        .get()
        .then((snapshot){
      snapshot.docs.forEach((element) async {
        await firestoreInstance
            .collection("Users")
            .doc(element.id)
            .collection("years")
            .doc(currentMaterialDropdownItemSelected)
            .collection("Classes")
            .where("ClassName", isEqualTo: className)
            .get()
            .then((snapshot){
          snapshot.docs.forEach((e) async {
            await firestoreInstance
                .collection("Users")
                .doc(element.id)
                .collection("years")
                .doc(currentMaterialDropdownItemSelected)
                .collection("Classes")
                .doc(e.id)
                .collection("Materials")
                .add({
              "DownloadLink": link,
              "Name": name,
              "DateAdded": Timestamp.now(),
              "Type": type,
            });
          });
        });
      });
    });
  }
  getAllMaterials() async {
    String UID = firebaseUser.uid;
    await firestoreInstance
        .collection("Users")
        .where("ID", isEqualTo: UID)
        .get()
        .then((snapshot) {
      snapshot.docs.forEach((element) async {
        await firestoreInstance
            .collection("Users")
            .doc(element.id)
            .collection("years")
            .doc(currentMaterialDropdownItemSelected)
            .collection("Classes")
            .get()
            .then((snapshot){
          snapshot.docs.forEach((e) async {
            await firestoreInstance
                .collection("Users")
                .doc(element.id)
                .collection("years")
                .doc(currentMaterialDropdownItemSelected)
                .collection("Classes")
                .doc(e.id)
                .collection("Materials")
                .get()
                .then((snapshot){
              print(snapshot.docs.length);
              snapshot.docs.forEach((data) {
                List ListToadd = [data.data()["Name"], data.data()["DateAdded"], data.data()["DownloadLink"], data.data()["Type"], e.data()["ClassName"]];
                bool contains = false;
                for(var i = 0; i<materialsMap[currentMaterialDropdownItemSelected].length; i++){
                  if(eq(materialsMap[currentMaterialDropdownItemSelected][i], ListToadd)){
                    print("true");
                    contains = true;
                  }
                }
                if(!contains){
                  materialsMap[currentMaterialDropdownItemSelected].add(ListToadd);
                }
              });
              print(materialsMap[currentMaterialDropdownItemSelected]);
            }).catchError((error){print(error);});
          });
        }).catchError((error){print(error);});
      });
    }).catchError((error){print(error);});
    print(materialsMap[currentMaterialDropdownItemSelected]);
  }
  deleteMaterialFromFirestore(String className, String link) async{
    String UID = firebaseUser.uid;
    await firestoreInstance
        .collection("Users")
        .where("ID", isEqualTo: UID)
        .get()
        .then((snapshot) {
      snapshot.docs.forEach((element) async {
        await firestoreInstance
            .collection("Users")
            .doc(element.id)
            .collection("years")
            .doc(currentTasksDropdownItemSelected)
            .collection("Classes")
            .where("ClassName", isEqualTo: className)
            .get()
            .then((snapshot){
          snapshot.docs.forEach((e) async {
            await firestoreInstance
                .collection("Users")
                .doc(element.id)
                .collection("years")
                .doc(currentTasksDropdownItemSelected)
                .collection("Classes")
                .doc(e.id)
                .collection("Materials")
                .where("DownloadLink", isEqualTo: link)
                .get()
                .then((snapshot){
              snapshot.docs.forEach((y) async{
                await firestoreInstance
                    .collection("Users")
                    .doc(element.id)
                    .collection("years")
                    .doc(currentTasksDropdownItemSelected)
                    .collection("Classes")
                    .doc(e.id)
                    .collection("Materials")
                    .doc(y.id)
                    .delete();
              });
            });
          });
        });
      });
    });
  }

  getTaskByClass(String className)async{
    print("Here!");
    print(className);
    String UID = firebaseUser.uid;
    await firestoreInstance
        .collection("Users")
        .where("ID", isEqualTo: UID)
        .get()
        .then((snapshot) {
      snapshot.docs.forEach((element) async {
        print("Reached User!");
        await firestoreInstance
            .collection("Users")
            .doc(element.id)
            .collection("years")
            .doc(currentDropdownItemSelected)
            .collection("Classes")
            .where("ClassName", isEqualTo: className)
            .get()
            .then((snapshot){
          snapshot.docs.forEach((e) async {
            print("Reached Class!");
            await firestoreInstance
                .collection("Users")
                .doc(element.id)
                .collection("years")
                .doc(currentDropdownItemSelected)
                .collection("Classes")
                .doc(e.id)
                .collection("Tasks")
                .get()
                .then((snapshot){
                  tasksMap[currentDropdownItemSelected] = [];
              snapshot.docs.forEach((data) {
                print("Reached Task!");
                List ListToadd = [data.data()["Name"], data.data()["DueDate"], data.data()["RemindMe"],data.data()["Completed"], data.data()["Type"], e.data()["ClassName"]];
                bool contains = false;
                for(var i = 0; i<tasksMap[currentDropdownItemSelected].length; i++){
                  if(eq(tasksMap[currentDropdownItemSelected][i], ListToadd)){
                    contains = true;
                  }
                }
                if(!contains){
                  tasksMap[currentDropdownItemSelected].add(ListToadd);
                }
              });
              print(tasksMap[currentDropdownItemSelected]);
            }).catchError((error){print(error);});
          });
        }).catchError((error){print(error);});
      });
    }).catchError((error){print(error);});
  }
  getAssessmentByClass(String currentItemSelected, String className) async {
    String UID = firebaseUser.uid;
    await firestoreInstance
        .collection("Users")
        .where("ID", isEqualTo: UID)
        .get()
        .then((snapshot) {
      snapshot.docs.forEach((element) async {
        await firestoreInstance
            .collection("Users")
            .doc(element.id)
            .collection("years")
            .doc(currentAssessmentDropdownItemSelected)
            .collection("Classes")
            .where("ClassName", isEqualTo: className)
            .get()
            .then((snapshot){
          snapshot.docs.forEach((e) async {
            await firestoreInstance
                .collection("Users")
                .doc(element.id)
                .collection("years")
                .doc(currentItemSelected)
                .collection("Classes")
                .doc(e.id)
                .collection("Assessments")
                .get()
                .then((snapshot){
              print(snapshot.docs.length);
              snapshot.docs.forEach((data) {
                List ListToadd = [data.data()["Name"], data.data()["Type"], data.data()["Date"],data.data()["Time"], data.data()["RegRev"], data.data()["RegRevInterval"], data.data()["RegRevStart"], data.data()["Score"], data.data()["ScoreEntered"], e.data()["ClassName"]];
                bool contains = false;
                for(var i = 0; i<assessmentsMap[currentAssessmentDropdownItemSelected].length; i++){
                  if(eq(assessmentsMap[currentAssessmentDropdownItemSelected][i], ListToadd)){
                    contains = true;
                  }
                }
                if(!contains){
                  assessmentsMap[currentAssessmentDropdownItemSelected].add(ListToadd);
                }
              });
              print(assessmentsMap[currentItemSelected]);
            }).catchError((error){print(error);});
//                print(assessmentsList);
          });
//              print(assessmentsList);
        }).catchError((error){print(error);});
//        print(assessmentsList);
      });
    }).catchError((error){print(error);});
  }
  getMaterialsByClass(String className) async {
    String UID = firebaseUser.uid;
    await firestoreInstance
        .collection("Users")
        .where("ID", isEqualTo: UID)
        .get()
        .then((snapshot) {
      snapshot.docs.forEach((element) async {
        await firestoreInstance
            .collection("Users")
            .doc(element.id)
            .collection("years")
            .doc(currentDropdownItemSelected)
            .collection("Classes")
            .where("ClassName", isEqualTo: className)
            .get()
            .then((snapshot){
          snapshot.docs.forEach((e) async {
            await firestoreInstance
                .collection("Users")
                .doc(element.id)
                .collection("years")
                .doc(currentDropdownItemSelected)
                .collection("Classes")
                .doc(e.id)
                .collection("Materials")
                .get()
                .then((snapshot){
              print(snapshot.docs.length);
              snapshot.docs.forEach((data) {
                List ListToadd = [data.data()["Name"], data.data()["DateAdded"], data.data()["DownloadLink"], data.data()["Type"], e.data()["ClassName"]];
                bool contains = false;
                for(var i = 0; i<materialsMap[currentDropdownItemSelected].length; i++){
                  if(eq(materialsMap[currentDropdownItemSelected][i], ListToadd)){
                    print("true");
                    contains = true;
                  }
                }
                if(!contains){
                  materialsMap[currentDropdownItemSelected].add(ListToadd);
                }
              });
              print(materialsMap[currentDropdownItemSelected]);
            }).catchError((error){print(error);});
          });
        }).catchError((error){print(error);});
      });
    }).catchError((error){print(error);});
    print(materialsMap[currentDropdownItemSelected]);
  }
}