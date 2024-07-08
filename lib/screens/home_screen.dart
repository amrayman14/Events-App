import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:events_app/screens/create_event_screen.dart';
import 'package:events_app/widgets/main_drawer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:events_app/models/event_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:events_app/provider/theme_provider.dart';
import '../widgets/event_card.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeModeNotifier = ref.read(themeModeProvider.notifier);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        actions: [
          IconButton(
            icon: Icon(ref.watch(themeModeProvider) == ThemeMode.light ?
            Icons.dark_mode
                : Icons.light_mode),
            onPressed: () {
              themeModeNotifier.toggleTheme();
            },
          ),

          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) => const CreateEventScreen(
                    isUpdating: false,
                  ),
                ),
              );
            },
            icon: const Icon(Icons.add),
          ),
          IconButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
            },
            icon: Icon(
              Icons.exit_to_app,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      ),
      drawer: MainDrawer(),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('events').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final events = snapshot.data!.docs
              .map((doc) => Event.fromDocument(doc))
              .toList();
          return ListView.builder(
            itemCount: events.length,
            itemBuilder: (context, index) {
              final event = events[index];
              return InkWell(
                onTap: () {
                  if (event.creatorId ==
                      FirebaseAuth.instance.currentUser!.uid) {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (ctx) => CreateEventScreen(
                          isUpdating: true,
                          event: event,
                        ),
                      ),
                    );
                  }
                },
                child: EventCard(event: event),
              );
            },
          );
        },
      ),
    );
  }
}
