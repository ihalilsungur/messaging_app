import 'dart:io';

abstract class StorageBaseService {
  Future<String> uploadFile(String userId, String fileType, File fileToUpload);
}
