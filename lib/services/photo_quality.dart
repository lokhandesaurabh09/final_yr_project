import 'dart:typed_data';
import 'dart:ui' as ui;
 
enum PhotoIssue { tooDark, tooBright, noLeaf }
 
/// Cheap checks on a picked photo. These only produce WARNINGS: the user can
/// always choose "Use anyway", and a failed check never blocks a scan.
class PhotoQuality {
  static Future<List<PhotoIssue>> check(Uint8List bytes) async {
    try {
      final codec = await ui.instantiateImageCodec(bytes, targetWidth: 96);
      final frame = await codec.getNextFrame();
      final data =
          await frame.image.toByteData(format: ui.ImageByteFormat.rawRgba);
      frame.image.dispose();
      codec.dispose();
      if (data == null) return const [];
 
      final px = data.buffer.asUint8List();
      final count = px.length ~/ 4;
      if (count == 0) return const [];
 
      var luminance = 0.0;
      var green = 0;
      for (var i = 0; i < px.length; i += 4) {
        final r = px[i], g = px[i + 1], b = px[i + 2];
        luminance += 0.299 * r + 0.587 * g + 0.114 * b;
        if (g > 40 && g > r * 1.05 && g > b * 1.05) green++;
      }
 
      final avg = luminance / count;
      final greenShare = green / count;
 
      return [
        if (avg < 45) PhotoIssue.tooDark,
        if (avg > 220) PhotoIssue.tooBright,
        if (greenShare < 0.08) PhotoIssue.noLeaf,
      ];
    } catch (_) {
      return const []; // never block on a failed check
    }
  }
}
 