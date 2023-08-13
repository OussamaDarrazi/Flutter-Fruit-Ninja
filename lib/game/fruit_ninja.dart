import 'dart:async';
import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:fruit_ninja/components/fruit.dart';
import 'package:fruit_ninja/config/config.dart';

class FruitNinjaGame extends FlameGame with DragCallbacks {
  double throwInterval = 2;
  double t0 = 0;
  double t1 = 0;
  ValueNotifier<int> remainingHealth = ValueNotifier(5);
  int score = 0;
  var scoreText = TextComponent(
      text: '0',
      position: Vector2(20, 20),
      textRenderer: TextPaint(
          style: const TextStyle(
        color: Colors.black,
        fontSize: 40,
      )));

  @override
  Color backgroundColor() => const Color.fromARGB(255, 219, 219, 219);

  void throwRandomFruit() async {
    final sprite = FruitSprites
        .fruitSprites[Random().nextInt(FruitSprites.fruitSprites.length)];
    final uncutSprite = await Sprite.load(sprite[0]);
    final upperHalfSprite = await Sprite.load(sprite[1]);
    final bottomHalfSprite = await Sprite.load(sprite[2]);
    final fruit = Fruit(
        sprite: uncutSprite,
        upperHalfSprite: upperHalfSprite,
        bottomHalfSprite: bottomHalfSprite);
    fruit.x0 = size.x / 3 + Random().nextInt(size.x.toInt() ~/ 3).toDouble();
    fruit.y0 = size.y;
    add(fruit);
  }

  @override
  FutureOr<void> onLoad() async {
    overlays.add("healthOverlay");
    overlays.add("pauseOverlay");
    add(scoreText);
    final rushtimer = TimerComponent(
      repeat: true,
      period: 10, //TODO: the issue is the random double is fixed on load to fix implement timer in on update
      onTick: (){
        throwInterval = .5;
        add(TimerComponent(period: 5, onTick: () {
          throwInterval = 2;
        },));
      },
    );
    add(rushtimer);
    return super.onLoad();
  }

  @override
  void update(double dt) {
    // TODO: implement update

    t1 += dt;
    if (t1 - t0 >= throwInterval + Random().nextDouble()) {
      t0 = t1;
      throwRandomFruit();
    }

    //updating the score
    scoreText.text = score.toString();

    //checking for game over
    if (remainingHealth.value <= 0) {
      pauseEngine();
      overlays.add("gameOverOverlay");
    }
    super.update(dt);
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    // TODO: implement onDragUpdate
    children.whereType<Fruit>().forEach((fruit) {
      if (fruit
          .toRect()
          .contains(Offset(event.devicePosition.x, event.devicePosition.y))) {
        fruit.split();
      }
    });
    super.onDragUpdate(event);
  }

  void reset() {
    score = 0;
    remainingHealth.value = 5;
    removeAll(children.whereType<Fruit>());
  }
}
