import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../provider/theme_provider.dart';
import '../screens/create_event_screen.dart';

class MainDrawer extends ConsumerStatefulWidget {
  const MainDrawer({super.key});

  @override
  ConsumerState<MainDrawer> createState() => _MainDrawerState();
}

class _MainDrawerState extends ConsumerState<MainDrawer> {
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
      DocumentSnapshot doc =
          await _firestore.collection('user').doc(_firebaseAuth).get();
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            height: 200,
            padding: const EdgeInsets.all(24),
            color: ref.watch(themeModeProvider) == ThemeMode.light ?
            Colors.grey : Colors.purple,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage(imageUrl),
                ),
                const SizedBox(
                  height: 8,
                ),
                const Text(
                  'My Account',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 19,
                  ),
                ),
                const SizedBox(
                  height: 6,
                ),
                Text(
                  emailAddress,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 12,
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (ctx) => const CreateEventScreen(
                      isUpdating: false,
                    ),
                  ),
                );
              },
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Create New Event  ',),
                  Icon(Icons.add),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: ElevatedButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
              },
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Sign Out  ',),
                  Icon(Icons.logout),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
