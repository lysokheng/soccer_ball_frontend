import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flame_texturepacker/flame_texturepacker.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:soccer_ball_frontend/screen/actors/gem.dart';
import 'package:soccer_ball_frontend/screen/actors/leena.dart';
import 'package:soccer_ball_frontend/screen/dashboard/dashboard.dart';
import 'package:soccer_ball_frontend/screen/world/Ground.dart';
import 'package:soccer_ball_frontend/screen/world/intro.dart';

import 'controller/game_controller.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Flame.device.fullScreen();
  Flame.device.setLandscape();
  runApp(GetMaterialApp(
    home: Scaffold(
      body: GameWidget(
        game: LeenaGame(),
        overlayBuilderMap: {
          'DashboardOverlay': (BuildContext context, LeenaGame game) {
            return Dashboard(
              game: LeenaGame(),
            );
          }
        },
      ),
    ),
  ));
}

class LeenaGame extends FlameGame with HasCollisionDetection, TapDetector {
  GameController controller = Get.put<GameController>(GameController());

  Leena leena = Leena(posititon: Vector2(600, 30));
  final double gravity = 2.8;
  final double pushSpeed = 80;
  final double groundFriction = .52;
  final double jumpForce = 180;
  Vector2 velocity = Vector2(0, 0);
  late TiledComponent homeMap;
  late SpriteAnimation rideAnim;
  late SpriteAnimation pushAnim;
  late SpriteAnimation idleAnim;
  late SpriteAnimation jumpAnim;
  late double mapWidth;
  late AudioPool yay;
  late AudioPool bonus;
  late Timer countDown;
  late Intro intro;
  late Sprite dadSprite;
  @override
  FutureOr<void> onLoad() async {
    await super.onLoad();

    countDown = Timer(1, onTick: () {
      if (controller.remainingTime > 0) {
        controller.remainingTime -= 1;
      }
    }, repeat: true);

    homeMap = await TiledComponent.load('map2.tmx', Vector2.all(32));
    add(homeMap);

    mapWidth = 32.0 * homeMap.tileMap.map.width;
    double mapHeight = 32.0 * homeMap.tileMap.map.height;
    final obstacleGroup = homeMap.tileMap.getLayer<ObjectGroup>('ground');

    for (final obj in obstacleGroup!.objects) {
      add(Ground(
          size: Vector2(obj.width, obj.height),
          position: Vector2(obj.x, obj.y)));
    }

    final gemGroup = homeMap.tileMap.getLayer<ObjectGroup>('gems');
    controller.numGems.value = gemGroup!.objects.length;
    for (final gem in gemGroup!.objects) {
      var gemSprite = await loadSprite('gems/${gem.type}.png');
      add(Gem(tiledObject: gem)
        ..sprite = gemSprite
        ..position = Vector2(gem.x, gem.y - gem.height)
        ..size = Vector2(gem.width, gem.height));
    }
    // camera.viewport = FixedResolutionViewport(Vector2(mapWidth, mapHeight));
    camera.viewport = FixedResolutionViewport(Vector2(1280, mapHeight));

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
    leena..animation = rideAnim;
    add(leena);

    camera.followComponent(leena,
        worldBounds: Rect.fromLTRB(0, 0, mapWidth, mapHeight));

    //load audio file from local storage into game
    yay = await AudioPool.create(
        source: AssetSource('audio/sfx/yay.mp3'), maxPlayers: 0);
    bonus = await AudioPool.create(
        source: AssetSource('audio/sfx/bonus.wav'), maxPlayers: 0);

    overlays.add('DashboardOverlay');

    dadSprite = await loadSprite('dad.png');
    intro = Intro(size: size);
    add(intro);
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (!leena.onGround) {
      velocity.y += gravity;
    }
    leena.position += velocity * dt;

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
    if (leena.onGround && controller.introFinished.value) {
      if (info.eventPosition.viewport.x < 100) {
        controller.timeStarted.value = true;
        print('push left');

        if (leena.facingRight) {
          leena.flipHorizontallyAroundCenter();
          leena.facingRight = false;
        }
        if (!leena.hitLeft) {
          leena.x -= 10;
          velocity.x -= pushSpeed;
          leena.animation = pushAnim;
          Future.delayed(const Duration(milliseconds: 1200), () {
            if (leena.animation != jumpAnim) {
              leena.animation = rideAnim;
            }
          });
        }
      } else if (info.eventPosition.viewport.x > size[0] - 100) {
        controller.timeStarted.value = true;

        print('push right');
        if (!leena.facingRight) {
          leena.facingRight = true;
          leena.flipHorizontallyAroundCenter();
        }
        if (!leena.hitRight) {
          leena.x += 10;
          velocity.x += pushSpeed;
          leena.animation = pushAnim;
          Future.delayed(const Duration(milliseconds: 1200), () {
            if (leena.animation != jumpAnim) {
              leena.animation = rideAnim;
            }
          });
        }
      }

      if (info.eventPosition.game.y < 100) {
        print('jump up');
        leena.animation = jumpAnim;
        Future.delayed(const Duration(milliseconds: 1200), () {
          leena.animation = rideAnim;
        });

        if (controller.remainingTime.value > 0) {}
        leena.y -= 10;
        velocity.y = -jumpForce;
        leena.onGround = false;
      }
    }
  }
}
