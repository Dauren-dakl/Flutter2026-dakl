import 'package:flutter/material.dart';

class TwoWayCounter extends StatefulWidget {
  const TwoWayCounter({super.key});

  @override
  State<TwoWayCounter> createState() => _TwoWayCounterState();
}

class _TwoWayCounterState extends State<TwoWayCounter> {
  int _value = 0;
  bool _saving = false;

  Future<void> _save() async {
    setState(() => _saving = true);
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    setState(() => _saving = false);

    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Saved')));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            OutlinedButton(
              onPressed: _value == 0 ? null : () => setState(() => _value--),
              child: const Text('−'),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text('$_value', style: const TextStyle(fontSize: 24)),
            ),
            FilledButton(
              onPressed: () => setState(() => _value++),
              child: const Text('+'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        FilledButton(
          onPressed: _saving ? null : _save,
          child: _saving
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Save'),
        ),
      ],
    );
  }
}
