import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:get/get.dart';
import 'package:soccer_ball_frontend/controller/game_controller.dart';
import 'package:soccer_ball_frontend/screen/actors/leena.dart';
import 'package:soccer_ball_frontend/main.dart';

class Gem extends SpriteComponent
    with CollisionCallbacks, HasGameRef<LeenaGame> {
  final TiledObject tiledObject;
  final GameController get = Get.put(GameController());
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
      gameRef.bonus.start();
      get.magicLevel += 1;
      print('gem: $get.magicLevel');
    }
    super.onCollision(intersectionPoints, other);
  }
}
