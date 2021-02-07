import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:study_hub/pages/AddScreens/AddMaterial.dart';
import 'package:study_hub/pages/AfterLogin/Drawer.dart';
import 'package:study_hub/pages/AfterLogin/MaterialsWebView.dart';
import 'package:study_hub/pages/AfterLogin/schedule.dart';
import 'package:study_hub/services/auth.dart';
import '../BeforeLogin/login_page.dart' as loginPage;
import 'package:intl/intl.dart';

String email = loginPage.email;
class MaterialsPage extends StatefulWidget {
  @override
  _MaterialsPageState createState() => _MaterialsPageState();
}
var currentMaterialDropdownItemSelected = "2020 - 2021";
class _MaterialsPageState extends State<MaterialsPage> {
  @override
  Widget build(BuildContext context) {
    //print(email);
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
    var preTextWidth = MediaQuery.of(context).size.width * (1.0 / 19.0)/850.9090909090909*contextHeight;
    AuthService _auth = AuthService();
    final appBarHeight = 1.0 / 11 * contextHeight;
    BuildContext context2;
    return Scaffold(
      drawer: SideDrawer(page:"materials"),
      body: Builder(builder: (context) {
        context2 = context;
        return Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          SizedBox(
            height: 1.0/100.0*contextHeight,
          ),
          Row(
            children: [
              SizedBox(
                width: preTextWidth,
              ),
              Text(
                "Year: ",
                style: TextStyle(
                  fontSize: (18.0)/850.9090909090909*contextHeight,
                  color: Theme.of(context).primaryColor,
                  fontFamily: 'Abel',
                ),
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(5/850.9090909090909*contextHeight),
                child: SizedBox(
                  height: 30/850.9090909090909*contextHeight,
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
                            "  "+ yearOption,
                            style: TextStyle(
                              fontSize: 18.0/850.9090909090909*contextHeight,
                              color: Colors.white,
                              fontFamily: 'Abel',
                            ),
                          ),
                        );
                      }).toList(),
                      onChanged: (String val) {
                        setState(() {
                          currentMaterialDropdownItemSelected = val;
                        });
                      },
                      value: currentMaterialDropdownItemSelected,
                    ),
                  ),
                ),
              )
            ],
          ),
          SizedBox(height:20),
          BuildMaterialsView(),
        ]);
      }),
      backgroundColor: Color(0xFFDEF3FF),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          file = null;
          fileName = null;
          Navigator.of(context).push(MaterialPageRoute(builder: (context)=>AddMaterialPage()));
        },
        child: Image.asset("images/Add.png"),
        backgroundColor: Color(0xFFDEF3FF),
      ),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(appBarHeight),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10/850.9090909090909*contextHeight),
          child: AppBar(
            automaticallyImplyLeading: false,
            leading: Column(children: [
              SizedBox(
                height: 16/850.9090909090909*contextHeight,
              ),
              GestureDetector(
                onTap: () {
                  Scaffold.of(context2).openDrawer();
                },
                child: Image.asset(
                  "images/MenuIcon.png",
                  scale: 1.25*850.9090909090909/contextHeight,
                ),
              ),
            ]),
            centerTitle: true,
            title: Column(children: [
              SizedBox(
                height: (16)/850.9090909090909*contextHeight,
              ),
              Text(
                "ALL MATERIALS",
                style: TextStyle(
                  fontSize: (24.0)/850.9090909090909*contextHeight,
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
class BuildMaterialsView extends StatefulWidget {
  @override
  _BuildMaterialsViewState createState() => _BuildMaterialsViewState();
}

class _BuildMaterialsViewState extends State<BuildMaterialsView> {
  int scoreInput;
  Future getAllMaterials() async {
    await firestoreService
        .getAllMaterials();
    await firestoreService
        .getAllMaterials();
    await firestoreService
        .getAllMaterials();
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
          future: getAllMaterials(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (firestoreService.materialsMap[currentMaterialDropdownItemSelected].isNotEmpty)
                //print(firestoreService.materialsMap[currentMaterialDropdownItemSelected]);
                return RefreshIndicator(
                  onRefresh: () async {
                    print(currentDropdownItemSelected);
                    await firestoreService.getAllMaterials();
                    setState(() {});
                  },
                  child: ListView.builder(
                    physics: AlwaysScrollableScrollPhysics(),
                    itemCount: firestoreService.materialsMap[currentMaterialDropdownItemSelected].length,
                    itemBuilder: (context, index) {
                      final MaterialName = firestoreService.materialsMap[
                      currentMaterialDropdownItemSelected][index][0];
                      final dateAdded = firestoreService.materialsMap[
                      currentMaterialDropdownItemSelected][index][1];
                      final downloadLink = firestoreService.materialsMap[
                      currentMaterialDropdownItemSelected][index][2];
                      final type = firestoreService.materialsMap[
                      currentMaterialDropdownItemSelected][index][3];
                      final className = firestoreService.materialsMap[
                      currentMaterialDropdownItemSelected][index][4];
                      return Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              color: Color(0XFFEFEEEE),
                              child: SizedBox(
                                height: 75 / 850.9090909090909 * contextHeight,
                                width: MediaQuery.of(context).size.width,
                                child: ListTile(
                                  isThreeLine: true,
                                  trailing: Theme(
                                    data: Theme.of(context).copyWith(
                                      cardColor: Color(0XFFEFEEEE),
                                    ),
                                    child: PopupMenuButton(
                                      onSelected: (i) async {
                                        if(i==1){
                                          firestoreService.materialsMap[currentMaterialDropdownItemSelected] = [];
                                          await storageService.deleteFile(MaterialName, className, currentMaterialDropdownItemSelected, downloadLink, type);
                                          await firestoreService.getAllMaterials();
                                          await firestoreService.getAllMaterials();
                                          await firestoreService.getAllMaterials();
                                          setState(() {});
                                        }
                                        else if(i==0){
                                          Navigator.of(context).push((MaterialPageRoute(builder: (context)=>MaterialsWebView(Link: downloadLink, type: type, name: MaterialName,className: className,))));
                                        }
                                      },
                                      itemBuilder: (BuildContext context) =>
                                      <PopupMenuItem>[
                                        PopupMenuItem(
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.open_in_new_rounded,
                                                color: Theme.of(context)
                                                    .primaryColor,
                                              ),
                                              Text(
                                                'Open',
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
                                          value: 1,
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
                                    type.toLowerCase() == ".jpg" ||
                                        type.toLowerCase() == ".png" ||
                                        type.toLowerCase() == ".bmp" ||
                                        type.toLowerCase() == ".gif"||
                                        type.toLowerCase()==".svg"||
                                        type.toLowerCase()==".tiff"
                                        ? Icons.image
                                        : (type == ".pdf"
                                        ? Icons.picture_as_pdf
                                        :type==".docx"||type==".ppt"||type==".pptx"||type==".xls"||type==".xlsx"||type==".doc"||type==".txt"?
                                    Icons.article: type==".mp4"||type==".avi"||type==".h264"||type==".mov"?Icons.play_circle_filled:type=="Link"?Icons.link:Icons.storage),
                                    color: Theme.of(context).primaryColor,
                                    size: 45,
                                  ),
                                  title: Text(
                                    MaterialName+ type,
                                    style: TextStyle(
                                      fontFamily: 'Abel',
                                      fontSize: 18.0 /
                                          850.9090909090909 *
                                          contextHeight,
                                    ),
                                  ),
                                  subtitle: Text(
                                        className +
                                        "\n" +
                                        "Added ${DateFormat.yMMMd("en").format(dateAdded.toDate())}" +
                                        " at "+"${DateFormat.jm("en").format(dateAdded.toDate())}",
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
                        "No Materials here!",
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
