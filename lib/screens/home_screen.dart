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
  HomeScreen({super.key});
  final CollectionReference eventsDoc =
      FirebaseFirestore.instance.collection('events');
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeModeNotifier = ref.read(themeModeProvider.notifier);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        actions: [
          IconButton(
            icon: Icon(ref.watch(themeModeProvider) == ThemeMode.light
                ? Icons.dark_mode
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
      drawer: const MainDrawer(),
      body: StreamBuilder<QuerySnapshot>(
        stream: eventsDoc.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
                child: Text('No events found.. Try creating some'));
          }

          final events = snapshot.data!.docs
              .map((doc) => Event.fromDocument(doc))
              .toList();
          return ListView.builder(
            itemCount: events.length,
            itemBuilder: (context, index) {
              final event = events[index];
              return Dismissible(
                key: Key(event.id),
                direction: DismissDirection.endToStart,
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: const Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                ),
                onDismissed: (direction) async {
                  if (event.creatorId ==
                      FirebaseAuth.instance.currentUser!.uid) {
                    await eventsDoc.doc(event.id).delete();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${event.type} Deleted'),
                      ),
                    );
                  }
                },
                child: InkWell(
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
                ),
              );
            },
          );
        },
      ),
    );
  }
}
