import 'package:amul/Utils/AppColors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ListItem extends StatefulWidget {
  final String id;
  final String items;
  final String orderStatus;
  final DateTime timestamp;
  final String orderID;
  final double totalAmount;

  const ListItem({
    Key? key,
    required this.id,
    required this.items,
    required this.orderStatus,
    required this.orderID,
    required this.timestamp,
    required this.totalAmount,
  }) : super(key: key);

  @override
  _ListItemState createState() => _ListItemState();
}

class _ListItemState extends State<ListItem>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  late AnimationController _controller;
  late Animation<double> _heightFactorAnimation;
  final auth = FirebaseAuth.instance;
  final db = FirebaseFirestore.instance;

  String get userId => auth.currentUser?.email ?? '';

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _heightFactorAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  Stream<ImageProvider> getProfilePicture() async* {
    FirebaseStorage storage = FirebaseStorage.instance;
    while (true) {
      try {
        String downloadURL =
            await storage.ref('user/pp_$userId.jpg').getDownloadURL();
        yield NetworkImage(downloadURL);
      } catch (e) {
        yield const AssetImage('assets/images/avatar.png');
      }
      await Future.delayed(const Duration(seconds: 2));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Column(
        children: [
          InkWell(
            onTap: _toggleExpanded,
            child: Container(
              width: double.infinity,
              height: 70,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  side: const BorderSide(width: 1, color: Color(0xFFF3F3F3)),
                  borderRadius: BorderRadius.circular(16),
                ),
                shadows: const [
                  BoxShadow(
                    color: Color(0x28606170),
                    blurRadius: 2,
                    offset: Offset(0, 0.50),
                    spreadRadius: 0,
                  ),
                  BoxShadow(
                    color: Color(0x1428293D),
                    blurRadius: 1,
                    offset: Offset(0, 0),
                    spreadRadius: 0,
                  )
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // StreamBuilder<ImageProvider>(
                  //   stream: getProfilePicture(),
                  //   builder: (BuildContext context,
                  //       AsyncSnapshot<ImageProvider<Object>> snapshot) {
                  //     if (snapshot.connectionState == ConnectionState.waiting) {
                  //       return const SizedBox(
                  //         height: 60,
                  //         width: 60,
                  //         child: Center(
                  //           child: CircularProgressIndicator(
                  //             color: AppColors.blue,
                  //           ),
                  //         ),
                  //       );
                  //     } else {
                  //       return Container(
                  //         width: 60,
                  //         height: 60,
                  //         decoration: BoxDecoration(
                  //           shape: BoxShape.circle,
                  //           image: DecorationImage(
                  //             image: snapshot.data!,
                  //             fit: BoxFit.cover,
                  //           ),
                  //         ),
                  //       );
                  //     }
                  //   },
                  // ),
                  // const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: Text(
                            widget.orderID,
                            style: const TextStyle(
                              color: Color(0xFF282828),
                              fontSize: 12,
                              fontFamily: 'Epilogue',
                              fontWeight: FontWeight.w700,
                              height: 0.07,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: Text(
                            DateFormat('MMM d, y h:mm a')
                                .format(widget.timestamp),
                            style: const TextStyle(
                              color: Color(0xFF36414C),
                              fontSize: 14,
                              fontFamily: 'Epilogue',
                              fontWeight: FontWeight.w400,
                              height: 0.07,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    widget.orderStatus,
                    style: TextStyle(
                      color: widget.orderStatus == "Declined" ? AppColors.red : const Color(0xFF18AE86),
                      fontSize: 14,
                      fontFamily: 'Urbanist',
                      fontWeight: FontWeight.w700,
                      height: 0.11,
                      letterSpacing: 0.20,
                    ),
                  )
                ],
              ),
            ),
          ),
          SizeTransition(
            sizeFactor: _heightFactorAnimation,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  side: const BorderSide(width: 1, color: Color(0xFFF3F3F3)),
                  borderRadius: BorderRadius.circular(16),
                ),
                shadows: const [
                  BoxShadow(
                    color: Color(0x28606170),
                    blurRadius: 2,
                    offset: Offset(0, 0.50),
                    spreadRadius: 0,
                  ),
                  BoxShadow(
                    color: Color(0x1428293D),
                    blurRadius: 1,
                    offset: Offset(0, 0),
                    spreadRadius: 0,
                  )
                ],
              ),
              child: ClipRect(
                child: Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Details:',
                        style: TextStyle(
                          color: Color(0xFF282828),
                          fontSize: 14,
                          fontFamily: 'Epilogue',
                          fontWeight: FontWeight.w700,
                          height: 0.7,
                        ),
                      ),
                      Text(
                        widget.items,
                        style: const TextStyle(
                          color: Color(0xFF36414C),
                          fontSize: 14,
                          fontFamily: 'Epilogue',
                          fontWeight: FontWeight.w400,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Total Amount:',
                        style: TextStyle(
                          color: Color(0xFF282828),
                          fontSize: 14,
                          fontFamily: 'Epilogue',
                          fontWeight: FontWeight.w700,
                          height: 0.7,
                        ),
                      ),
                      Text(
                        '₹${widget.totalAmount.toStringAsFixed(2)}',
                        style: const TextStyle(
                          color: Color(0xFF36414C),
                          fontSize: 14,
                          fontFamily: 'Epilogue',
                          fontWeight: FontWeight.w400,
                          height: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
