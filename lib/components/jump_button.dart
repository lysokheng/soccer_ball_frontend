import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:soccer_ball_frontend/soccer_ball.dart';

class JumpButton extends SpriteComponent
    with HasGameRef<SoccerBall>, TapCallbacks {
  JumpButton();
  final margin = 32;
  final buttonSize = 64;

  @override
  FutureOr<void> onLoad() {
    sprite = Sprite(game.images.fromCache('HUD/JumpButton.png'));
    position = Vector2(
        game.size.x - margin - buttonSize, game.size.y - margin - buttonSize);
    priority = 10;
    return super.onLoad();
  }

  @override
  void onTapDown(TapDownEvent event) {
    game.player.hasJumped = true;
    super.onTapDown(event);
  }

  @override
  void onTapCancel(TapCancelEvent event) {
    game.player.hasJumped = false;
    super.onTapCancel(event);
  }
}
