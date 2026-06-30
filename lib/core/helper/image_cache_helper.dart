import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';

final class BaseImageCache {
  BaseImageCache._();

  static final _decoded = <String, Uint8List>{};
  static final _providers = <String, MemoryImage>{};

  static MemoryImage getImage(String base64) {
    final provider = _providers[base64];
    if (provider != null) return provider;

    final bytes = _decoded.putIfAbsent(base64, () => base64Decode(base64));
    final image = MemoryImage(bytes);
    _providers[base64] = image;
    return image;
  }
}
