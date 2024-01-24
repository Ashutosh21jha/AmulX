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
                      bottomLeft: Radius.elliptical(40,20),
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
                          answer: 'Amulx is an online order app for the students of NSUT',
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
                          answer: 'Amulx is available on play store for android users and IOS store for iphone users',
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
                          question: 'How do I create an account on the Amulx app?',
                          answer: ' You can create an account on the Amulx app by downloading it from the app store, opening it, and following the prompts to sign up.',
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
                          question: 'Is the Amulx app secure?',
                          answer: 'Yes, the Amulx app uses industry-standard security measures to protect your personal and payment information.',
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
                          question: 'How do I pay for my order on the Amulx app?',
                          answer: 'You can pay for your order on the Amulx app using phone pe, gpay, paytm, or COD.',
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
                          question: 'How do I know if my order is ready for pickup?',
                          answer: 'You will receive a notification on the Amulx app when your order is ready for pickup.',
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
                          question: 'Can I use the Amulx app to order food for delivery?',
                          answer: 'No, the Amulx app is currently only available for pickup orders.',
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
                          question: 'What if I have a problem with my order on the Amulx app?',
                          answer: 'If you have a problem with your order on the Amulx app, you can contact customer support through the app or by email.',
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
                          question: 'How do I update my account information on the Amulx app?',
                          answer: ' You can update your account information on the Amulx app by going to the "Profile" section and making the necessary changes.',
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
                          question: 'How do I get a refund for a declined order? ',
                          answer: '  If your order is declined by the owner, you will receive a code to your app.'
                              ' You will need to provide this code to the owner to receive a refund.',
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Card(
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            child: ExpansionTile(
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