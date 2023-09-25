import 'package:flame_forge2d/flame_forge2d.dart';

class Floor extends BodyComponent {
  final worldSize = Vector2(19.2, 10.8);

  @override
  Body createBody() {
    final bodyDef = BodyDef(
      position: Vector2(0, worldSize.y - .75),
      type: BodyType.static,
    );

    final shape = EdgeShape()..set(Vector2.zero(), Vector2(worldSize.x, 0));

    final fixtureDef = FixtureDef(shape);

    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }
}
