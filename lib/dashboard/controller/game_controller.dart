import 'package:get/get.dart';

class SoccerBallGameController extends GetxController {
  RxInt remainingTime = 30.obs;
  RxBool timeStarted = false.obs;
  RxBool introFinished = false.obs;
}
