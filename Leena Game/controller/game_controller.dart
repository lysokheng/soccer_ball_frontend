import 'package:get/get.dart';

class LeenaGameController extends GetxController {
  RxInt magicLevel = 0.obs;
  RxInt remainingTime = 30.obs;
  RxBool timeStarted = false.obs;
  RxBool introFinished = false.obs;
  RxInt numGems = 0.obs;
}
