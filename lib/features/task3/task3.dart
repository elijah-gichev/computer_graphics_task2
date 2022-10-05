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
  late final img_lib.Image imageHSV;
  double _hueValue = 0;
  double _satValue = 0;
  double _valValue = 0;

  @override
  void initState() {
    imageHSV = convertToHSV(
        img_lib.decodeJpg(File('assets/1.jpg').readAsBytesSync())!);

    File('test.jpg')
        .writeAsBytesSync(img_lib.encodeJpg(convertToRGB(imageHSV)));

    //
    var a = HSVColor.fromColor(const Color.fromRGBO(222, 44, 111, 1));
    var b = RGBtoHSV(222, 44, 111);
    print("hue : ${a.hue} saturation : ${a.saturation} value : ${a.value}");
    print("hue2 : ${b.hue} saturation : ${b.saturation} value : ${b.value}");
    //RGV TO HSV CORRECT
    print(HSVToRGB(337, 80, 87).red);
    print(HSVToRGB(337, 80, 87).green);
    print(HSVToRGB(337, 80, 87).blue);
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
                  setState(() {
                    File('test.jpg').writeAsBytesSync(
                        img_lib.encodeJpg(convertToRGB(imageHSV)));
                  });
                },
                child: Image.memory(
                  File('test.jpg').readAsBytesSync(),
                  // Uint8List.fromList(img_lib.encodeJpg(image)),
                  height: 300,
                  width: 300,
                ),
              ),
              Slider(
                label: 'Hue',
                min: -360,
                max: 360,
                value: _hueValue,
                onChanged: (double newValue) {
                  setState(() {
                    _changeHue(
                        imageHSV,
                        newValue > _hueValue
                            ? (newValue - _hueValue).toInt()
                            : (_hueValue - newValue).toInt());
                    _hueValue = newValue;
                  });
                },
              ),
              Slider(
                label: 'Saturation',
                min: -100,
                max: 100,
                value: _satValue,
                onChanged: (double newValue) {
                  setState(() {
                    _changeSat(
                        imageHSV,
                        newValue >= _satValue
                            ? (newValue - _satValue).toInt()
                            : (_satValue - newValue).toInt());
                    _satValue = newValue;
                  });
                },
              ),
              Slider(
                label: 'Value',
                min: -100,
                max: 100,
                value: _valValue,
                onChanged: (double newValue) {
                  setState(() {
                    _changeVal(
                        imageHSV,
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
    p[i] = l.hue;
    p[i + 1] = l.saturation;
    p[i + 2] = l.value;
  }
  return src;
}

img_lib.Image convertToRGB(img_lib.Image src) {
  final p = src.getBytes();
  final Uint8List res = Uint8List.fromList(p);
  for (var i = 0, len = res.length; i < len; i += 4) {
    final l = HSVToRGB(
        res[i].toDouble(), res[i + 1].toDouble(), res[i + 2].toDouble());
    p[i] = l.red;
    p[i + 1] = l.green;
    p[i + 2] = l.blue;
  }
  return img_lib.Image.fromBytes(src.width, src.height, p);
}

MyHSVColor RGBtoHSV(int r1, int g1, int b1) {
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

  return MyHSVColor(hue.toInt(), saturation.toInt(), value.toInt());
}

Color HSVToRGB(double H, double S, double V) {
  int R, G, B;

  H = (H % 360) / 360;
  S = S > 100 ? 100 : S / 100;
  V = V > 100 ? 100 : V / 100;

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

class MyHSVColor {
  final int hue;
  final int saturation;
  final int value;

  MyHSVColor(this.hue, this.saturation, this.value);
}
