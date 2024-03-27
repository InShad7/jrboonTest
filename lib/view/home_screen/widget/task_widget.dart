import 'package:flutter/material.dart';
import 'package:jrboon/controller/event_provider.dart';
import 'package:jrboon/model/event_data_source.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:syncfusion_flutter_core/theme.dart';

import '../../../model/event_model.dart';
import '../../event_screen/event_screen.dart';

class TaskWidget extends StatefulWidget {
  const TaskWidget({Key? key});

  @override
  State<TaskWidget> createState() => _TaskWidgetState();
}

class _TaskWidgetState extends State<TaskWidget> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<EventProvider>(context);
    final selectedEvents = provider.eventOfSelectedDate;

    if (selectedEvents.isEmpty) {
      return const Center(
        child: Text(
          'No events found',
          style: TextStyle(
            fontSize: 18,
            color: Colors.white,
          ),
        ),
      );
    }

    return SfCalendarTheme(
      data: const SfCalendarThemeData(),
      child: SfCalendar(
        view: CalendarView.day,
        dataSource: EventDataSource(provider.events),
        initialDisplayDate: provider.selectedDate,
        appointmentTextStyle: const TextStyle(
          color: Colors.black,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        headerHeight: 0,
        selectionDecoration: BoxDecoration(
          color: Colors.blue.withOpacity(0.3),
        ),
        onTap: (details) {
          if (details.appointments == null) return;
          final event = details.appointments!.first;

          Event? selectedEvent;

          if (event.recurrenceRule != null) {
            // If appointment has a recurrence rule, create an Event object for recurrence
            String recurrenceRule = event.recurrenceRule!;
            bool isWeekly = recurrenceRule.contains('FREQ=WEEKLY');
            bool isMonthly = recurrenceRule.contains('FREQ=MONTHLY');

            // Example: Check if the recurrence rule contains 'INTERVAL=1' for monthly recurrence
            bool isMonthlyRecurrence =
                isMonthly && recurrenceRule.contains('INTERVAL=1');

            selectedEvent = Event(
              title: event.subject,
              timeFrom: event.startTime,
              timeto: event.endTime,
              bgColor: event.color,
              isAllDay: event.isAllDay,
              recurrenceRule: event.recurrenceRule,
              isWeekly: isWeekly,
              isMonthly: isMonthly || isMonthlyRecurrence,
            );
          } else {
            // If appointment is not recurring, find the corresponding Event in the list
            selectedEvent = provider.events.firstWhere((e) =>
                e.title == event.title &&
                e.timeFrom == event.timeFrom &&
                e.timeto == event.timeto &&
                e.bgColor == event.bgColor &&
                e.isAllDay == event.isAllDay);
          }

          if (selectedEvent != null) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EventScreen(
                  event: selectedEvent!,
                ),
              ),
            );
          } else {
            // Handle the scenario when no corresponding Event is found
            // For example, show a toast or a snackbar
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content:
                    Text('No corresponding event found for this appointment.'),
              ),
            );
          }
        },
      ),
    );
  }

  Widget appointemntBuilder(
      BuildContext context, CalendarAppointmentDetails details) {
    final event = details.appointments.first as Event;

    return Container(
      width: details.bounds.width,
      height: details.bounds.height,
      decoration: BoxDecoration(
        color: event.bgColor.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Text(
          event.title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
