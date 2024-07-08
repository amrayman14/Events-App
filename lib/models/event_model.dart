import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


class Event {
  final String id;
  final String creatorId;
  final String type;
  final String date;
  final String location;
  final String description;
  int interestedCount;

  Event({
    required this.id,
    required this.creatorId,
    required this.type,
    required this.date,
    required this.location,
    required this.description,
    required this.interestedCount,
  });

  factory Event.fromDocument(DocumentSnapshot doc) {
    return Event(
      id: doc.id,
      creatorId: doc['userId'],
      type: doc['type'],
      date: doc['date'],
      location: doc['location'],
      description: doc['description'],
      interestedCount: doc['interestedCount'],
    );
  }
}