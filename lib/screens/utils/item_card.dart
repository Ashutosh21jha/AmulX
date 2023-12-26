import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
class ItemCard extends StatefulWidget {
  String name;
  String rs;

  ItemCard({super.key,required this.name,required this.rs});


  @override
  State<ItemCard> createState() => _ItemCardState();
}

class _ItemCardState extends State<ItemCard> {
  FirebaseAuth _auth=FirebaseAuth.instance;
  bool added=false;
  int count=0;


  @override
  void initState(){
    super.initState();
    fetch();
  }
  void fetch(){
    try{
      FirebaseFirestore.instance.collection('User').doc(_auth.currentUser!.email).collection('cart').doc('Coke').get().then((value) {
        if(value['name']=='coke'){
          setState(() {
            added=true;
          });
          setState(() {
            count=value['count'];
          });
        }
      });
    }catch(e){
      print('Error');
    }

  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        width: double.infinity,
        child: Row(
          children: [
            Image.network("www.google.com"),
            Spacer(),
            // if(added)
            //   MinusplusButton(
            //     plusontap{
            //       firebabe()++;
            //       count++;
            //   }
            //   ),
            // if(added==false)
            //   Addbutton(),
          ],
        ),
      ),
    );
  }
}
