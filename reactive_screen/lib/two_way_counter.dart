import 'package:flutter/material.dart';

class TwoWayCounter extends StatefulWidget {
  const TwoWayCounter({super.key});

  @override
  State<TwoWayCounter> createState() {
    return _TwoWayCounterState();
  }
}

class _TwoWayCounterState extends State<TwoWayCounter> {
  int _count = 0;
  bool _saving = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            OutlinedButton(
              onPressed: _count > 0
                  ? () {
                      setState(() {
                        _count--;
                      });
                    }
                  : null,
              child: const Text('-'),
            ),
            const SizedBox(width: 20),
            Text('$_count'),
            const SizedBox(width: 20),
            FilledButton(
              onPressed: () {
                setState(() {
                  _count++;
                });
              },
              child: const Text('+'),
            ),
          ],
        ),
        if (_saving)
          const CircularProgressIndicator()
        else
          FilledButton(
            onPressed: () async {
              setState(() {
                _saving = true;
              });
              await Future.delayed(const Duration(seconds: 2));

              if (mounted) {
                setState(() {
                  _saving = false;
                });
                ScaffoldMessenger.of(context)
                    .showSnackBar(const SnackBar(content: Text('Saved')));
              }
            },
            child: const Text('Save'),
          ),
      ],
    );
  }
}
