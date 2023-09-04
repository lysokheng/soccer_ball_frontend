import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:soccer_ball_frontend/controller/game_controller.dart';
import 'package:soccer_ball_frontend/main.dart';

class Dashboard extends StatelessWidget {
  final LeenaGame game;
  const Dashboard({
    super.key,
    required this.game,
  });
  @override
  Widget build(BuildContext context) {
    GameController controller = Get.put<GameController>(GameController());
    return Obx(() {
      return controller.introFinished.value
          ? Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Obx(
                        () => Text(
                          'Magic: ${controller.magicLevel}',
                          style: TextStyle(fontSize: 24, fontFamily: 'Arcade'),
                        ),
                      ),
                      SizedBox(
                        width: 100,
                      ),
                      Obx(
                        () => Text(
                          'Power Remaining: ${controller.remainingTime}',
                          style: TextStyle(fontSize: 24, fontFamily: 'Arcade'),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                controller.remainingTime.value > 0
                    ? Container()
                    : controller.magicLevel.value == controller.numGems.value
                        ? const Text(
                            'YOU WON',
                            style: TextStyle(
                                fontSize: 80,
                                color: Colors.green,
                                fontFamily: 'Arcade'),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'GAME OVER',
                                style: TextStyle(
                                    fontSize: 80,
                                    color: Colors.red,
                                    fontFamily: 'Arcade'),
                              )
                            ],
                          )
              ],
            )
          : Container();
    });
  }
}
