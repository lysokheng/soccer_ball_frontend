import 'dart:async';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../../leena_game.dart';

class Intro extends PositionComponent with HasGameRef<LeenaGame> {
  Intro({required size}) : super(size: size);
  late SpriteComponent dad;
  String introString =
      'Leena, this is your father. My ship has crashed and the crystals  that power my '
      'engines are gone. I will be trapped here unless '
      'you can gather 4 magic crystals and bring them to me. '
      'The only vehicle that can move quickly in the gravity of '
      'this planet is the hoverboard I made for you. Good luck. ';

  @override
  void render(Canvas canvas) {
    canvas.drawColor(Colors.blueGrey, BlendMode.src);
    super.render(canvas);
  }

  @override
  FutureOr<void> onLoad() {
    dad = SpriteComponent()
      ..sprite = gameRef.dadSprite
      ..size = Vector2(size.x, size.y)
      ..position = Vector2(size.x / 2, 50);
    add(dad);
    add(IntroBox(introString, size.x / 2)..position = Vector2(100, 50));
    return super.onLoad();
  }
}

class IntroBox extends TextBoxComponent {
  IntroBox(String text, double width)
      : super(
            text: text,
            textRenderer: TextPaint(
                style: TextStyle(fontSize: 32, color: Colors.black87)),
            boxConfig: TextBoxConfig(timePerChar: 0.05, maxWidth: width));

  @override
  void drawBackground(Canvas c) {
    // TODO: implement drawBackground

    Rect rect = Rect.fromLTWH(0, 0, width, height);
    c.drawRect(rect, Paint()..color = Colors.white24);
    super.drawBackground(c);
  }
}
