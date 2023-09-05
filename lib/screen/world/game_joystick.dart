import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart';

class GameJoyStick extends JoystickComponent {
  GameJoyStick()
      : super(
            knob: CircleComponent(
                radius: 30, paint: BasicPalette.red.withAlpha(159).paint()),
            margin: const EdgeInsets.only(left: 50, bottom: 50),
            background: CircleComponent(
                radius: 100, paint: BasicPalette.black.withAlpha(100).paint()));
}
