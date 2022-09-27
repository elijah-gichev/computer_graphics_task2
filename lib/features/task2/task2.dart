import 'package:flutter/material.dart';
import 'package:flutter/services.dart' as s;

class Task2 extends StatefulWidget {
  const Task2({Key? key}) : super(key: key);

  @override
  State<Task2> createState() => _Task2State();
}

class _Task2State extends State<Task2> {
  @override
  void didChangeDependencies() async {
    final res = await countFreq();

    print(res);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return const SizedBox();
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
