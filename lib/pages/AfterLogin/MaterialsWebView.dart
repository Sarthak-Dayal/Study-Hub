import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'dart:math';
import 'package:url_launcher/url_launcher.dart';
import 'package:study_hub/pages/AddScreens/AddMaterial.dart';
import 'package:open_file/open_file.dart';
import 'Materials.dart';

class MaterialsWebView extends StatefulWidget {
  String Link;
  String name;
  String type;
  String className;
  MaterialsWebView({this.Link, this.name, this.type, this.className});
  @override
  _MaterialsWebViewState createState() => _MaterialsWebViewState(
      Link: Link, type: type, name: name, className: className);
}

class _MaterialsWebViewState extends State<MaterialsWebView> {
  launchURL()async{
    print(Link);
    if(await canLaunch(Link)==true) await launch(Link);
    else if(await canLaunch("http://"+Link))await launch("http://"+Link);
    else return "an error occurred";
  }
  String Link;
  String name;
  String type;
  String className;
  _MaterialsWebViewState({this.Link, this.name, this.type, this.className});
  @override
  Widget build(BuildContext context) {
    print(type);
    final contextHeight = MediaQuery.of(context).size.height;

    return Scaffold(
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
          actions: [
            GestureDetector(
              onTap:()async{
                if(await canLaunch(Link)==true) await launch(Link);
                else print("an error occurred");
              },
              child: Row(
                children: [
                  Icon(
                    type.toLowerCase()!="link"?Icons.cloud_download:Icons.open_in_new,
                  ),
                  SizedBox(width:15)
                ],
              ),
            ),
          ],
        ),
        body: type.toLowerCase()=="link"?
            FutureBuilder(
              future: launchURL(),
                builder: (context,snapshot){
              if(snapshot.connectionState==ConnectionState.done)
                if(snapshot.data!="an error occurred")
                return Center(child: Text("URL Launched"));
                else return Center(child: Text("Unable to launch URL"));
              return Center(child: CircularProgressIndicator());
            })
            :type.toLowerCase() == ".jpg" ||
                type.toLowerCase() == ".png" ||
                type.toLowerCase() == ".bmp" ||
                type.toLowerCase() == ".gif"||
                type.toLowerCase()==".svg"||
            type.toLowerCase()==".tiff"
            ? Center(
                child: PhotoView(
                imageProvider: NetworkImage(Link),
              ))
            : (type==".mp4"||type==".avi"||type==".h264"||type==".mov")
                ? WebView(
                    onWebViewCreated:
                        (WebViewController webViewController) async {
                      await webViewController.loadUrl(Link);
                    },
                  )
                : FutureBuilder(
                    builder: (context, snapshot) {
                      if(snapshot.connectionState==ConnectionState.done){
                        return Center(
                          child: Text(
                            "Select an open option or download the file.",
                          ),
                        );
                      }
                      return CircularProgressIndicator();
                    },
                    future: storageService.getAndOpenFile(name,
                        className, currentMaterialDropdownItemSelected),
                  ));
  }
}
