import 'package:flutter/material.dart';

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

class ProfileCard extends StatelessWidget {
  final String text;
  final IconData icon;
  final Widget screen;
  final Color color;

  ProfileCard(
      {Key? key,
      required this.text,
      required this.icon,
      required this.screen,
      required this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => screen),
        );
      },
      child: Container(
        width: 327,
        padding: _paddingButtons,
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            side: const BorderSide(width: 1, color: Color(0xFFF3F3F3)),
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
                color: color ?? Colors.white,
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
                        child: Icon(
                          icon,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: SizedBox(
                child: Text(
                  text,
                  style: const TextStyle(
                    color: Color(0xFF282828),
                    fontSize: 16,
                    fontFamily: 'Epilogue',
                    fontWeight: FontWeight.w400,
                    height: 0.08,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            SizedBox(
              width: 16,
              height: 16,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 16,
                    height: 16,
                    child: Icon(
                      Icons.arrow_forward_ios_sharp,
                      color: const Color.fromARGB(255, 0, 0, 0),
                      size: 16,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
