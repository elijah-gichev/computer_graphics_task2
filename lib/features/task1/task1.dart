import 'dart:io';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:image/image.dart' as extended_image;
import 'package:flutter/services.dart' as s;

final List<int> intensityList1 = [];
final List<int> intensityList2 = [];

//1) Преобразовать изображение из RGB в оттенки серого. Реализовать два варианта формулы
//с учетом разных вкладов R, G и B в интенсивность (см презентацию).
//Затем найти разность полученных полутоновых изображений. Построить гистограммы
//интенсивности после одного и второго преобразования.

//1) grayscale = 0.3 * R + 0.59 * G + 0.11 * B
//2) grayscale = (R + G + B)/3
//3) int getLuminanceRgb(int r, int g, int b) =>
//    (0.299 * r + 0.587 * g + 0.114 * b).round();

class Task1 extends StatelessWidget {
  const Task1({super.key});

  @override
  Widget build(BuildContext context) {
    print(Directory.current);
    final res = s.rootBundle.load('assets/sample.jpg');

    //final file = File('assets/sample.jpg').readAsBytesSync();
    //grayscale1(extended_image.decodeJpg(file)!);
    return Scaffold(
        appBar: AppBar(),
        //body: SingleChildScrollView(
        // child: Row(
        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //   children: [
        //     Image.memory(
        //       file,
        //       height: 400,
        //       width: 400,
        //     ),
        //     Column(
        //       mainAxisSize: MainAxisSize.min,
        //       children: [
        //         Image.memory(
        //           Uint8List.fromList(extended_image
        //               .encodeJpg(grayscale1(extended_image.decodeJpg(file)!))),
        //           height: 400,
        //           width: 400,
        //         ),
        //         TimeSeriesBar([])
        //       ],
        //     ),
        //     Column(
        //       mainAxisSize: MainAxisSize.min,
        //       children: [
        //         Image.memory(
        //           Uint8List.fromList(extended_image
        //               .encodeJpg(grayscale2(extended_image.decodeJpg(file)!))),
        //           height: 400,
        //           width: 400,
        //         ),
        //       ],
        //     ),
        //   ],
        // ),
        body: Image.asset('assets/sample.jpg') //TimeSeriesBar([]),
        //),
        );
  }

  Future<Map<int, int>> countFreq() async {
    final res = await s.rootBundle.load('assets/sample.jpg');
    final p = res.buffer.asUint8List();

    final freqs = <int, int>{};

    for (var i = 0, len = p.length; i < len; i += 4) {
      final r = p[i];
      final g = p[i + 1];
      final b = p[i + 2];

      if (freqs[r] != null) {
        freqs[r] = freqs[r]! + 1;
      } else {
        freqs[r] = 1;
      }

      if (freqs[g] != null) {
        freqs[g] = freqs[g]! + 1;
      } else {
        freqs[g] = 1;
      }

      if (freqs[b] != null) {
        freqs[b] = freqs[b]! + 1;
      } else {
        freqs[b] = 1;
      }
    }

    return freqs;
  }
}

extended_image.Image grayscale1(extended_image.Image src) {
  final p = src.getBytes();
  for (var i = 0, len = p.length; i < len; i += 4) {
    final l = getLuminanceRgb1(p[i], p[i + 1], p[i + 2]);
    p[i] = l;
    p[i + 1] = l;
    p[i + 2] = l;
    intensityList1.add(l);
  }
  //print(intensityList1);
  return src;
}

extended_image.Image grayscale2(extended_image.Image src) {
  final p = src.getBytes();
  for (var i = 0, len = p.length; i < len; i += 4) {
    final l = getLuminanceRgb2(p[i], p[i + 1], p[i + 2]);
    p[i] = l;
    p[i + 1] = l;
    p[i + 2] = l;
    intensityList2.add(l);
  }
  //print(intensityList2);
  return src;
}

int getLuminanceRgb1(int r, int g, int b) =>
    (0.299 * r + 0.587 * g + 0.114 * b).round();

int getLuminanceRgb2(int r, int g, int b) => ((r + g + b) / 3).round();

class TimeSeriesBar extends StatelessWidget {
  final List<charts.Series<Intensity, String>> seriesList;
  final bool animate;

  TimeSeriesBar(this.seriesList, {this.animate = false});

  /// Creates a [TimeSeriesChart] with sample data and no transition.
  factory TimeSeriesBar.withSampleData() {
    return TimeSeriesBar(
      _createSampleData(),
      // Disable animations for image tests.
      animate: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    // This is just a simple bar chart with optional property
    // [defaultInteractions] set to true to include the default
    // interactions/behaviors when building the chart.
    // This includes bar highlighting.
    //
    // Note: defaultInteractions defaults to true.
    //
    // [defaultInteractions] can be set to false to avoid the default
    // interactions.
    return charts.BarChart(
      seriesList,
      animate: animate,
      defaultInteractions: true,
    );
  }

  /// Create one series with sample hard coded data.
  static List<charts.Series<Intensity, String>> _createSampleData() {
    final List<Intensity> data = [];

    for (int i = 0; i <= 255; i++) {
      data.add(
          Intensity(i, intensityList1.where((element) => element == i).length));
    }
    return [
      charts.Series<Intensity, String>(
        id: 'Intensity',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (Intensity intensity, _) => intensity.intensity.toString(),
        measureFn: (Intensity intensity, _) => intensity.count,
        data: data,
      )
    ];
  }
}

/// Sample time series data type.
class Intensity {
  final int intensity;
  final int count;

  Intensity(this.intensity, this.count);
}
