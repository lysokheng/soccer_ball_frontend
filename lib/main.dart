import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:soccer_ball_frontend/dashboard/dashboard.dart';
import 'package:soccer_ball_frontend/soccer_ball.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Flame.device.fullScreen();
  await Flame.device.setLandscape();
  SoccerBall game = SoccerBall();
  runApp(ScreenUtilInit(
    designSize: const Size(412, 732),
    minTextAdapt: true,
    splitScreenMode: true,
    child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Soccer Ball',
        home: Scaffold(
            body: GameWidget(
          game: kDebugMode ? SoccerBall() : game,
          overlayBuilderMap: {
            'DashboardOverlay': (BuildContext context, SoccerBall game) {
              return Dashboard(game: game);
            }
          },
        ))),
  ));
}
