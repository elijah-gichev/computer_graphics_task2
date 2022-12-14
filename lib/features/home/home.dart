import 'package:flutter/material.dart';
import 'package:task2/features/task1/task1.dart';
import 'package:task2/features/task2/task2.dart';
import 'package:task2/features/task3/task3.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const Task1(),
                  ),
                );
              },
              child: const Text('Task1'),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const Task2(),
                  ),
                );
              },
              child: const Text('Task2'),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const Task3Page(),
                  ),
                );
              },
              child: const Text('Task 3'),
            ),
          ],
        ),
      ),
    );
  }
}
