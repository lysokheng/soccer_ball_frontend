import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:get/get.dart';
import 'package:soccer_ball_frontend/controller/game_controller.dart';

import 'package:soccer_ball_frontend/main.dart';
import 'package:soccer_ball_frontend/screen/world/Ground.dart';

class Player1 extends SpriteAnimationComponent
    with CollisionCallbacks, HasGameRef<SoccerGame> {
  final speed = 3;

  SoccerGameController controller =
      Get.put<SoccerGameController>(SoccerGameController());
  Player1({required posititon}) : super(position: posititon) {
    debugMode = true;
    size = Vector2(83, 100);
    anchor = Anchor.center;
  }
  bool onGround = false;
  bool facingRight = true;
  bool hitLeft = false;
  bool hitRight = false;

  @override
  FutureOr<void> onLoad() async {
    add(RectangleHitbox(size: Vector2(width * .7, height)));
    animation = gameRef.rideAnim;
    position = gameRef.size / 2;

    return super.onLoad();
  }

  @override
  void update(double dt) {
    super.update(dt);
    switch (gameRef.joyStick.direction) {
      case JoystickDirection.left:
        if (gameRef.player1.onGround && controller.introFinished.value) {
          print('push left');
          if (gameRef.player1.facingRight) {
            gameRef.player1.flipHorizontallyAroundCenter();
            gameRef.player1.facingRight = false;
          }
          if (!gameRef.player1.hitLeft) {
            gameRef.player1.x -= 10;
            gameRef.velocity.x -= gameRef.pushSpeed;
            gameRef.player1.animation = gameRef.pushAnim;
            Future.delayed(const Duration(milliseconds: 1200), () {
              if (gameRef.player1.animation != gameRef.jumpAnim) {
                gameRef.player1.animation = gameRef.rideAnim;
              }
            });
          }
        }
      case JoystickDirection.up:
      case JoystickDirection.upLeft:
      // TODO: Handle this case.
      case JoystickDirection.upRight:
      // TODO: Handle this case.
      case JoystickDirection.right:
        if (gameRef.player1.onGround && controller.introFinished.value) {
          print('push right');
          if (!gameRef.player1.facingRight) {
            gameRef.player1.facingRight = true;
            gameRef.player1.flipHorizontallyAroundCenter();
          }
          if (!gameRef.player1.hitRight) {
            gameRef.player1.x += 10;
            gameRef.velocity.x += gameRef.pushSpeed;
            gameRef.player1.animation = gameRef.pushAnim;
            Future.delayed(const Duration(milliseconds: 1200), () {
              if (gameRef.player1.animation != gameRef.jumpAnim) {
                gameRef.player1.animation = gameRef.rideAnim;
              }
            });
          }
        }
      case JoystickDirection.down:
      // TODO: Handle this case.
      case JoystickDirection.downRight:
      // TODO: Handle this case.
      case JoystickDirection.downLeft:
      // TODO: Handle this case.
      case JoystickDirection.idle:
        animation = game.idleAnim;
      default:
        break;
    }
    // if (x > 0 && gameRef.velocity.x <= 0) {
    //   gameRef.velocity.x + gameRef.groundFriction;

    //   if (gameRef.velocity.x > 0) {
    //     gameRef.velocity.x = 0;
    //   }
    // } else if (x < gameRef.mapWidth - width && gameRef.velocity.x >= 0) {
    //   //moving to the right
    //   gameRef.velocity.x -= gameRef.groundFriction;
    //   if (gameRef.velocity.x < 0) {
    //     gameRef.velocity.x = 0;
    //   }
    // } else {
    //   gameRef.velocity.x = 0;
    // }

    // if (gameRef.velocity.x == 0 && !onGround) {
    //   animation = game.idleAnim;
    // }
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
