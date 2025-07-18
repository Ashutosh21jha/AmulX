import 'package:amul/Utils/AppColors.dart';
import 'package:amul/controllers/amul_status_controller.dart';
import 'package:amul/controllers/cart_controller.dart';
import 'package:amul/screens/history.dart';
import 'package:amul/screens/home/food_tile.dart';
import 'package:amul/services/remote_config_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:package_info/package_info.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:get/get.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomeState();
}

class _HomeState extends State<HomePage> {
  final db = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;
  late final AppColors2 appColors = Theme.of(context).extension<AppColors2>()!;

  late final RxBool storeOpen = Get.find<AmulXStatusController>().open;

  final RemoteConfigService remoteConfigService =
      Get.find<RemoteConfigService>();

  @override
  void initState() {
    super.initState();
    CartController.to.fetchCart();
    CartController.to.fetchCurrentOrder();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if ((await latestVersion) != remoteConfigService.amulXVersion) {
        showUpdateDialog();
      }
    });
  }

  Future<String> get latestVersion async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.version;
  }

  void launchPlayStore() async {
    const String packageName = "com.example.amul";

    final Uri url = Uri.parse(
        "https://play.google.com/store/apps/details?id=com.devcomm.nsutx&pcampaignid=web_share");

    if (await canLaunchUrl(url)) {
      await canLaunchUrl(url);
    }
  }

  void showUpdateDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Update Available"),
          content: const Text(
              "A new version of the AmulX is available. Update now?"),
          actions: <Widget>[
            ElevatedButton(
              child: const Text("Later"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: const Text("Update"),
              onPressed: () {
                launchPlayStore();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget closedStoreMessage() {
    return Expanded(
      child: Center(
        child: LottieBuilder.asset('assets/raw/store_closed.json'),
      ), // const SizedBox(height: 20),
    );
  }

  Widget openStoreContent() {
    return SingleChildScrollView(
      child: Column(
        children: [
          // const SizedBox(height: 45),
          SizedBox(height: MediaQuery.sizeOf(context).height * 0.03),
          Text(
            "Answer your\nappetite!",
            style: TextStyle(
              color: appColors.secondaryText,
              // color: Get.isDarkMode ? Colors.white60 : const Color(0xFF414042),
              fontSize: 26,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.02 * 16,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: MediaQuery.sizeOf(context).height * 0.03),
          GridView.count(
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            shrinkWrap: true,
            children: const [
              HomeFoodTile(title: 'Food', imageUrl: 'assets/images/food.png'),
              HomeFoodTile(
                  title: 'Drinks', imageUrl: 'assets/images/drinks.png'),
              HomeFoodTile(
                  title: 'Munchies', imageUrl: 'assets/images/munchies.png'),
              HomeFoodTile(title: 'Dairy', imageUrl: 'assets/images/dairy.png'),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // SystemChrome.setSystemUIOverlayStyle(const
    //   const SystemUiOverlayStyle(
    //     statusBarColor: Colors.transparent,
    //     statusBarIconBrightness: Brightness.dark,
    //   ),
    // );

    return Column(
      children: [
        const SizedBox(
          height: 40,
        ),
        Padding(
          padding:
              const EdgeInsets.only(left: 24, right: 30, top: 10, bottom: 10),
          child: SizedBox(
            height: 92,
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SvgPicture.asset(
                    "assets/images/logo.svg",
                    width: 85,
                    height: 30,
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.to(
                        () => const History(),
                        duration: const Duration(
                          milliseconds: 800,
                        ),
                      );
                    },
                    child: Icon(
                      Icons.history,
                      size: 30,
                      color: appColors.secondaryText,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Expanded(
          child: Obx(
            () => storeOpen.value ? openStoreContent() : closedStoreMessage(),
          ),
        ),
      ],
    );

    // return StreamBuilder<DocumentSnapshot>(

    //   stream: db.collection('menu').doc('today menu').snapshots(),
    //   builder: (context, snapshot) {
    //   },
    // );
  }
}
