import 'dart:async';
import 'package:flutter/material.dart';

class CountdownDialog extends StatefulWidget {
  final int countdown;
  final VoidCallback onFinished;

  const CountdownDialog({
    super.key,
    required this.countdown,
    required this.onFinished,
  });

  @override
  State<CountdownDialog> createState() => _CountdownDialogState();
}

class _CountdownDialogState extends State<CountdownDialog> {
  late int current;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    current = widget.countdown;

    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (current <= 1) {
        t.cancel();
        widget.onFinished();
      } else {
        setState(() {
          current--;
        });
      }
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Get ready to exercise"),
      content: Text("It starts in $current seconds..."),
    );
  }
}
