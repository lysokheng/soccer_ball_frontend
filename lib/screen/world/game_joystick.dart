import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart';

class GameJoyStick extends JoystickComponent {
  GameJoyStick()
      : super(
            knob: CircleComponent(
                radius: 15, paint: BasicPalette.red.withAlpha(159).paint()),
            margin: const EdgeInsets.only(left: 50, bottom: 25),
            background: CircleComponent(
                radius: 40, paint: BasicPalette.black.withAlpha(100).paint()),
            size: 10);
}
