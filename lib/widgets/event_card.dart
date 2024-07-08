import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:events_app/models/event_model.dart';

import 'package:flutter/material.dart';

class EventCard extends StatefulWidget {
  final Event event;

  const EventCard({super.key, required this.event});

  @override
  _EventCardState createState() => _EventCardState();
}

class _EventCardState extends State<EventCard> {
  bool isChecked = false;
  void _toggleInterest() async {
    if(!isChecked){
      setState(() {
        isChecked = true;
        widget.event.interestedCount += 1;
      });
      await FirebaseFirestore.instance
          .collection('events')
          .doc(widget.event.id)
          .update({
        'interestedCount': widget.event.interestedCount,
      });
    }
    else{
      setState(() {
        isChecked = false;
        widget.event.interestedCount -= 1;
      });
      await FirebaseFirestore.instance
          .collection('events')
          .doc(widget.event.id)
          .update({
        'interestedCount': widget.event.interestedCount,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.event.type,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(widget.event.date),
            const SizedBox(height: 8),
            Text(widget.event.location),
            const SizedBox(height: 8),
            Text(widget.event.description),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Interested: ${widget.event.interestedCount}'),
                IconButton(
                  icon: !isChecked
                      ? const Icon(Icons.favorite_border)
                      : const Icon(
                          Icons.favorite,
                          color: Colors.red,
                        ),
                  onPressed: _toggleInterest,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
