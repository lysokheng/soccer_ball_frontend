import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

import '../../leena_game.dart';
import '../world/Ground.dart';

class Leena extends SpriteAnimationComponent
    with CollisionCallbacks, HasGameRef<LeenaGame> {
  Leena({required posititon}) : super(position: posititon) {
    debugMode = true;
    size = Vector2(83, 100);
    anchor = Anchor.bottomCenter;
  }
  bool onGround = false;
  bool facingRight = true;
  bool hitLeft = false;
  bool hitRight = false;

  @override
  FutureOr<void> onLoad() async {
    await super.onLoad();

    add(RectangleHitbox(size: Vector2(width * .7, height)));
  }

  @override
  void update(double dt) {
    super.update(dt);
    //moving left
    if (x > 0 && gameRef.velocity.x <= 0) {
      gameRef.velocity.x + gameRef.groundFriction;

      if (gameRef.velocity.x > 0) {
        gameRef.velocity.x = 0;
      }
    } else if (x < gameRef.mapWidth - width && gameRef.velocity.x >= 0) {
      //moving to the right
      gameRef.velocity.x -= gameRef.groundFriction;
      if (gameRef.velocity.x < 0) {
        gameRef.velocity.x = 0;
      }
    } else {
      gameRef.velocity.x = 0;
    }

    if (gameRef.velocity.x == 0 && !onGround) {
      animation = game.idleAnim;
    }
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);

    if (other is Ground) {
      if (gameRef.velocity.y > 0) {
        if (intersectionPoints.length == 2) {
          var x1 = intersectionPoints.first[0];
          var x2 = intersectionPoints.last[0];
          if ((x1 - x2).abs() < 2) {
            //hit the side, so send down with gravity
            gameRef.velocity.y = 100;
          } else {
            // hit ground
            gameRef.velocity.y = 0;
            onGround = true;
          }
        }
      }
      if (gameRef.velocity.x != 0) {
        for (var point in intersectionPoints) {
          if (y - 5 >= point[1]) {
            print('hit on the side ground');
            gameRef.velocity.x = 0;
            if (point[0] > x) {
              print('hit right');
              hitRight = true;
              hitLeft = false;
            } else {
              print('hit left');
              hitLeft = true;
              hitRight = false;
            }
          }
        }
      }
    }
  }

  @override
  void onCollisionEnd(PositionComponent other) {
    super.onCollisionEnd(other);
    onGround = false;
    hitLeft = false;
    hitRight = false;
  }
}
