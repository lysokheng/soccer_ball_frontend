import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/src/services/keyboard_key.g.dart';
import 'package:flutter/src/services/raw_keyboard.dart';
import 'package:soccer_ball_frontend/components/collision_block.dart';
import 'package:soccer_ball_frontend/components/custom_hitbox.dart';
import 'package:soccer_ball_frontend/components/utils.dart';
import 'package:soccer_ball_frontend/soccer_ball.dart';

enum PlayerState { kick, forward, jump, fall }

class Player extends SpriteAnimationGroupComponent
    with HasGameRef<SoccerBall>, KeyboardHandler {
  String character;
  Player({position, required this.character}) : super(position: position);
  late final SpriteAnimation kickAnimation;
  late final SpriteAnimation forwardAnimation;
  late final SpriteAnimation jumpAnimation;

  final double stepTime = 0.1;
  final double _gravity = 9.8;
  final double _jumpForce = 460;
  final double _terminalVelocity = 300;

  double horizontalMovement = 0;
  double moveSpeed = 200;
  Vector2 velocity = Vector2.zero();
  bool isFacingRight = true;
  bool isOnGround = false;
  bool hasJumped = false;
  List<CollisionBlock> collisionBlock = [];
  CustomHitbox hitbox = CustomHitbox(
    offsetX: 0,
    offsetY: 0,
    width: 166,
    height: 198,
  );
  double fixedDeltaTime = 1 / 60;
  double accumlatedTime = 0;
  Vector2 startingPosition = Vector2.zero();

  @override
  FutureOr<void> onLoad() {
    _loadAllAnimations();
    // debugMode = true;

    startingPosition = Vector2(position.x, position.y);

    // add(RectangleHitbox(
    //   position: Vector2(hitbox.offsetX, hitbox.offsetY),
    //   size: Vector2(hitbox.width, hitbox.height),
    // ));
    return super.onLoad();
  }

  @override
  void update(double dt) {
    // accumlatedTime += dt;
    // while (accumlatedTime >= fixedDeltaTime) {
    //   _updatePlayerState();
    //   _updatePlayerMovement(fixedDeltaTime);
    //   _checkHorizontalCollisions();
    //   _applyGravity(fixedDeltaTime);
    //   _checkVerticalCollisions();
    // }
    // accumlatedTime -= fixedDeltaTime;

    _updatePlayerState();
    _updatePlayerMovement(fixedDeltaTime);
    _checkHorizontalCollisions();
    _applyGravity(fixedDeltaTime);
    _checkVerticalCollisions();
    super.update(dt);
  }

  @override
  bool onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    horizontalMovement = 0;
    final isLeftKeyPressed = keysPressed.contains(LogicalKeyboardKey.keyA) ||
        keysPressed.contains(LogicalKeyboardKey.arrowLeft);

    final isRightKeyPressed = keysPressed.contains(LogicalKeyboardKey.keyD) ||
        keysPressed.contains(LogicalKeyboardKey.arrowRight);

    horizontalMovement += isLeftKeyPressed ? -1 : 0;
    horizontalMovement += isRightKeyPressed ? 1 : 0;

    hasJumped = keysPressed.contains(LogicalKeyboardKey.space);

    return super.onKeyEvent(event, keysPressed);
  }

  void _loadAllAnimations() {
    kickAnimation = _spriteAnimation('kick', 4);
    forwardAnimation = _spriteAnimation('forward', 3);
    jumpAnimation = _spriteAnimation('forward', 1);

    // list of all animation
    animations = {
      PlayerState.kick: kickAnimation,
      PlayerState.forward: forwardAnimation,
      PlayerState.jump: jumpAnimation
    };

    //set current animation
    // current = PlayerState.kick;
  }

  SpriteAnimation _spriteAnimation(String state, int amount) {
    return SpriteAnimation.fromFrameData(
        game.images.fromCache('$character/$state.png'),
        SpriteAnimationData.sequenced(
            amount: amount,
            stepTime: stepTime,
            textureSize: Vector2(166, 198)));
  }

  void _updatePlayerMovement(double dt) {
    if (hasJumped && isOnGround) _playerJump(dt);

    // if (velocity.y > _gravity) isOnGround = false; // optional

    velocity.x = horizontalMovement * moveSpeed;
    position.x += velocity.x * dt;
  }

  void _playerJump(double dt) {
    // if (game.playSounds) FlameAudio.play('jump.wav', volume: game.soundVolume);
    velocity.y = -_jumpForce;
    position.y += velocity.y * dt;
    isOnGround = false;
    hasJumped = false;
  }

  void _updatePlayerState() {
    PlayerState playerState = PlayerState.forward;

    if (velocity.x < 0 && scale.x > 0) {
      flipHorizontallyAroundCenter();
    } else if (velocity.x > 0 && scale.x < 0) {
      flipHorizontallyAroundCenter();
    }

    // Check if moving, set running
    if (velocity.x > 0 || velocity.x < 0) playerState = PlayerState.forward;

    // check if Falling set to falling
    if (velocity.y > 0) playerState = PlayerState.forward;

    // Checks if jumping, set to jumping
    if (velocity.y < 0) playerState = PlayerState.kick;

    current = playerState;
  }

  void _checkHorizontalCollisions() {
    for (final block in collisionBlock) {
      if (!block.isPlatform) {
        if (checkCollision(this, block)) {
          if (velocity.x > 0) {
            velocity.x = 0;
            position.x = block.x - hitbox.offsetX - hitbox.width;
            break;
          }
          if (velocity.x < 0) {
            velocity.x = 0;
            position.x = block.x + block.width + hitbox.width + hitbox.offsetX;
            break;
          }
        }
      }
    }
  }

  void _applyGravity(double dt) {
    velocity.y += _gravity;
    velocity.y = velocity.y.clamp(-_jumpForce, _terminalVelocity);
    position.y += velocity.y * dt;
  }

  void _checkVerticalCollisions() {
    for (final block in collisionBlock) {
      if (block.isPlatform) {
        if (checkCollision(this, block)) {
          if (velocity.y > 0) {
            velocity.y = 0;
            position.y = block.y - hitbox.height - hitbox.offsetY;
            isOnGround = true;
            break;
          }
        }
      } else {
        if (checkCollision(this, block)) {
          if (velocity.y > 0) {
            velocity.y = 0;
            position.y = block.y - hitbox.height - hitbox.offsetY;
            isOnGround = true;
            break;
          }
          if (velocity.y < 0) {
            velocity.y = 0;
            position.y = block.y + block.height - hitbox.offsetY;
          }
        }
      }
    }
  }
}
