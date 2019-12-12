import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:messaging_app/services/storage_base/storage_base_service.dart';


class StorageBaseServiceImpl implements StorageBaseService {
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  StorageReference _storageReference;
  @override
  Future<String> uploadFile(
      String userId, String fileType, File fileToUpload) async {
    //burada userId altında fileType(yani yuklenen resimi profile mi yoksa mesaj resmi diye)
    _storageReference = _firebaseStorage.ref().child(userId).child(fileType).child(fileType+".png");
    var uploadTask = _storageReference.putFile(fileToUpload);
    var url = await(await uploadTask.onComplete).ref.getDownloadURL();
    return url;
  }
}
