import 'dart:io';
 
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
 
import '../theme/app_theme.dart';
 
/// Shows a stored scan photo from a file path (or a blob URL on web).
class ScanImage extends StatelessWidget {
  final String path;
  final BoxFit fit;
  final Widget? fallback;
 
  const ScanImage({
    super.key,
    required this.path,
    this.fit = BoxFit.cover,
    this.fallback,
  });
 
  Widget _broken() =>
      fallback ??
      const ColoredBox(
        color: AppColors.surfaceElevated,
        child: Center(
          child: Icon(Icons.broken_image_outlined,
              color: AppColors.textTertiary, size: 28),
        ),
      );
 
  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return Image.network(
        path,
        fit: fit,
        width: double.infinity,
        height: double.infinity,
        errorBuilder: (_, __, ___) => _broken(),
      );
    }
    return Image.file(
      File(path),
      fit: fit,
      width: double.infinity,
      height: double.infinity,
      errorBuilder: (_, __, ___) => _broken(),
    );
  }
}
 