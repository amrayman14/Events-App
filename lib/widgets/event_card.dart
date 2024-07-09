import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:events_app/models/event_model.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class EventCard extends StatefulWidget {
  final Event event;

  const EventCard({super.key, required this.event});

  @override
  _EventCardState createState() => _EventCardState();
}

class _EventCardState extends State<EventCard> {
  final _key = GlobalKey();
  bool isChecked = false;
  void _toggleInterest() async {
    if (!isChecked) {
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
    } else {
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
            Text(
              'Type : ${widget.event.type}',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Date : ${widget.event.date}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,

              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Location : ${widget.event.location}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Details : ${widget.event.description}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'Interested : ${widget.event.interestedCount}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                IconButton(
                  icon: !isChecked
                      ? const Icon(Icons.favorite_border)
                      : const Icon(
                          Icons.favorite,
                          color: Colors.red,
                        ),
                  onPressed: _toggleInterest,
                ),
                const SizedBox(
                  width: 8,
                ),
                IconButton(
                  icon: const Icon(Icons.share),
                  onPressed: () {
                    Share.share('Check out this event: ${widget.event.type}');
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
