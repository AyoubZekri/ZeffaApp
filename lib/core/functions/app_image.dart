import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

/// A record's image: a local file on phone/desktop, a server URL on the web.

bool imageExists(String? path) {
  if (path == null || path.isEmpty) return false;
  if (path.startsWith('http')) return true;
  // No local files in the browser
  if (kIsWeb) return false;
  return File(path).existsSync();
}

ImageProvider appImageProvider(String path) {
  if (!path.startsWith('http')) return FileImage(File(path));
  // The server redirects http → https; go straight to https
  final url = path.startsWith('http://')
      ? path.replaceFirst('http://', 'https://')
      : path;
  // On the web, fall back to an <img> element when the server's files
  // don't allow CORS (CanvasKit can't fetch them otherwise)
  return NetworkImage(
    url,
    webHtmlElementStrategy: WebHtmlElementStrategy.fallback,
  );
}

Widget appImage(
  String path, {
  BoxFit? fit,
  double? width,
  double? height,
}) {
  return Image(
    image: appImageProvider(path),
    fit: fit,
    width: width,
    height: height,
    errorBuilder: (context, error, stack) => const SizedBox.shrink(),
  );
}

/// Round avatar. Drawn as an Image (not a CircleAvatar background) so the
/// web <img> fallback works for server images.
Widget appAvatar(
  String? path, {
  required double radius,
  required String fallbackAsset,
}) {
  final fallback = Image.asset(fallbackAsset, fit: BoxFit.cover);
  return CircleAvatar(
    radius: radius,
    backgroundColor: Colors.white,
    child: ClipOval(
      child: SizedBox(
        width: radius * 2,
        height: radius * 2,
        child: imageExists(path)
            ? Image(
                image: appImageProvider(path!),
                fit: BoxFit.cover,
                errorBuilder: (context, error, stack) => fallback,
              )
            : fallback,
      ),
    ),
  );
}
