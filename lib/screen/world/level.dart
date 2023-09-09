import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:soccer_ball_frontend/screen/world/Ground.dart';

class Level extends World {
  late TiledComponent level;

  @override
  FutureOr<void> onLoad() async {
    level = await TiledComponent.load('map_football.tmx', Vector2.all(16));
    final obstacleGroup = level.tileMap.getLayer<ObjectGroup>('ground');

    for (final obj in obstacleGroup!.objects) {
      add(Ground(
          size: Vector2(obj.width, obj.height),
          position: Vector2(obj.x + 40, obj.y + 40)));
    }

    add(level);
    return super.onLoad();
  }
}
