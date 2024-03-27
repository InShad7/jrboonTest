import 'package:flutter/material.dart';
import 'package:jrboon/controller/event_provider.dart';
import 'package:jrboon/view/home_screen/widget/add_event_screen.dart';
import 'package:jrboon/view/utils/utils.dart';
import 'package:provider/provider.dart';

import '../../model/event_model.dart';

class EventScreen extends StatelessWidget {
  const EventScreen({super.key, required this.event});
  final Event event;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const CloseButton(),
        actions: buildViewActionButton(context, event),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            event.title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          buildDateTime(event),
        ],
      ),
    );
  }

  Widget buildDateTime(Event event) {
    return Column(
      children: [
        buildDate(event.isAllDay ? 'All day' : 'From', event.timeFrom),
        const SizedBox(height: 10),
        if (!event.isAllDay) buildDate('To', event.timeto)
      ],
    );
  }

  Widget buildDate(String title, DateTime date) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          "${Utils.toDate(date)}, ${Utils.toTime(date)} ",
          style: const TextStyle(
            fontSize: 18,
            color: Colors.white,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  List<Widget> buildViewActionButton(BuildContext context, Event event) {
    return [
      IconButton(
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => AddEventScreen(
                event: event,
              ),
            ),
          );
        },
        icon: const Icon(Icons.edit),
      ),
      IconButton(
        onPressed: () {
          final provider = Provider.of<EventProvider>(context, listen: false);
          provider.deleteEvent(event);
          Navigator.pop(context);
        },
        icon: const Icon(Icons.delete_outline),
      ),
    ];
  }
}
