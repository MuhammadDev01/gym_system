import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';

final class BaseImageCache {
  BaseImageCache._();

  static final _decoded = <String, Uint8List>{};
  static final _providers = <String, ImageProvider>{};

  static ImageProvider getImage(String source) {
    if (source.startsWith('http')) {
      return NetworkImage(source);
    }
    final provider = _providers[source];
    if (provider != null) return provider;

    String clean = source;
    if (clean.startsWith('data:')) {
      clean = clean.split(',').last;
    }
    final bytes = _decoded.putIfAbsent(source, () => base64Decode(clean));
    final image = MemoryImage(bytes);
    _providers[source] = image;
    return image;
  }
}
