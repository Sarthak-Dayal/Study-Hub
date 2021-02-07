import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';
import 'package:study_hub/pages/AfterLogin/schedule.dart';
import 'package:path/path.dart' as path;
import 'package:open_file/open_file.dart';

class StorageService{
  var firebaseUser = FirebaseAuth.instance.currentUser;
  final storageInstance = FirebaseStorage.instance;

  uploadFile(File file, String name, String className, String year)async{
    String UID = firebaseUser.uid;
    await storageInstance
        .ref()
        .child(UID + "/" + year+ "/" + className+ "/" + name)
        .putFile(file)
        .onComplete;
    await storageInstance
        .ref()
        .child(UID + "/" + year + "/" + className+ "/" + name)
        .getDownloadURL().then((fileURL) async{
          print(path.extension((file.path)));
          await firestoreService.addMaterial(name, fileURL, className, path.extension(file.path));
      });

    }
    deleteFile(String name, String className, String year, String URL, String type)async{
      String UID = firebaseUser.uid;
      if(type.toLowerCase()!="link" )await storageInstance
          .ref()
          .child(UID + "/" + year + "/" + className+ "/" + name).delete().then((snapshot) async {
          await firestoreService.deleteMaterialFromFirestore(className, URL);
      }).catchError((error){print(error);});
      else await firestoreService.deleteMaterialFromFirestore(className, URL);
    }
    getAndOpenFile(String name, String className, String year)async{
      String UID = firebaseUser.uid;
      final Directory tempDir = Directory.systemTemp;
      final File file = File('${tempDir.path}/$name');
      final StorageReference ref = FirebaseStorage.instance.ref().child(UID + "/" + year + "/" + className+ "/" + name);
      final StorageFileDownloadTask downloadTask = ref.writeToFile(file);
      await OpenFile.open(file.path);
      print(file.path);
    }
}