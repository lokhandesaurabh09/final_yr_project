import 'dart:io';
 
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
 
/// Keeps picked photos inside the app's own folder so they survive after the
/// picker's temporary copy is cleaned up.
///
/// On web there is no file system: the picker's blob URL is used for the
/// current session only.
class ImageStore {
  static Future<String> persist(XFile file) async {
    if (kIsWeb) return file.path;
 
    final docs = await getApplicationDocumentsDirectory();
    final folder = Directory(p.join(docs.path, 'scans'));
    if (!await folder.exists()) await folder.create(recursive: true);
 
    final ext = p.extension(file.path).isEmpty ? '.jpg' : p.extension(file.path);
    final dest = p.join(
      folder.path,
      '${DateTime.now().millisecondsSinceEpoch}$ext',
    );
    await file.saveTo(dest);
    return dest;
  }
 
  /// Deletes every stored photo (used by "Delete all scans").
  static Future<void> deleteAll() async {
    if (kIsWeb) return;
    final docs = await getApplicationDocumentsDirectory();
    final folder = Directory(p.join(docs.path, 'scans'));
    if (await folder.exists()) await folder.delete(recursive: true);
  }
}
 