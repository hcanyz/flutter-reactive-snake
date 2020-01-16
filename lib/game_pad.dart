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
            FlatButton(
              onPressed: () {
                if (onKeyDownEvent != null) {
                  onKeyDownEvent(LogicalKeyboardKey.arrowUp);
                }
              },
              child: Icon(
                Icons.arrow_upward,
                size: 50,
                color: Theme.of(context).primaryColor,
              ),
            )
          ],
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            FlatButton(
              onPressed: () {
                if (onKeyDownEvent != null) {
                  onKeyDownEvent(LogicalKeyboardKey.arrowLeft);
                }
              },
              child: Icon(
                Icons.arrow_back,
                size: 50,
                color: Theme.of(context).primaryColor,
              ),
            ),
            ConstrainedBox(
              constraints: BoxConstraints(minWidth: 20),
            ),
            FlatButton(
              onPressed: () {
                if (onKeyDownEvent != null) {
                  onKeyDownEvent(LogicalKeyboardKey.arrowRight);
                }
              },
              child: Icon(
                Icons.arrow_forward,
                size: 50,
                color: Theme.of(context).primaryColor,
              ),
            )
          ],
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            FlatButton(
              onPressed: () {
                if (onKeyDownEvent != null) {
                  onKeyDownEvent(LogicalKeyboardKey.arrowDown);
                }
              },
              child: Icon(
                Icons.arrow_downward,
                size: 50,
                color: Theme.of(context).primaryColor,
              ),
            )
          ],
        )
      ],
    );
  }
}
