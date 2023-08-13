import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:fruit_ninja/game/fruit_ninja.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Flame.device.fullScreen();
  await Flame.device.setLandscape();
  runApp(GameWidget<FruitNinjaGame>(
    game: FruitNinjaGame(),
    overlayBuilderMap: {
      "healthOverlay": (context, game) {
        return ValueListenableBuilder(
          valueListenable: game.remainingHealth,
          builder: (context, value, child) {
            List<Icon> heartIconList = [];
            for (int i = 0; i < 5; i++) {
              if (i < game.remainingHealth.value) {
                heartIconList.add(const Icon(
                  Icons.favorite,
                  size: 30,
                  color: Colors.red,
                ));
              } else {
                heartIconList.add(const Icon(
                  Icons.favorite_border,
                  size: 30,
                  color: Colors.red,
                ));
              }
            }
            return Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 20, top: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: heartIconList,
                  ),
                ));
          },
        );
      },
      "pauseOverlay": (context, game) {
        return Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: 20),
              child: GestureDetector(
                child: const Icon(
                  Icons.pause,
                  size: 30,
                  color: Colors.black,
                ),
                onTap: () {
                  game.pauseEngine();
                  game.overlays.add("pauseMenuOverlay");
                },
              ),
            ),
          );
        
      },
      "pauseMenuOverlay": (context, game) {
        return Center(
          child: Card(
            color: Colors.black.withOpacity(.5),
            child: Padding(padding: EdgeInsets.all(50),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Paused', style: TextStyle(color: Colors.white, fontSize: 40),),
                GestureDetector(
                  child: const Icon(
                Icons.play_arrow,
                size: 30,
                color: Colors.white,
              ),
              onTap: () {
                game.resumeEngine();
                game.overlays.remove("pauseMenuOverlay");
              },
                )
              ],
            ),),
          ),
        );
      },
      "gameOverOverlay": (context, game) {
        return Center(
          child: Card(
            color: Colors.black.withOpacity(.5),
            child: Padding(padding: const EdgeInsets.all(50),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Game Over', style: TextStyle(color: Colors.white, fontSize: 40),),
                GestureDetector(
                  child: const Icon(
                Icons.replay,
                size: 30,
                color: Colors.white,
              ),
              onTap: () {
                game.reset();
                game.overlays.remove("pauseMenuOverlay");
                game.overlays.remove("gameOverOverlay");
                game.resumeEngine();
              },
                )
              ],
            ),),
          ),
        );
      }
    },
  ));
}
