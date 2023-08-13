import 'dart:async';
import 'dart:math';

import 'package:flame/components.dart';
import 'package:fruit_ninja/game/fruit_ninja.dart';

class Fruit extends SpriteComponent with HasGameRef<FruitNinjaGame> {
  final Sprite? upperHalfSprite;
  final Sprite? bottomHalfSprite;
  @override
  final Sprite? sprite;

  Fruit({this.sprite, this.upperHalfSprite, this.bottomHalfSprite})
      : super(sprite: sprite);

  Random random = Random();
  double? x0;
  double? y0;
  double theta = -pi / 2;
  static const double v0 = 250;
  static const double g = -170;
  double t = 0;
  double _rotationRate = 0;
  bool isSliced = false;
  bool isSlice = false;

  @override
  FutureOr<void> onLoad() {
    // TODO: implement onLoad
    theta = -pi / 2 * (.90 + random.nextDouble() * (.2));
    anchor = Anchor.center;
    size = Vector2(70, 70);
    _rotationRate = random.nextDouble();
    x = x0 ?? 0;
    y = y0 ?? 0;
    return super.onLoad();
  }

  @override
  void update(double dt) {
    // TODO: implement update
    if (y <= gameRef.size.y) {
      thrown(dt: dt, theta: theta);
    } else {
      gameRef.remove(this);
      if (!isSliced && !isSlice) {
        gameRef.remainingHealth.value -= 1;
      }
    }
    super.update(dt);
  }

  void thrown(
      {required double dt, double theta = pi, double v0 = v0, double g = g}) {
    angle += _rotationRate * 2 * pi * dt;
    t += dt;
    double dx = v0 * cos(theta) * t;
    double dy = (v0 * sin(theta) * t - 0.5 * g * t * t);
    x = x0! + dx;
    y = y0! + dy;
  }

  void split() {
    if (!isSliced) {
      isSliced = true;
      if (!isSlice) {
        gameRef.score += 1;
        //adding upperhalf
        var upperHalf = Fruit(sprite: upperHalfSprite);
        upperHalf.theta = 0;
        upperHalf.x0 = x;
        upperHalf.y0 = y;
        upperHalf.isSlice = true;
        //adding upperhalf
        var bottomHalf = Fruit(sprite: bottomHalfSprite);
        bottomHalf.theta = pi;
        bottomHalf.x0 = x;
        bottomHalf.y0 = y;
        bottomHalf.isSlice = true;
        //updating game components
        gameRef.remove(this);
        gameRef.add(upperHalf);
        gameRef.add(bottomHalf);
      }
    }
  }
}
