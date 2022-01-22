import 'package:flutter/material.dart';

import '../shared/app_colors.dart';

/// A button that shows a busy indicator in place of title
class BusyButtonCicular extends StatefulWidget {
  final bool busy;
  final String title;
  final Function onPressed;
  final bool enabled;
  const BusyButtonCicular(
      {required this.title,
      this.busy = false,
      required this.onPressed,
      this.enabled = true});

  @override
  _BusyButtonCircularState createState() => _BusyButtonCircularState();
}

class _BusyButtonCircularState extends State<BusyButtonCicular> {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      heroTag: "Kaushik",
      onPressed: widget.enabled
          ? () async {
              await widget.onPressed();
            }
          : () async {},
      backgroundColor: widget.enabled ? logoRed : Colors.grey,
      child: Icon(
        Icons.arrow_forward,
        color: Colors.white,
      ),
    );
  }
}
