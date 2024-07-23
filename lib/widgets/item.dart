import 'package:amul/Utils/AppColors.dart';
import 'package:amul/Utils/enums.dart';
import 'package:amul/api/firebaseAPI.dart';
import 'package:amul/models/cart_item_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ListItem extends StatefulWidget {
  final String id;
  final List<CartItem> items;
  final FirebaseOrderStatus orderStatus;
  final RefundStatus? refundStatus;
  final DateTime timestamp;
  final String orderID;
  final double totalAmount;

  const ListItem({
    Key? key,
    required this.id,
    required this.items,
    required this.orderStatus,
    required this.refundStatus,
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
  late final AppColors2 appColors = Theme.of(context).extension<AppColors2>()!;

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

  double get totalAmount {
    double totalAmount = 0;
    for (var item in widget.items) {
      totalAmount += item.price * item.quantity;
    }
    return totalAmount;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Column(
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: _toggleExpanded,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
              decoration: ShapeDecoration(
                color: appColors.surfaceColor,
                // gradient: LinearGradient(
                //   begin: Alignment.topCenter,
                //   end: Alignment.bottomCenter,
                //   colors: [
                //     // Color(0xFF00084B).withAlpha(200),
                //     const Color(0xFF2E55C0).withAlpha(175),
                //     const Color(0xFF148BFA).withAlpha(175),
                //   ],
                // ),
                shape: RoundedRectangleBorder(
                  // side: const BorderSide(width: 1, color: Color(0xFFF3F3F3)),
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
              child: Column(
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
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.orderID,
                              style: TextStyle(
                                color: appColors.primaryText,
                                fontSize: 14,
                                fontFamily: 'Epilogue',
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              DateFormat('MMM d, y h:mm a')
                                  .format(widget.timestamp),
                              style: TextStyle(
                                color: appColors.primaryText,
                                fontSize: 12,
                                fontFamily: 'Epilogue',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                        TrailingWidget(
                            docID: widget.id,
                            orderID: widget.orderID,
                            orderStatus: widget.orderStatus,
                            refundStatus: widget.refundStatus)
                      ],
                    ),
                  ),

                  SizeTransition(
                    sizeFactor: _heightFactorAnimation,
                    child: SizeTransition(
                      sizeFactor: _heightFactorAnimation,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListView.builder(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: widget.items.length,
                            itemBuilder: (context, index) {
                              final item = widget.items[index];
                              return ListTile(
                                dense: true,
                                visualDensity: const VisualDensity(
                                    horizontal: 0, vertical: -4),
                                title: Text(
                                  '${item.name} (${item.quantity} ${item.quantity == 1 ? 'item' : 'items'})',
                                  style: TextStyle(
                                    color: appColors.secondaryText,
                                    fontSize: 14,
                                  ),
                                ),
                                trailing: Text(
                                  '₹${(item.price * item.quantity).toStringAsFixed(2)}',
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: appColors.secondaryText),
                                ),
                              );
                            },
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: Divider(
                              thickness: 1,
                            ),
                          ),
                          ListTile(
                            visualDensity: VisualDensity.compact,
                            dense: true,
                            title: const Text(
                              'Total',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                            trailing: Text(
                              '₹${totalAmount.toStringAsFixed(2)}',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                          )
                          // Text(
                          //   widget.items,
                          //   style: const TextStyle(
                          //     color: Color(0xFF36414C),
                          //     fontSize: 14,
                          //     fontFamily: 'Epilogue',
                          //     fontWeight: FontWeight.w400,
                          //     height: 1.2,
                          //   ),
                          // ),
                          // const SizedBox(height: 8),
                          // const Text(
                          //   'Total Amount:',
                          //   style: TextStyle(
                          //     color: Color(0xFF282828),
                          //     fontSize: 14,
                          //     fontFamily: 'Epilogue',
                          //     fontWeight: FontWeight.w700,
                          //     height: 0.7,
                          //   ),
                          // ),
                          // Text(
                          //   '₹${widget.totalAmount.toStringAsFixed(2)}',
                          //   style: const TextStyle(
                          //     color: Color(0xFF36414C),
                          //     fontSize: 14,
                          //     fontFamily: 'Epilogue',
                          //     fontWeight: FontWeight.w400,
                          //     height: 1.2,
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TrailingWidget extends StatelessWidget {
  const TrailingWidget(
      {super.key,
      required this.orderStatus,
      required this.refundStatus,
      required this.orderID,
      required this.docID});

  final FirebaseOrderStatus orderStatus;
  final RefundStatus? refundStatus;
  final String docID;
  final String orderID;

  @override
  Widget build(BuildContext context) {
    if (refundStatus != null) {
      if (refundStatus == RefundStatus.SUCCESS) {
        return Text(
          "REFUND ${refundStatus!.name}",
          style: const TextStyle(
            color: AppColors.green,
            fontSize: 14,
            fontFamily: 'Urbanist',
            fontWeight: FontWeight.w700,
            height: 0.11,
            letterSpacing: 0.20,
          ),
        );
      }

      return Wrap(
        direction: Axis.horizontal,
        alignment: WrapAlignment.center,
        runAlignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 0,
        runSpacing: 0,
        children: [
          IconButton(
            onPressed: () {
              Get.showOverlay(
                  asyncFunction: () =>
                      AmulxFirebaseAPI.checkAndUpdateRefundStatus(docID),
                  loadingWidget: const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.blue,
                    ),
                  ));
            },
            icon: const Icon(Icons.refresh),
          ),
          Text(
            "REFUND ${refundStatus!.name}",
            style: TextStyle(
              color: refundStatus == RefundStatus.CANCELLED
                  ? AppColors.red
                  : const Color(0xFFF2C14E),
              fontSize: 14,
              fontFamily: 'Urbanist',
              fontWeight: FontWeight.w700,
              height: 0.11,
              letterSpacing: 0.20,
            ),
          )
        ],
      );
    }

    if (orderStatus == FirebaseOrderStatus.NOT_PLACED) {
      return Wrap(
        direction: Axis.horizontal,
        alignment: WrapAlignment.center,
        runAlignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 0,
        runSpacing: 0,
        children: [
          IconButton(
            onPressed: () => Get.showOverlay(
                asyncFunction: () =>
                    AmulxFirebaseAPI.checkPaymentStatusAndPlaceOrder(
                        docID, orderID),
                loadingWidget: const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.blue,
                  ),
                )),
            icon: const Icon(Icons.refresh),
          ),
          Text(
            "Payment\nFailed".toUpperCase(),
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.red,
              fontSize: 14,
              fontFamily: 'Urbanist',
              fontWeight: FontWeight.w700,
              // height: 0.11,
              letterSpacing: 0.20,
            ),
          ),
        ],
      );
    }

    return Text(
      orderStatus.name.toUpperCase(),
      style: TextStyle(
        color: (orderStatus == FirebaseOrderStatus.DECLINED
            ? AppColors.red
            : const Color(0xFF18AE86)),
        fontSize: 14,
        fontFamily: 'Urbanist',
        fontWeight: FontWeight.w700,
        letterSpacing: 0.20,
      ),
    );
  }
}
