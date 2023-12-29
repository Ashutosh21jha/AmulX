import 'package:flutter/material.dart';
import 'package:im_stepper/stepper.dart';
import 'package:intl/intl.dart';

class TrackingPage extends StatelessWidget {
  const TrackingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DateTime currentDate = DateTime.now();
    String formattedDate = DateFormat('EEE, d MMMM').format(currentDate);

    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Padding(
            padding: EdgeInsets.all(1.0),
            child: Text(
              'Track Order',
              style: TextStyle(color: Colors.black),
            ),
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            size: 32,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16, top: 16),
            child: Text(
              formattedDate,
              style: const TextStyle(color: Colors.indigo, fontSize: 20),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 16, top: 10),
            child: Text(
              "Order ID - ",
              style: TextStyle(color: Colors.indigo, fontSize: 20),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 16, top: 30),
            child: Text(
              "Orders",
              style: TextStyle(color: Colors.indigo, fontSize: 22),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            height: MediaQuery.of(context).size.height / 2,
            width: MediaQuery.of(context).size.width / 6,
            child: IconStepper(
              direction: Axis.vertical,
              enableNextPreviousButtons: false,
              activeStepBorderColor: Colors.white,
              activeStepBorderWidth: 0.0,
              lineColor: Colors.redAccent,
              stepColor: Colors.green,
              lineLength: 70.0,
              lineDotRadius: 2.0,
              stepRadius: 18.0,
              icons: const [
                Icon(
                  Icons.radio_button_checked,
                  color: Colors.green,
                ),
                Icon(
                  Icons.check_sharp,
                  color: Colors.white,
                ),
                Icon(
                  Icons.check,
                  color: Colors.white,
                ),
                Icon(
                  Icons.check,
                  color: Colors.white,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
