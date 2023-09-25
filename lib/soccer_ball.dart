import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/painting.dart';
import 'package:soccer_ball_frontend/actors/player.dart';
import 'package:soccer_ball_frontend/components/ball.dart';
import 'package:soccer_ball_frontend/components/jump_button.dart';
import 'package:soccer_ball_frontend/world/map_soccer_ball.dart';

class SoccerBall extends FlameGame
    with HasKeyboardHandlerComponents, DragCallbacks, TapCallbacks {
  late final CameraComponent cam;
  Player player = Player(character: 'Messi');

  late JoystickComponent joystick;
  bool showControllers = true;

  @override
  FutureOr<void> onLoad() async {
    // await images.load('Ball/idle.png');

    // load all images into cache
    await images.loadAllImages();
    await loadSprite('Ball/idle.png');

    final world = MapSoccerBall(player: player);
    cam = CameraComponent.withFixedResolution(
        width: 1920, height: 1080, world: world);
    cam.viewfinder.anchor = Anchor.topLeft;
    addAll([
      cam,
      world,
    ]);

    if (showControllers) {
      addJoyStick();
      add(JumpButton());
    }
    overlays.add('DashboardOverlay');

    return super.onLoad();
  }

  @override
  void update(double dt) {
    if (showControllers) {
      updateJoystick();
    }
    super.update(dt);
  }

  void addJoyStick() {
    joystick = JoystickComponent(
        size: 15,
        margin: const EdgeInsets.only(left: 60, bottom: 15),
        knob: SpriteComponent(
          sprite: Sprite(
            images.fromCache('HUD/knob.png'),
          ),
        ),
        background: SpriteComponent(
            sprite: Sprite(
          images.fromCache('HUD/joystick.png'),
        )));
    add(joystick);
  }

  void updateJoystick() {
    switch (joystick.direction) {
      case JoystickDirection.left:
      case JoystickDirection.upLeft:
      case JoystickDirection.downLeft:
        player.horizontalMovement = -1;
        break;

      case JoystickDirection.right:
      case JoystickDirection.upRight:
      case JoystickDirection.downRight:
        player.horizontalMovement = 1;
        break;
      default:
        player.horizontalMovement = 0;
        break;
    }
  }
}
