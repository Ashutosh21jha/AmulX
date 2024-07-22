import 'package:get/get.dart';

class ProfileImageController extends GetxController {
  RxString profileImage = ''.obs;

  String getImage() {
    return profileImage.value;
  }

  void setImage(String imagePath) {
    profileImage.value = imagePath;
    update();
  }
}
