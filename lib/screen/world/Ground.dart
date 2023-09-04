import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

class Ground extends PositionComponent {
  Ground({required size, required position})
      : super(size: size, position: position) {
    debugMode = true;
  }

  @override
  Future<FutureOr<void>> onLoad() async {
    await super.onLoad();
    add(RectangleHitbox());
  }
}
