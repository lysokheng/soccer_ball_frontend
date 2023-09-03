import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:soccer_ball_frontend/actors/leena.dart';

class Gem extends SpriteComponent with CollisionCallbacks {
  final TiledObject tiledObject;
  Gem({required this.tiledObject}) : super() {
    debugMode = true;
  }
  @override
  FutureOr<void> onLoad() async {
    add(RectangleHitbox());
    await super.onLoad();
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    print('hit gem');
    if (other is Leena) {
      removeFromParent();
    }
    super.onCollision(intersectionPoints, other);
  }
}
