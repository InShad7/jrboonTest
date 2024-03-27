import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import 'event_model.dart';

class EventDataSource extends CalendarDataSource {
  EventDataSource(List<Event> appointments) {
    this.appointments = appointments;
  }

  Event getEvent(int index) => appointments![index] as Event;

  @override
  DateTime getStartTime(int index) => getEvent(index).timeFrom;

  @override
  DateTime getEndTime(int index) => getEvent(index).timeto;

  @override
  String getSubject(int index) => getEvent(index).title;

  @override
  Color getColor(int index) => getEvent(index).bgColor;

  @override
  bool isAllDay(int index) => getEvent(index).isAllDay;

  @override
  String? getRecurrenceRule(int index) {
    final event = getEvent(index);
    if (event.isRecurring()) {
      if (event.isWeekly) {
        // Get the day of the week abbreviation from the timeFrom property
        final dayOfWeek = event.timeFrom.weekday;
        final dayAbbreviation = _getDayAbbreviation(dayOfWeek);

        // Return recurrence rule for weekly events with the correct day of the week
        return 'FREQ=WEEKLY;BYDAY=$dayAbbreviation';
      } else if (event.isMonthly) {
        // Get the day of the month from the timeFrom property
        final dayOfMonth = event.timeFrom.day;

        // Return recurrence rule for monthly events with the correct day of the month
        return 'FREQ=MONTHLY;BYMONTHDAY=$dayOfMonth';
      }
    }
    return event.recurrenceRule; // Return the recurrence rule from the event
  }

// Helper method to get the day of the week abbreviation
  String _getDayAbbreviation(int dayOfWeek) {
    print(dayOfWeek);
    switch (dayOfWeek) {
      case DateTime.monday:
        return 'MO';
      case DateTime.tuesday:
        return 'TU';
      case DateTime.wednesday:
        return 'WE';
      case DateTime.thursday:
        return 'TH';
      case DateTime.friday:
        return 'FR';
      case DateTime.saturday:
        return 'SA';
      case DateTime.sunday:
        return 'SU';
      default:
        return '';
    }
  }
}
