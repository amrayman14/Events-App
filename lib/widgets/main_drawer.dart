import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MainDrawer extends StatefulWidget {
   MainDrawer({super.key});

  @override
  State<MainDrawer> createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {

   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
   final _firebaseAuth = FirebaseAuth.instance.currentUser?.uid;
   String imageUrl = '';
   String emailAddress = '';
   @override
   void initState() {
     super.initState();
     _getField();
   }

   Future<void> _getField() async {
     try {
       DocumentSnapshot doc = await _firestore.collection('user').doc(_firebaseAuth).get();
       setState(() {
         imageUrl = doc.get('imageUrl');
         emailAddress = doc.get('email');
       });
     } catch (e) {
       print('Error getting document: $e');
     }
   }

  @override
  Widget build(BuildContext context) {

    return Drawer(
      backgroundColor: Colors.deepPurple[200],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
              radius: 30,
              backgroundImage: NetworkImage(imageUrl),
          ),
          const SizedBox(height: 8,),
          Text(emailAddress),
        ],
      ),
    );
  }
}
