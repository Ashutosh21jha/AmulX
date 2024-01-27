import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Faq extends StatefulWidget {
  @override
  _FaqPageState createState() => _FaqPageState();
}

class _FaqPageState extends State<Faq> {
  bool _isExpanded1 = true;
  bool _isExpanded2 = true;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 60,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Color(0xFF00084B),
                    Color(0xFF2E55C0),
                    Color(0xFF148BFA),
                  ],
                ),
              ),
            ),
            Container(
              height: 75,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Color(0xFF00084B),
                    Color(0xFF2E55C0),
                    Color(0xFF148BFA),
                  ],
                ),
              ),
              child: Center(
                child: const Text(
                  'FAQs',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontFamily: 'Epilogue',
                    fontWeight: FontWeight.w700,
                    height: 0.06,
                  ),
                ),
              ),
            ),
            Stack(
              children: [
                Container(
                  height: 45,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        Color(0xFF00084B),
                        Color(0xFF2E55C0),
                        Color(0xFF148BFA),
                      ],
                    ),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.elliptical(40, 20),
                      bottomRight: Radius.elliptical(40, 20),
                    ),
                  ),
                ),
                Align(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        StreamBuilder<QuerySnapshot>(
                          stream: _firestore.collection('QNA').snapshots(),
                          builder: (BuildContext context,
                              AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (snapshot.hasError) {
                              return Text("Something went wrong");
                            }

                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Text("Loading");
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
              ],
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

  FAQItem({
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
              shape: BeveledRectangleBorder(),
              title: Text(widget.question),
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 18, vertical: 18),
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
