import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image/image.dart' as img_lib;

class Task3Page extends StatefulWidget {
  const Task3Page({Key? key}) : super(key: key);

  @override
  State<Task3Page> createState() => _Task3PageState();
}

class _Task3PageState extends State<Task3Page> {
  late final img_lib.Image newImage;
  late final img_lib.Image image;
  double _hueValue = 0;
  double _satValue = 0;
  double _valValue = 0;
  late final Uint8List originalBytes;

  @override
  void initState() {
    image = img_lib.decodeJpg(File('assets/1.jpg').readAsBytesSync())!;
    newImage = convertToHSV(image);
    originalBytes = image.getBytes();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task 3'),
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Image.memory(
            File('assets/1.jpg').readAsBytesSync(),
            height: 300,
            width: 300,
          ),
          const Icon(
            Icons.arrow_forward,
            color: Colors.teal,
            size: 50,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Image.memory(
                Uint8List.fromList(img_lib.encodeJpg(newImage)),
                height: 300,
                width: 300,
              ),
              Slider(
                label: 'Hue',
                max: 360,
                value: _hueValue,
                onChanged: (double newValue) {
                  setState(() {
                    _hueValue = newValue;
                    _changeHue(image, newValue.toInt());
                  });
                },
              ),
              Slider(
                label: 'Saturation',
                max: 360,
                value: _satValue,
                onChanged: (double newValue) {
                  setState(() {
                    _satValue = newValue;
                    _changeSat(image, newValue.toInt());
                  });
                },
              ),
              Slider(
                label: 'Value',
                max: 360,
                value: _valValue,
                onChanged: (double newValue) {
                  setState(() {
                    _valValue = newValue;
                    _changeVal(image, newValue.toInt());
                  });
                },
              ),
            ],
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

  late final double hue;
  final double denominator = maxValue - minValue;

  if (minValue == maxValue) {
    hue = 0;
  } else if (maxValue == r && g >= b) {
    hue = (60 * ((g - b) / denominator)) % 360;
  } else if (maxValue == r && g < b) {
    hue = (60 * ((g - b) / denominator) + 360) % 360;
  } else if (maxValue == g) {
    hue = (60 * ((b - r) / denominator) + 120) % 360;
  } else if (maxValue == b) {
    hue = (60 * ((r - g) / denominator) + 240) % 360;
  }
  return [hue.toInt(), saturation.toInt(), value.toInt()];
}

void _changeHue(img_lib.Image image, int value) {
  final p = image.getBytes();
  for (var i = 0, len = p.length; i < len; i += 4) {
    p[i] = p[i] + value;
  }
  return;
}

void _changeSat(img_lib.Image image, int value) {
  final p = image.getBytes();
  for (var i = 0, len = p.length; i < len; i += 4) {
    p[i + 1] = p[i + 1] + value;
  }
  return;
}

void _changeVal(img_lib.Image image, int value) {
  final p = image.getBytes();
  for (var i = 0, len = p.length; i < len; i += 4) {
    p[i + 2] = p[i + 2] + value;
  }
  return;
}
