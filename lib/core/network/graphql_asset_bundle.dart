import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class GraphQLAssetBundle extends CachingAssetBundle {
  @override
  Future<ByteData> load(String key) async {
    Uint8List encoded = utf8.encoder.convert(Uri(path: Uri.encodeFull(key)).path);
    ByteData? asset = await ServicesBinding.instance.defaultBinaryMessenger
        .send('flutter/assets', encoded.buffer.asByteData());
    if (asset == null) throw FlutterError('Unable to load asset: $key');
    return asset;
  }
}
