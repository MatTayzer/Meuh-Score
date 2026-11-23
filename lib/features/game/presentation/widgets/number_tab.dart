import 'dart:async';

import 'package:flutter/material.dart';
import 'package:meuh_score/app/theme/app_theme.dart';
import 'package:meuh_score/core/constants/app_assets.dart';
import 'package:vibration_flutter/vibration_flutter.dart';

class NumberTab extends StatefulWidget {
  const NumberTab({super.key, required this.onSubmit});

  final ValueChanged<int> onSubmit;

  @override
  State<NumberTab> createState() => _NumberTabState();
}

class _NumberTabState extends State<NumberTab> {
  String _value = '';

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF121316),
        image: DecorationImage(
          image: AssetImage(AppAssets.textureMetal),
          repeat: ImageRepeat.repeat,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            width: double.infinity,
            alignment: Alignment.center,
            decoration: const BoxDecoration(color: Colors.black54),
            child: Text(
              _value.isEmpty ? '0' : (_value == '-' ? '-0' : _value),
              style: const TextStyle(fontSize: 24),
            ),
          ),
          for (final row in [
            [1, 2, 3],
            [4, 5, 6],
            [7, 8, 9],
          ])
            Row(
              children: [
                for (final symbol in row)
                  button('$symbol', () => _addDigit('$symbol')),
              ],
            ),
          Row(
            children: [
              button(_value.startsWith('-') ? '-' : '+', _toggleSign),
              button('0', () => _addDigit('0')),
              button('⌫', _backSpace),
            ],
          ),
          Row(children: [button('Valider', _submit)]),
        ],
      ),
    );
  }

  // Boutons pour le clavier
  Widget button(String text, VoidCallback onTap) {
    final symbol = text;
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                spreadRadius: 5,
                blurRadius: 7,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: Ink(
              decoration: BoxDecoration(
                color: AppColors.accent,
                borderRadius: BorderRadius.circular(12),
                image: const DecorationImage(
                  image: AssetImage(AppAssets.textureButtonOverlay),
                  repeat: ImageRepeat.repeat,
                ),
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                splashColor: Colors.black.withValues(alpha: 0.35),
                highlightColor: Colors.black.withValues(alpha: 0.2),
                onTap: onTap,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 6,
                  ),
                  child: Center(
                    child: Text(
                      symbol,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Faire vibrer le téléphone
  void _haptic() => unawaited(HapticService.play(HapticPreset.mediumImpact));

  void _addDigit(String digit) {
    _haptic();
    setState(() => _value += digit);
  }

  void _backSpace() {
    _haptic();
    if (_value.isEmpty) return;
    setState(() => _value = _value.substring(0, _value.length - 1));
  }

  void _toggleSign() {
    _haptic();
    setState(() {
      _value = (_value.startsWith('-') ? _value.substring(1) : '-$_value');
    });
  }

  void _submit() {
    _haptic();
    widget.onSubmit(int.tryParse(_value) ?? 0);
    setState(() => _value = '');
  }
}
