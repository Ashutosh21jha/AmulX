import 'package:amul/Utils/AppColors.dart';
import 'package:amul/screens/cart_components/cart_controller.dart';
import 'package:amul/screens/history.dart';
import 'package:amul/screens/home/food_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:package_info/package_info.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
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
  final remoteConfig = FirebaseRemoteConfig.instance;
  late String currentVersion = "";

  late String latestVersion = "";

  Future<void> fetchVersion() async {
    try {
      await remoteConfig.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 30),
        minimumFetchInterval: const Duration(seconds: 60),
      ));

      await remoteConfig.setDefaults({
        "AmulX_version": currentVersion,
      });

      await remoteConfig.fetchAndActivate();

      setState(() {
        latestVersion = remoteConfig.getString('AmulX_version');
      });

      print("Latest version: $latestVersion");
      checkForUpdate();
    } catch (e) {
      print('Error fetching remote config: $e');
    }
  }

  Future<void> getPackageInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      currentVersion = packageInfo.version;
    });
    print("current version :$currentVersion");
    fetchVersion();
  }

  void checkForUpdate() {
    if (currentVersion != latestVersion) {
      showUpdateDialog();
    } else {
      print("No update available");
    }
  }

  void launchPlayStore() async {
    const String packageName = "com.example.amul";

    const String url =
        "https://play.google.com/store/apps/details?id=com.devcomm.nsutx&pcampaignid=web_share";

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      const String webUrl =
          "https://play.google.com/store/apps/details?id=com.devcomm.nsutx&pcampaignid=web_share";
      if (await canLaunch(webUrl)) {
        await launch(webUrl);
      }
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

  @override
  void initState() {
    super.initState();
    CartController.to.fetchCart();
    CartController.to.fetchCurrentOrder();
  }

  Widget closedStoreMessage() {
    return const Expanded(
      child: Center(
        child: Text(
          'Store is Closed',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.red,
          ),
        ),
      ),
      // const SizedBox(height: 20),
    );
  }

  Widget openStoreContent() {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 45),
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
          const SizedBox(height: 30),
          GridView.count(
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
                      Get.to(() => const History(),
                          duration: const Duration(
                            milliseconds: 800,
                          ),
                          transition: Transition.rightToLeft);
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
        StreamBuilder(
          stream: db.collection('menu').doc('today menu').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              Center(
                child: Text('Error: ${snapshot.error}'),
              );
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              const Center(
                child: CircularProgressIndicator(),
              );
            }

            final sessionData = snapshot.data;
            final bool isStoreOpen = sessionData?['session'] ?? false;

            return isStoreOpen ? openStoreContent() : closedStoreMessage();
          },
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
