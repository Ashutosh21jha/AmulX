// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:flutter/material.dart';

class EditProfile extends StatelessWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Edit Profile',
          style: TextStyle(
            color: Color.fromARGB(255, 0, 0, 0),
            fontSize: 18,
            fontFamily: 'Epilogue',
            fontWeight: FontWeight.w700,
            height: 0.06,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        leading: IconButton(
          color: const Color.fromARGB(255, 0, 0, 0),
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.all(30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Personal Information',
                  style: TextStyle(
                    color: Color(0xFF57585B),
                    fontSize: 14,
                    fontFamily: 'Epilogue',
                    fontWeight: FontWeight.w500,
                    height: 0.08,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Full Name',
                  style: TextStyle(
                    color: Color(0xFF141414),
                    fontSize: 16,
                    fontFamily: 'Epilogue',
                    fontWeight: FontWeight.w500,
                    height: 0.06,
                  ),
                ),
                SizedBox(height: 8),
                TextField(
                  decoration: InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        width: 1,
                        color: Color(0xFFD1D2D3),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        width: 1,
                        color: Color(0xFFD1D2D3),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        width: 1,
                        color: Colors.blue,
                      ),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  style: TextStyle(
                    color: Color(0xFF141414),
                    fontSize: 16,
                    fontFamily: 'Epilogue',
                    fontWeight: FontWeight.w500,
                    height: 0.06,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Student ID',
                  style: TextStyle(
                    color: Color(0xFF141414),
                    fontSize: 16,
                    fontFamily: 'Epilogue',
                    fontWeight: FontWeight.w500,
                    height: 0.06,
                  ),
                ),
                SizedBox(height: 8),
                TextField(
                  decoration: InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        width: 1,
                        color: Color(0xFFD1D2D3),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        width: 1,
                        color: Color(0xFFD1D2D3),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        width: 1,
                        color: Colors.blue,
                      ),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  style: TextStyle(
                    color: Color(0xFF141414),
                    fontSize: 16,
                    fontFamily: 'Epilogue',
                    fontWeight: FontWeight.w500,
                    height: 0.06,
                  ),
                ),
                SizedBox(height: 30),
                Text(
                  'Date of Birth',
                  style: TextStyle(
                    color: Color(0xFF141414),
                    fontSize: 16,
                    fontFamily: 'Epilogue',
                    fontWeight: FontWeight.w500,
                    height: 0.06,
                  ),
                ),
                SizedBox(height: 8),
                TextField(
                  decoration: InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        width: 1,
                        color: Color(0xFFD1D2D3),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        width: 1,
                        color: Color(0xFFD1D2D3),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        width: 1,
                        color: Colors.blue,
                      ),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  style: TextStyle(
                    color: Color(0xFF141414),
                    fontSize: 16,
                    fontFamily: 'Epilogue',
                    fontWeight: FontWeight.w500,
                    height: 0.06,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 30,
            child: Container(
              width: double.infinity,
              height: 48,
              margin: EdgeInsets.symmetric(horizontal: 30),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  'Save',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontFamily: 'Epilogue',
                    fontWeight: FontWeight.w500,
                    height: 0.06,
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
