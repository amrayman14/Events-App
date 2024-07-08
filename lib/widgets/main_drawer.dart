import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MainDrawer extends StatelessWidget {
   MainDrawer({super.key});


  @override
  Widget build(BuildContext context) {

    return Drawer(
      child: Column(
        children: [
          Center(
            child: CircleAvatar(

            ),
          )
        ],
      ),
    );
  }
}
