import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:study_hub/data/data.dart';
import 'package:study_hub/pages/AfterLogin/schedule.dart';
import 'package:study_hub/pages/AfterLogin/Materials.dart';
import 'package:intl/intl.dart';
import 'package:file_picker/file_picker.dart';
import 'package:study_hub/services/storage.dart';
import 'package:validators/validators.dart' as validator;

File file;
var fileName;
StorageService storageService = StorageService();

class AddMaterialPage extends StatefulWidget {
  AddMaterialPage({Key key}) : super(key: key);

  @override
  AddMaterialPageState createState() => AddMaterialPageState();
}

class AddMaterialPageState extends State<AddMaterialPage> {
  String currentLink;
  String name;
  String currentClassSelected;
  bool loading;
  String error;
  final _formKey = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();

  void buttonPressed() {
    setState(() {
      if (error != null) error = null;
      if (currentClassSelected == null)
        error = "Select a class. Create one if you haven't yet for this year";
      if (file == null&&currentLink==null) error = "Add a file or link";
    });
  }

  void nowLoading() {
    setState(() {
      loading = true;
    });
  }

  void doneLoading() {
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    Future getClassesTwice() async {
      print(currentMaterialDropdownItemSelected);
      await firestoreService.getClasses(currentMaterialDropdownItemSelected);
      await firestoreService.getClasses(currentMaterialDropdownItemSelected);
    }

    DateTime now = DateTime.now();
    var preTextWidth = MediaQuery.of(context).size.width * (1.0 / 19.0);
    final contextHeight = MediaQuery.of(context).size.height;
    final MockupHeight = 850.9090909090909;
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back,
            ),
          ),
          elevation: 0,
          backgroundColor: Theme.of(context).primaryColor,
        ),
        body: SingleChildScrollView(
          child: Container(
            color: Theme.of(context).primaryColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(children: [
                  SizedBox.fromSize(
                    size: Size(preTextWidth, 0.0),
                  ),
                  Text(
                    "Add",
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 30.0 / MockupHeight * contextHeight,
                        color: Colors.white,
                        fontFamily: 'Abel'),
                  ),
                ]),
                SizedBox.fromSize(
                  size: Size(0.0, contextHeight * (1.0 / 90.0)),
                ),
                Row(children: [
                  SizedBox.fromSize(
                    size: Size(preTextWidth, 0.0),
                  ),
                  Text(
                    "New Material",
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 30.0 / MockupHeight * contextHeight,
                        color: Colors.white,
                        fontFamily: 'Abel'),
                  ),
                ]),
                SizedBox(
                  height: 10 / MockupHeight * contextHeight,
                ),
                Form(
                  key: _formKey,
                  child: Column(children: [
                    Row(children: [
                      SizedBox.fromSize(
                        size: Size(preTextWidth, 0.0),
                      ),
                      Text(
                        "Class",
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 18.0 / MockupHeight * contextHeight,
                          color: Color(0XFFC4C9EF),
                          fontFamily: 'Abel',
                        ),
                      ),
                    ]),
                    SizedBox(height: 10 / MockupHeight * contextHeight),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: preTextWidth,
                        ),
                        FutureBuilder(
                            future: getClassesTwice(),
                            builder: (context, _) {
                              List<String> ClassOptions = [];
                              for (var Class in firestoreService.returnList) {
                                ClassOptions.add(Class[0]);
                              }
                              return ClipRRect(
                                borderRadius: BorderRadius.circular(
                                    5 / MockupHeight * contextHeight),
                                child: Container(
                                  color: Color(0XFFDEF3FF),
                                  child: DropdownButton<String>(
                                    dropdownColor: Color(0XFFDEF3FF),
                                    iconEnabledColor:
                                        Theme.of(context).primaryColor,
                                    iconDisabledColor:
                                        Theme.of(context).primaryColor,
                                    items:
                                        ClassOptions.map((String ClassOption) {
                                      return DropdownMenuItem(
                                        value: ClassOption,
                                        child: Text(
                                          "  " + ClassOption,
                                          style: TextStyle(
                                            fontSize: 18.0 /
                                                850.9090909090909 *
                                                contextHeight,
                                            color:
                                                Theme.of(context).primaryColor,
                                            fontFamily: 'Abel',
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                    onChanged: (String val) {
                                      setState(() {
                                        currentClassSelected = val;
                                      });
                                    },
                                    value: currentClassSelected,
                                  ),
                                ),
                              );
                            }),
                      ],
                    ),
                    SizedBox(height: 20 / MockupHeight * contextHeight),
                    Row(children: [
                      SizedBox.fromSize(
                        size: Size(preTextWidth, 0.0),
                      ),
                      Text(
                        "Name",
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 18.0 / MockupHeight * contextHeight,
                          color: Color(0XFFC4C9EF),
                          fontFamily: 'Abel',
                        ),
                      ),
                    ]),
                    BuildTextFormField(
                      hintText: "Material Name",
                      textColor: Colors.white,
                      isEmail: true,
                      Validator: (String value) {
                        if (value.isEmpty) {
                          return "Material name is required";
                        }
                        name = value;
                        return null;
                      },
                      onSaved: (String value) {},
                    ),
                    Row(
                      children: [
                        SizedBox(width: preTextWidth),
                        FlatButton(
                          color: Color(0XFFDEF3FF),
                          onPressed: () async {
                            // Will let you pick one file path, from all extensions
                            FilePickerResult result = await FilePicker.platform
                                .pickFiles(type: FileType.any);
                            if (result != null) {
                              setState(() {
                                file = File(result.files.first.path);
                                fileName = result.names[0];
                                currentLink = null;
                              });
                            }
                          },
                          child: fileName == null
                              ? Row(
                                  children: [
                                    Icon(
                                      Icons.cloud_upload,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      "Upload File",
                                      style: TextStyle(
                                          color: Theme.of(context).primaryColor,
                                          fontSize: 18.0 /
                                              MockupHeight *
                                              contextHeight,
                                          fontFamily: 'Abel'),
                                    ),
                                  ],
                                )
                              : Text(fileName),
                        ),
                        SizedBox(
                          width: preTextWidth,
                        ),
                        FlatButton(
                          color: Color(0XFFDEF3FF),
                          onPressed: () async {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text(
                                      "Insert Link",
                                      style: TextStyle(
                                          color: Theme.of(context).primaryColor,
                                          fontSize: 18.0 /
                                              MockupHeight *
                                              contextHeight,
                                          fontFamily: 'Abel',
                                          fontWeight: FontWeight.bold),
                                    ),
                                    content: Form(
                                      key: _formKey2,
                                      child: TextFormField(
                                        decoration: InputDecoration(
                                            hintText:
                                                "example.example2.com\\file"),
                                        validator: (String val) {
                                          if (!validator.isURL(val))
                                            return "Enter a valid URL";
                                          currentLink = val;
                                          return null;
                                        },
                                      ),
                                    ),
                                    actions: [
                                      FlatButton(
                                        onPressed: (){
                                          if(_formKey2.currentState.validate()){
                                            setState(() {
                                              file = null;
                                              fileName = null;
                                              Navigator.pop(context);
                                            });
                                          }
                                          },
                                        child: Text(
                                            "Add Link",
                                          style: TextStyle(
                                              color: Theme.of(context).primaryColor,
                                              fontSize: 18.0 /
                                                  MockupHeight *
                                                  contextHeight,
                                              fontFamily: 'Abel',
                                          ),
                                        ),
                                      )
                                    ],
                                  );
                                });
                          },
                          child: currentLink == null
                              ? Row(
                                  children: [
                                    Icon(
                                      Icons.link,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      "Insert Link",
                                      style: TextStyle(
                                          color: Theme.of(context).primaryColor,
                                          fontSize: 18.0 /
                                              MockupHeight *
                                              contextHeight,
                                          fontFamily: 'Abel'),
                                    ),
                                  ],
                                )
                              : Text(currentLink),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 350,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width - 50,
                      height: 50,
                      child: FlatButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              10.0 / MockupHeight * contextHeight),
                        ),
                        onPressed: () async {
                          buttonPressed();
                          if (_formKey.currentState.validate() && error == null) {
                            print("loading");
                            nowLoading();

                            if(file!=null) {
                              print("Bruh");
                              await storageService.uploadFile(
                                file,
                                name,
                                currentClassSelected,
                                currentMaterialDropdownItemSelected);
                            } else{
                              print("Reached");
                              await firestoreService.addMaterial(name, currentLink, currentClassSelected, "Link");
                            }
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MaterialsPage()));
                            doneLoading();
                          }
                        },
                        color: Color(0XFFDEF3FF),
                        textColor: Colors.white,
                        splashColor: Colors.blue[900],
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "ADD MATERIAL",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18.0 / MockupHeight * contextHeight,
                                  fontFamily: 'Abel'),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 29.5,
                    ),
                  ]),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class BuildTextFormField extends StatelessWidget {
  final String hintText;
  // ignore: non_constant_identifier_names
  final Function Validator;
  final Function onSaved;
  final bool isPassword;
  final bool isEmail;
  final Color textColor;
  BuildTextFormField({
    this.hintText,
    // ignore: non_constant_identifier_names
    this.Validator,
    this.onSaved,
    this.isPassword = false,
    this.isEmail = false,
    this.textColor = Colors.black,
  });
  @override
  Widget build(BuildContext context) {
    final contextHeight = MediaQuery.of(context).size.height;
    return Padding(
      padding: EdgeInsets.fromLTRB(8.0 / 850.9090909090909 * contextHeight,
          4.0 / 850.9090909090909 * contextHeight, 8.0, 4.0),
      child: Theme(
        data: ThemeData(),
        child: TextFormField(
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(
              fontSize: 24.0 / 850.9090909090909 * contextHeight,
              fontFamily: 'Abel',
              color: textColor,
            ),
            contentPadding:
                EdgeInsets.all(15.0 / 850.9090909090909 * contextHeight),
          ),
          obscureText: isPassword ? true : false,
          validator: Validator,
          onSaved: onSaved,
          keyboardType:
              isEmail ? TextInputType.emailAddress : TextInputType.text,
          style: TextStyle(
            fontSize: 24.0 / 850.9090909090909 * contextHeight,
            fontFamily: 'Abel',
            color: textColor,
          ),
        ),
      ),
    );
  }
}
