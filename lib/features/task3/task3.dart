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
    //237489790
    print(originalBytes.reduce((value, element) => value + element));
    // var a = HSVColor.fromColor(Color.fromRGBO(222, 44, 111, 1));
    // var b = RGBtoHSV(222, 44, 111);
    // print("hue : ${a.hue} saturation : ${a.saturation} value : ${a.value}");
    // print("hue2 : ${b[0]} saturation : ${b[1]} value : ${b[2]}");
    //RGV TO HSV CORRECT
    //print(HSVToRGB(337, 80, 87));
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
          Image.asset(
            'assets/1.jpg',
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
              InkWell(
                onTap: () {
                  File('test.jpg').writeAsBytesSync(
                      img_lib.encodeJpg(convertToRGB(newImage)));
                },
                child: Image.memory(
                  Uint8List.fromList(img_lib.encodeJpg(newImage)),
                  height: 300,
                  width: 300,
                ),
              ),
              Slider(
                label: 'Hue',
                max: 255,
                value: _hueValue,
                onChanged: (double newValue) {
                  setState(() {
                    _changeHue(
                        image,
                        newValue > _hueValue
                            ? (newValue - _hueValue).toInt()
                            : (_hueValue - newValue).toInt());
                    _hueValue = newValue;
                  });
                },
              ),
              Slider(
                label: 'Saturation',
                max: 255,
                value: _satValue,
                onChanged: (double newValue) {
                  setState(() {
                    _changeSat(
                        image,
                        newValue >= _satValue
                            ? (newValue - _satValue).toInt()
                            : (_satValue - newValue).toInt());
                    _satValue = newValue;
                    print(originalBytes
                        .reduce((value, element) => value + element));
                  });
                },
              ),
              Slider(
                label: 'Value',
                max: 255,
                value: _valValue,
                onChanged: (double newValue) {
                  setState(() {
                    _changeVal(
                        image,
                        newValue > _valValue
                            ? (newValue - _valValue).toInt()
                            : (_valValue - newValue).toInt());
                    _valValue = newValue;
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

img_lib.Image convertToRGB(img_lib.Image src) {
  final p = src.getBytes();
  for (var i = 0, len = p.length; i < len; i += 4) {
    final l = HSVToRGB(p[i].toDouble() / 255 * 360,
        p[i + 1].toDouble() / 255 * 100, p[i + 2].toDouble() / 255 * 100);
    p[i] = l.red;
    p[i + 1] = l.green;
    p[i + 2] = l.blue;
  }
  return src;
}

List<int> RGBtoHSV(int r1, int g1, int b1) {
  final double r = r1 / 255.0;
  final double g = g1 / 255.0;
  final double b = b1 / 255.0;

  final double maxValue = [r, g, b].reduce(max);
  final double minValue = [r, g, b].reduce(min);

  final double value = maxValue * 100;
  final double saturation =
      maxValue == 0.0 ? 0 : ((maxValue - minValue) / maxValue) * 100;

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

  //Convert HSV [360, 100, 100] to HSV [256, 256, 256]
  final int h_256 = ((hue / 360) * 255).toInt();
  final int s_256 = ((saturation / 100) * 255).toInt();
  final int v_256 = ((value / 100) * 255).toInt();

  return [h_256, s_256, v_256];
}

Color HSVToRGB(double H, double S, double V) {
  int R, G, B;

  H /= 360;
  S /= 100;
  V /= 100;

  if (S == 0) {
    R = (V * 255).toInt();
    G = (V * 255).toInt();
    B = (V * 255).toInt();
  } else {
    double varH = H * 6;
    if (varH == 6) varH = 0;
    int varI = varH.floor();
    double var_1 = V * (1 - S);
    double var_2 = V * (1 - S * (varH - varI));
    double var_3 = V * (1 - S * (1 - (varH - varI)));

    double varR;
    double varG;
    double varB;
    if (varI == 0) {
      varR = V;
      varG = var_3;
      varB = var_1;
    } else if (varI == 1) {
      varR = var_2;
      varG = V;
      varB = var_1;
    } else if (varI == 2) {
      varR = var_1;
      varG = V;
      varB = var_3;
    } else if (varI == 3) {
      varR = var_1;
      varG = var_2;
      varB = V;
    } else if (varI == 4) {
      varR = var_3;
      varG = var_1;
      varB = V;
    } else {
      varR = V;
      varG = var_1;
      varB = var_2;
    }

    R = (varR * 255).toInt();
    G = (varG * 255).toInt();
    B = (varB * 255).toInt();
  }
  return Color.fromRGBO(R, G, B, 1);
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
    p[i + 1] = (p[i + 1] + value);
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
