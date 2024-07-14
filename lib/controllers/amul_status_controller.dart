import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class AmulXStatusController extends GetxController {
  final RxBool open = RxBool(false);

  @override
  void onInit() {
    fetchAmulXStatus();
    super.onInit();
  }

  void fetchAmulXStatus() async {
    FirebaseFirestore.instance
        .collection('menu')
        .doc('today menu')
        .snapshots()
        .listen((event) {
      open.value =
          event.data() == null ? false : (event.data()!['session'] ?? false);
    });
  }
}
