import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:soccer_ball_frontend/actors/player.dart';
import 'package:soccer_ball_frontend/components/ball.dart';
import 'package:soccer_ball_frontend/components/collision_block.dart';

class MapSoccerBall extends World {
  final Player player;
  MapSoccerBall({required this.player}) : super() {
    debugMode = true;
  }
  late TiledComponent map;
  List<CollisionBlock> collisionBlock = [];
  Player bot = Player(character: 'Ronaldo');

  @override
  FutureOr<void> onLoad() async {
    map = await TiledComponent.load('map_football.tmx', Vector2.all(30));
    add(map);
    // add(ball);
    final spawnPointsLayer = map.tileMap.getLayer<ObjectGroup>('spawnPoint');

    for (final spawnPoint in spawnPointsLayer!.objects) {
      switch (spawnPoint.class_) {
        case 'Player':
          player.position = Vector2(spawnPoint.x, spawnPoint.y);
          add(player);
          break;
        case 'Bot':
          bot.position = Vector2(spawnPoint.x, spawnPoint.y);
          add(bot);
          break;

        default:
      }
    }

    final collisionsLayer = map.tileMap.getLayer<ObjectGroup>('ground');
    if (collisionsLayer != null) {
      for (final collision in collisionsLayer.objects) {
        final ground = CollisionBlock(
            position: Vector2(collision.x, collision.y),
            size: Vector2(collision.width, collision.height));
        collisionBlock.add(ground);
        add(ground);
      }
    }
    player.collisionBlock = collisionBlock;
    bot.collisionBlock = collisionBlock;

    return super.onLoad();
  }
}
