import 'package:flutter/material.dart';

class Faq extends StatefulWidget {
  @override
  _FaqPageState createState() => _FaqPageState();
}

class _FaqPageState extends State<Faq> {
  bool _isExpanded1 = true;
  bool _isExpanded2 = true;

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
                /* borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(80),
                  bottomRight: Radius.circular(80),
                ),*/
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
                /* borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(80),
                  bottomRight: Radius.circular(80),
                ),*/
              ),
              child: Center(
                child: const Text(
                  'FAQs',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
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
                  height: 50,
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
                        FAQItem(
                          question: 'What is Amulx?',
                          answer:
                              'Amulx is an online order app for the students of NSUT',
                          isExpanded: _isExpanded1,
                          onExpansionChanged: (value) {
                            setState(() {
                              _isExpanded1 = value;
                            });
                          },
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        FAQItem(
                          question: 'How can I download Amulx?',
                          answer:
                              'Amulx is available on play store for android users and IOS store for iphone users',
                          isExpanded: _isExpanded2,
                          onExpansionChanged: (value) {
                            setState(() {
                              _isExpanded2 = value;
                            });
                          },
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        FAQItem(
                          question: 'How can I download Amulx?',
                          answer:
                              'Amulx is available on play store for android users and IOS store for iphone users',
                          isExpanded: _isExpanded2,
                          onExpansionChanged: (value) {
                            setState(() {
                              _isExpanded2 = value;
                            });
                          },
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        FAQItem(
                          question: 'How can I download Amulx?',
                          answer:
                              'Amulx is available on play store for android users and IOS store for iphone users',
                          isExpanded: _isExpanded2,
                          onExpansionChanged: (value) {
                            setState(() {
                              _isExpanded2 = value;
                            });
                          },
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        FAQItem(
                          question: 'How can I download Amulx?',
                          answer:
                              'Amulx is available on play store for android users and IOS store for iphone users',
                          isExpanded: _isExpanded2,
                          onExpansionChanged: (value) {
                            setState(() {
                              _isExpanded2 = value;
                            });
                          },
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        FAQItem(
                          question: 'How can I download Amulx?',
                          answer:
                              'Amulx is available on play store for android users and IOS store for iphone users',
                          isExpanded: _isExpanded2,
                          onExpansionChanged: (value) {
                            setState(() {
                              _isExpanded2 = value;
                            });
                          },
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        FAQItem(
                          question: 'How can I download Amulx?',
                          answer:
                              'Amulx is available on play store for android users and IOS store for iphone users',
                          isExpanded: _isExpanded2,
                          onExpansionChanged: (value) {
                            setState(() {
                              _isExpanded2 = value;
                            });
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
    return Padding(
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
    );
  }
}
