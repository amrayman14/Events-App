import 'package:events_app/models/event_model.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CreateEventScreen extends StatefulWidget {
  const CreateEventScreen({super.key, required this.isUpdating, this.event});
  final bool isUpdating;
  final Event? event;
  @override
  CreateEventScreenState createState() => CreateEventScreenState();
}

class CreateEventScreenState extends State<CreateEventScreen> {
  final _formKey = GlobalKey<FormState>();

  final String _userId = FirebaseAuth.instance.currentUser!.uid;
  String _eventType = '';
  String _eventDate = '';
  String _eventLocation = '';
  String _eventDescription = '';


  void _saveEvent() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      await FirebaseFirestore.instance.collection('events').add({
        'userId' : _userId,
        'type': _eventType,
        'date': _eventDate,
        'location': _eventLocation,
        'description': _eventDescription,
        'interestedCount': 0,
      });
      Navigator.of(context).pop();
    }
  }
  void _updateEvent() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      await FirebaseFirestore.instance
          .collection('events')
          .doc(widget.event?.id)
          .update({
        'userId' : _userId,
        'type': _eventType,
        'date': _eventDate,
        'location': _eventLocation,
        'description': _eventDescription,
      });

      Navigator.of(context).pop();
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Event'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Event Type'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter event type';
                  }
                  return null;
                },
                onSaved: (value) {
                  _eventType = value!;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Event Date'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter event date';
                  }
                  return null;
                },
                onSaved: (value) {
                  _eventDate = value!;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Event Location'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter event location';
                  }
                  return null;
                },
                onSaved: (value) {
                  _eventLocation = value!;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Event Description'),
                maxLines: 3,
                onSaved: (value) {
                  _eventDescription = value!;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: widget.isUpdating ? _updateEvent : _saveEvent,
                child:  Text(widget.isUpdating ? 'Update' : 'Create Event'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
