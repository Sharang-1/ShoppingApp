import 'package:flutter/material.dart';

class TextLink extends StatelessWidget {
  final String text;
  final Function onPressed;
  final bool enabled;
  const TextLink(this.text, {this.onPressed, this.enabled = true});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Text(
        text,
        style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: enabled ? Colors.grey[800] : Colors.grey[300],),
      ),
    );
  }
}
