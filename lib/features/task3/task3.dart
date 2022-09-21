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

List<int> RGBtoHSV(int r1, int g1, int b1) {
  final double r = r1 / 255.0;
  final double g = g1 / 255.0;
  final double b = b1 / 255.0;

  final double maxValue = max(r, max(g, b));
  final double minValue = min(r, min(g, b));

  final double value = maxValue * 100;
  final double saturation = maxValue == 0 ? 0 : (1 - minValue / maxValue);

  double hue = 0;
  final double denominator = maxValue - minValue;

  if (minValue == maxValue) {
    hue = 0;
  } else if (maxValue == r && g >= b) {
    hue = (60 * ((g - b) / denominator)) % 360;
  } else if (maxValue == r && g < b) {
    hue = (60 * ((g - b) ~/ denominator) + 360) % 360;
  } else if (maxValue == g) {
    hue = (60 * ((b - r) ~/ denominator) + 120) % 360;
  } else if (maxValue == b) {
    hue = (60 * ((r - g) ~/ denominator) + 240) % 360;
  }
  return [hue.toInt(), saturation.toInt(), value.toInt()];
}
