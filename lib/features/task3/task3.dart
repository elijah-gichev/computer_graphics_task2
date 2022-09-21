import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image/image.dart' as img_lib;

class Task3Page extends StatelessWidget {
  const Task3Page({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final img_lib.Image image =
        img_lib.decodeJpg(File('assets/1.jpg').readAsBytesSync())!;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task 3 '),
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Image.memory(
            Uint8List.fromList(img_lib.encodeJpg(image)),
            height: 400,
            width: 400,
          ),
          const Icon(
            Icons.arrow_forward,
            color: Colors.teal,
            size: 50,
          ),
          Image.memory(
            Uint8List.fromList(img_lib.encodeJpg(convertToHSV(image))),
          ),
        ],
      ),
    );
  }
}

img_lib.Image convertToHSV(img_lib.Image src) {
  final p = src.getBytes();
  for (var i = 0, len = p.length; i < len; i += 4) {
    final l = RGBtoHSV(p[i], p[i + 1], p[i + 2]);
    p[i] = l[0];
    p[i + 1] = l[1];
    p[i + 2] = l[2];
  }
  return src;
}

List<int> RGBtoHSV(int r, int g, int b) {
  int maxValue = max(r, max(g, b));
  int minValue = min(r, min(g, b));
  if (minValue == maxValue) {
    return [r, g, b];
  }
  return [1, 2, 3];
}
