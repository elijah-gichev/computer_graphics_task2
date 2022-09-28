import 'package:flutter/material.dart';
import 'package:flutter/services.dart' as s;
import 'package:flutter_charts/flutter_charts.dart';

class Task2 extends StatefulWidget {
  const Task2({Key? key}) : super(key: key);

  @override
  State<Task2> createState() => _Task2State();
}

class _Task2State extends State<Task2> {
  final rFreqs = <int, int>{};
  final gFreqs = <int, int>{};
  final bFreqs = <int, int>{};

  @override
  void didChangeDependencies() async {
    await countFreq(rFreqs, gFreqs, bFreqs);

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task 2'),
      ),
      body: Center(
        child: Row(
          children: [
            SizedBox(
              width: 300,
              height: 300,
              child: buildChart(
                channelName: 'channel R',
                xLabels: rFreqs.keys.map((key) => key.toString()).toList(),
                dataRows: rFreqs.values.map((val) => val.toDouble()).toList(),
                color: Colors.red,
              ),
            ),
            SizedBox(
              width: 300,
              height: 300,
              child: buildChart(
                channelName: 'channel G',
                xLabels: gFreqs.keys.map((key) => key.toString()).toList(),
                dataRows: gFreqs.values.map((val) => val.toDouble()).toList(),
                color: Colors.green,
              ),
            ),
            SizedBox(
              width: 300,
              height: 300,
              child: buildChart(
                channelName: 'channel B',
                xLabels: bFreqs.keys.map((key) => key.toString()).toList(),
                dataRows: bFreqs.values.map((val) => val.toDouble()).toList(),
                color: Colors.blue,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> countFreq(
    Map<int, int> rFreqs,
    Map<int, int> gFreqs,
    Map<int, int> bFreqs,
  ) async {
    final bytes = await s.rootBundle.load('assets/1.jpg');
    final p =
        bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes);

    for (var i = 0, len = p.length; i < len - 4; i += 4) {
      final r = p[i];
      final g = p[i + 1];
      final b = p[i + 2];

      if (rFreqs[r] != null) {
        rFreqs[r] = rFreqs[r]! + 1;
      } else {
        rFreqs[r] = 1;
      }

      if (gFreqs[g] != null) {
        gFreqs[g] = gFreqs[g]! + 1;
      } else {
        gFreqs[g] = 1;
      }

      if (bFreqs[b] != null) {
        bFreqs[b] = bFreqs[b]! + 1;
      } else {
        bFreqs[b] = 1;
      }
    }
  }

  Widget buildChart({
    required String channelName,
    required List<String> xLabels,
    required List<double> dataRows,
    required Color color,
  }) {
    ChartOptions chartOptions = const ChartOptions();
    chartOptions = const ChartOptions(
        // dataContainerOptions: DataContainerOptions(
        //   yTransform: log10,
        //   yInverseTransform: inverseLog10,
        // ),

        );
    final chartData = ChartData(
      dataRows: [dataRows],
      xUserLabels: xLabels,
      dataRowsLegends: [channelName],
      chartOptions: chartOptions,
      dataRowsColors: [color],
    );
    var verticalBarChartContainer = VerticalBarChartTopContainer(
      chartData: chartData,
    );

    var verticalBarChart = VerticalBarChart(
      painter: VerticalBarChartPainter(
        verticalBarChartContainer: verticalBarChartContainer,
      ),
      size: const Size(300, 300),
    );
    return verticalBarChart;
  }
}
