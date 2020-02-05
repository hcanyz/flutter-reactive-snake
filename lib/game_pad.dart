import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class GamePad extends StatelessWidget {
  final ValueChanged<LogicalKeyboardKey> onKeyDownEvent;

  const GamePad({@required this.onKeyDownEvent});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            createButton(
                context, LogicalKeyboardKey.arrowUp, Icons.arrow_upward)
          ],
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            createButton(
                context, LogicalKeyboardKey.arrowLeft, Icons.arrow_back),
            ConstrainedBox(
              constraints: BoxConstraints(minWidth: 20),
            ),
            createButton(
                context, LogicalKeyboardKey.arrowRight, Icons.arrow_forward)
          ],
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            createButton(
                context, LogicalKeyboardKey.arrowDown, Icons.arrow_downward)
          ],
        )
      ],
    );
  }

  FlatButton createButton(
      BuildContext context, LogicalKeyboardKey key, IconData icon) {
    return FlatButton(
      onPressed: () {
        if (onKeyDownEvent != null) {
          onKeyDownEvent(key);
        }
      },
      child: Icon(
        icon,
        size: 50,
        color: Theme.of(context).primaryColor,
      ),
    );
  }
}
