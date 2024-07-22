import 'package:amul/Utils/AppColors.dart';
import 'package:amul/widgets/amulX_appbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Faq extends StatefulWidget {
  const Faq({super.key});

  @override
  _FaqPageState createState() => _FaqPageState();
}

class _FaqPageState extends State<Faq> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: [
            const AmulXAppBar(
              title: "FAQs",
              showBackArrow: true,
              bottomRoundedCorners: true,
              bottomPadding: EdgeInsets.only(bottom: 45),
            ),
            Positioned.fill(
              top: 130,
              child: Align(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      StreamBuilder<QuerySnapshot>(
                        stream: _firestore.collection('QNA').snapshots(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.hasError) {
                            return const Text("Something went wrong");
                          }

                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Text("Loading");
                          }

                          return SingleChildScrollView(
                            child: Column(
                              children: snapshot.data!.docs
                                  .map((DocumentSnapshot document) {
                                Map<String, dynamic> data =
                                    document.data() as Map<String, dynamic>;
                                return FAQItem(
                                  question: data['question'],
                                  answer: data['answer'],
                                  isExpanded: false,
                                  onExpansionChanged: (value) {},
                                );
                              }).toList(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FAQItem extends StatefulWidget {
  final String question;
  final String answer;
  final bool isExpanded;
  final ValueChanged<bool> onExpansionChanged;

  const FAQItem({
    super.key,
    required this.question,
    required this.answer,
    required this.isExpanded,
    required this.onExpansionChanged,
  });

  @override
  _FAQItemState createState() => _FAQItemState();
}

class _FAQItemState extends State<FAQItem> {
  @override
  Widget build(BuildContext context) {
    late final AppColors2 appColors =
        Theme.of(context).extension<AppColors2>()!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Card(
            elevation: 8,
            clipBehavior: Clip.hardEdge,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            child: ExpansionTile(
              shape: const BeveledRectangleBorder(),
              backgroundColor: appColors.surfaceColor,
              collapsedBackgroundColor: appColors.surfaceColor,
              title: Text(widget.question),
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
                  decoration: ShapeDecoration(
                    color: appColors.surfaceColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0),
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
                  child: Text(widget.answer),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
