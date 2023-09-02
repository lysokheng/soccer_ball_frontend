import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:soccer_ball_frontend/main.dart';
import 'package:soccer_ball_frontend/world/Ground.dart';

class Leena extends SpriteComponent
    with CollisionCallbacks, HasGameRef<LeenaGame> {
  Leena() : super() {
    debugMode = true;
  }
  bool onGround = false;
  @override
  FutureOr<void> onLoad() async {
    await super.onLoad();
    add(RectangleHitbox());
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);

    if (other is Ground) {
      gameRef.velocity.y = 0;
      onGround = true;
    }
  }
}
