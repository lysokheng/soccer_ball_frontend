import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:soccer_ball_frontend/dashboard/controller/game_controller.dart';
import 'package:soccer_ball_frontend/soccer_ball.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class Dashboard extends StatelessWidget {
  final SoccerBall game;
  const Dashboard({
    super.key,
    required this.game,
  });
  @override
  Widget build(BuildContext context) {
    SoccerBallGameController controller =
        Get.put<SoccerBallGameController>(SoccerBallGameController());

    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ZoomTapAnimation(
              child: Image.asset(
            'assets/images/sound.png',
            width: 30.w,
          )),
          Container(
            height: 100.w,
            child: Column(
              children: [
                Container(
                  width: 200.w,
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                    image: AssetImage('assets/images/time_board.png'),
                  )),
                  child: Center(
                    child: Text(
                      '15:00',
                      style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                SizedBox(
                  height: 5.w,
                ),
                Container(
                  width: 200.w,
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/images/vs_board.png'),
                          fit: BoxFit.fill,
                          scale: 0.2)),
                  child: Stack(alignment: Alignment.center, children: [
                    Positioned(
                        child: Container(
                      width: 180.w,
                      height: 20.w,
                      // decoration: BoxDecoration(color: Colors.red),
                    )),
                    Positioned(
                      left: 5.w,
                      child: Text(
                        'MESSI',
                        style: TextStyle(
                            fontSize: 10.sp, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Positioned(
                      right: 5.w,
                      child: Text(
                        'RONALDO',
                        style: TextStyle(
                            fontSize: 10.sp, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Positioned(
                      left: 80.w,
                      child: Text(
                        '0',
                        style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                    Positioned(
                      right: 80.w,
                      child: Text(
                        '0',
                        style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                  ]),
                )
              ],
            ),
          ),
          ZoomTapAnimation(
            child: Image.asset(
              'assets/images/pause.png',
              width: 30.w,
            ),
          ),
        ],
      ),
    );
  }
}
