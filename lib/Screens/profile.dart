import 'package:flutter/material.dart';
import 'profile_screens/about.dart';
import 'profile_screens/terms.dart';
import 'profile_screens/privacy.dart';
import 'profile_screens/editprofile.dart';
import 'profile_screens/faq.dart';
import 'profile_screens/profile_card.dart';

const EdgeInsets _paddingButtons =
    EdgeInsets.symmetric(horizontal: 12, vertical: 8);

const List<BoxShadow> _shadows = [
  BoxShadow(
    color: Color(0x28606170),
    blurRadius: 4,
    offset: Offset(0, 2),
    spreadRadius: 0,
  ),
  BoxShadow(
    color: Color(0x0A28293D),
    blurRadius: 1,
    offset: Offset(0, 0),
    spreadRadius: 0,
  )
];

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Profile',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontFamily: 'Epilogue',
            fontWeight: FontWeight.w700,
            height: 0.06,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          color: Colors.white,
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back),
        ),
        actions: const [
          SizedBox(width: 48),
        ],
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.25,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF00074B),
                  Color(0xFF2D55C0),
                  Color(0xFF2D55C0),
                  Color(0xFF138BF9)
                ],
              ),
            ),
          ),
          Align(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 100),
                  // PROFILE CARD
                  Container(
                    width: 327,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: ShapeDecoration(
                      color: const Color.fromARGB(255, 255, 255, 255),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40),
                      ),
                      shadows: _shadows,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 60,
                              height: 60,
                              child: Stack(
                                children: [
                                  Positioned(
                                    left: 0,
                                    top: 0,
                                    child: Container(
                                      width: 60,
                                      height: 60,
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                          image: NetworkImage(
                                              'https://picsum.photos/seed/60/60'),
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 16),
                        const Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Akhil Marks',
                                style: TextStyle(
                                  color: Color(0xFF57585B),
                                  fontSize: 14,
                                  fontFamily: 'Epilogue',
                                  fontWeight: FontWeight.w400,
                                  height: 0.07,
                                )),
                            SizedBox(height: 20),
                            Text('2022UPD9505',
                                style: TextStyle(
                                  color: Color(0xFF57585B),
                                  fontSize: 14,
                                  fontFamily: 'Epilogue',
                                  fontWeight: FontWeight.w400,
                                  height: 0.07,
                                )),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  const Text(
                    'Account',
                    style: TextStyle(
                      color: Color(0xFF57585B),
                      fontSize: 14,
                      fontFamily: 'Epilogue',
                      fontWeight: FontWeight.w500,
                      height: 0.08,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // PROFILE
                  ProfileCard(
                      icon: Icons.person,
                      text: "Profile",
                      screen: const EditProfile(),
                      color: const Color(0xFFA287F8)),
                  const SizedBox(height: 16),
                  // ABOUT US
                  ProfileCard(
                      icon: Icons.info_outline,
                      text: "About Us",
                      screen: const About(),
                      color: const Color(0xFF02B9F0)),
                  const SizedBox(height: 16),
                  // FAQ
                  ProfileCard(
                      icon: Icons.question_answer_outlined,
                      text: "FAQ",
                      screen: const Faq(),
                      color: const Color(0xFFFC6DBB)),
                  const SizedBox(height: 16),
                  // TERMS AND CONDITION
                  ProfileCard(
                      icon: Icons.file_copy,
                      text: "Terms and Conditions",
                      screen: const Terms(),
                      color: const Color(0xFF3BA889)),
                  const SizedBox(height: 16),
                  // PRIVACY POLICY
                  ProfileCard(
                      icon: Icons.shield_outlined,
                      text: "Privacy Policy",
                      screen: const Privacy(),
                      color: const Color(0xFFFBBC04)),
                  const SizedBox(height: 16),
                  // LOGOUT
                  Container(
                    width: 327,
                    padding: _paddingButtons,
                    decoration: ShapeDecoration(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(
                            width: 1, color: Color(0xFFF3F3F3)),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      shadows: _shadows,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: ShapeDecoration(
                            color: const Color(0xFFF57878),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 24,
                                    height: 24,
                                    clipBehavior: Clip.antiAlias,
                                    decoration: const BoxDecoration(),
                                    child: const Icon(
                                      Icons.logout,
                                      color: Colors.white,
                                      size: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        const Expanded(
                          child: SizedBox(
                            child: Text(
                              'Logout',
                              style: TextStyle(
                                color: Color(0xFFF46363),
                                fontSize: 16,
                                fontFamily: 'Epilogue',
                                fontWeight: FontWeight.w400,
                                height: 0.08,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ]),
          )
        ],
      ),
      // bottomNavigationBar: const BottomNav(),
    );
  }
}
