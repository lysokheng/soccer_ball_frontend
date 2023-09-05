import 'dart:math';

import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:soccer_ball_frontend/controller/game_controller.dart';
import 'package:soccer_ball_frontend/screen/actors/player1.dart';

import 'package:flame/components.dart';
import 'package:flame/events.dart';

import 'package:flame_audio/flame_audio.dart';
import 'package:flame_texturepacker/flame_texturepacker.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:soccer_ball_frontend/screen/world/custom_world.dart';
import 'package:soccer_ball_frontend/screen/world/game_joystick.dart';

import 'package:soccer_ball_frontend/screen/world/intro.dart';
import 'screen/dashboard/dashboard.dart';
import 'screen/world/Ground.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Flame.device.fullScreen();
  Flame.device.setLandscape();

  // runApp(MaterialApp(
  //   home: GameWidget(game: JoystickExample()),
  // ));
  runApp(GetMaterialApp(
    home: GameWidget(
      game: SoccerGame(),
      overlayBuilderMap: {
        'DashboardOverlay': (BuildContext context, SoccerGame game) {
          return Dashboard(
            game: SoccerGame(),
          );
        }
      },
    ),
  ));
}

class SoccerGame extends FlameGame with HasCollisionDetection, TapDetector {
  SoccerGameController controller =
      Get.put<SoccerGameController>(SoccerGameController());

  Player1 player1 = Player1(posititon: Vector2(600, 30));
  final double gravity = 4;
  final double pushSpeed = 3;
  final double groundFriction = .52;
  final double jumpForce = 200;
  Vector2 velocity = Vector2(0, 0);
  late TiledComponent homeMap;
  late SpriteAnimation rideAnim;
  late SpriteAnimation pushAnim;
  late SpriteAnimation idleAnim;
  late SpriteAnimation jumpAnim;
  late final double mapWidth;
  late AudioPool yay;
  late AudioPool bonus;
  late Timer countDown;
  late Intro intro;
  late Sprite dadSprite;
  late final GameJoyStick joyStick = GameJoyStick();

  @override
  Future<void> onLoad() async {
    // Create a camera component.
    final cameraComponent = CameraComponent(
      world: world,
    );
    countDown = Timer(1, onTick: () {
      if (controller.remainingTime > 0) {
        controller.remainingTime -= 1;
      }
    }, repeat: true);

    homeMap = await TiledComponent.load('map_football.tmx', Vector2.all(30));
    add(homeMap);

    double mapWidth = 30.0 * homeMap.tileMap.map.width;
    double mapHeight = 30.0 * homeMap.tileMap.map.height;
    final obstacleGroup = homeMap.tileMap.getLayer<ObjectGroup>('ground');

    for (final obj in obstacleGroup!.objects) {
      add(Ground(
          size: Vector2(obj.width, obj.height),
          position: Vector2(obj.x, obj.y)));
    }

    // camera.viewport = FixedResolutionViewport(Vector2(mapWidth, mapHeight));

    rideAnim = SpriteAnimation.spriteList(
        await fromJSONAtlas('ride.png', 'ride.json'),
        stepTime: 0.1);
    pushAnim = SpriteAnimation.spriteList(
        await fromJSONAtlas('push.png', 'push.json'),
        stepTime: 0.1);
    idleAnim = SpriteAnimation.spriteList(
        await fromJSONAtlas('idle.png', 'idle.json'),
        stepTime: 0.1);
    jumpAnim = SpriteAnimation.spriteList(
        await fromJSONAtlas('jump.png', 'jump.json'),
        stepTime: 0.1);
    player1.animation = rideAnim;
    add(player1);

    add(joyStick);

    //load audio file from local storage into game
    yay = await AudioPool.create(
        source: AssetSource('audio/sfx/yay.mp3'), maxPlayers: 0);
    bonus = await AudioPool.create(
        source: AssetSource('audio/sfx/bonus.wav'), maxPlayers: 0);

    //jump
    final shapeButton = HudButtonComponent(
      button: CircleComponent(
        radius: 25,
        paint: BasicPalette.black.paint(),
      ),
      buttonDown: CircleComponent(
        paint: BasicPalette.black.paint(),
        radius: 23,
      ),
      margin: const EdgeInsets.only(
        right: 40,
        bottom: 100,
      ),
      onPressed: () {
        if (player1.onGround && controller.introFinished.value) {
          print('jump up');
          player1.animation = jumpAnim;
          Future.delayed(const Duration(milliseconds: 1200), () {
            player1.animation = rideAnim;
          });

          if (controller.remainingTime.value > 0) {}
          player1.y -= 10;
          velocity.y = -jumpForce;
          player1.onGround = false;
        }
      },
    );
    add(shapeButton);
    // Set the viewport of the camera component to a fixed resolution viewport.
    cameraComponent.viewport = FixedResolutionViewport(Vector2(800, 600));

    // Add the camera component to the game world.
    add(cameraComponent);
    overlays.add('DashboardOverlay');

    dadSprite = await loadSprite('dad.png');
    intro = Intro(size: size);
    add(intro);
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (!player1.onGround) {
      velocity.y += gravity;
    }
    player1.position += velocity * dt;

    if (controller.timeStarted.value && controller.remainingTime.value > 0) {
      countDown.update(dt);
    }
  }

  @override
  void onTapDown(TapDownInfo info) {
    super.onTapDown(info);
    if (!controller.introFinished.value) {
      controller.introFinished.value = true;
      remove(intro);
    }
    // if (player1.onGround && controller.introFinished.value) {
    //   if (info.eventPosition.viewport.x < 100) {
    //     controller.timeStarted.value = true;
    //     print('push left');

    //     if (player1.facingRight) {
    //       player1.flipHorizontallyAroundCenter();
    //       player1.facingRight = false;
    //     }
    //     if (!player1.hitLeft) {
    //       player1.x -= 10;
    //       velocity.x -= pushSpeed;
    //       player1.animation = pushAnim;
    //       Future.delayed(const Duration(milliseconds: 1200), () {
    //         if (player1.animation != jumpAnim) {
    //           player1.animation = rideAnim;
    //         }
    //       });
    //     }
    //   } else if (info.eventPosition.viewport.x > size[0] - 100) {
    //     controller.timeStarted.value = true;

    //     print('push right');
    //     if (!player1.facingRight) {
    //       player1.facingRight = true;
    //       player1.flipHorizontallyAroundCenter();
    //     }
    //     if (!player1.hitRight) {
    //       player1.x += 10;
    //       velocity.x += pushSpeed;
    //       player1.animation = pushAnim;
    //       Future.delayed(const Duration(milliseconds: 1200), () {
    //         if (player1.animation != jumpAnim) {
    //           player1.animation = rideAnim;
    //         }
    //       });
    //     }
    //   }

    //   if (info.eventPosition.game.y < 100) {
    //     print('jump up');
    //     player1.animation = jumpAnim;
    //     Future.delayed(const Duration(milliseconds: 1200), () {
    //       player1.animation = rideAnim;
    //     });

    //     if (controller.remainingTime.value > 0) {}
    //     player1.y -= 10;
    //     velocity.y = -jumpForce;
    //     player1.onGround = false;
    //   }
    // }
  }
}
