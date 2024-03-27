import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/event_model.dart';

class EventProvider extends ChangeNotifier {
  EventProvider() {
    loadEventsFromPrefs();
  }
  final List<Event> _events = [];

  List<Event> get events => _events;

  DateTime _selectedDate = DateTime.now();

  DateTime get selectedDate => _selectedDate;

  void setDate(DateTime date) => _selectedDate = date;

  List<Event> get eventOfSelectedDate => _events;

  void addEvent(Event event) {
    _events.add(event);
    saveEventsToPrefs();
    notifyListeners();
  }

  void editEvent(Event newEvent, Event oldEvent) {
    if (oldEvent.recurrenceRule != null) {
      // Handle editing recurring events
      for (int i = 0; i < _events.length; i++) {
        if (_events[i].title == oldEvent.title) {
          _events[i] = newEvent;
        }
      }
      notifyListeners();
      return;
    }

    final index = _events.indexWhere((event) =>
        event.title == oldEvent.title &&
        event.timeFrom == oldEvent.timeFrom &&
        event.timeto == oldEvent.timeto &&
        event.bgColor == oldEvent.bgColor &&
        event.isAllDay == oldEvent.isAllDay);

    if (index != -1) {
      _events[index] = newEvent;
      notifyListeners();
    } else {
      print('Old event not found.');
    }
    saveEventsToPrefs();
  }

  void deleteEvent(Event event) {
    if (event.recurrenceRule != null) {
      // Handle deleting recurring events

      for (int i = 0; i < _events.length; i++) {
        if (_events[i].title == event.title) {
          _events.removeAt(i);
        }
      }
      // for (int i = _events.length - 1; i >= 0; i--) {
      //   if (event.recurrenceRule != null) {
      //     _events.removeAt(i);
      //   }
      // }
      notifyListeners();
    } else {
      // Handle deleting non-recurring events
      if (_events.contains(event)) {
        _events.remove(event);
        notifyListeners();
      } else {
        print('Event not found.');
      }
    }
    saveEventsToPrefs();
  }

  List<Event> getEventsForSelectedDate(DateTime date) {
    return _events.where((event) {
      if (event.isAllDay) {
        // Filter events for the selected date when 'All Day' is true
        return event.timeFrom.year == date.year &&
            event.timeFrom.month == date.month &&
            event.timeFrom.day == date.day;
      } else {
        return false;
      }
    }).toList();
  }

  Future<void> saveEventsToPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> eventsJson =
        _events.map((event) => jsonEncode(event.toJson())).toList();
    await prefs.setStringList('events', eventsJson);
  }

  Future<void> loadEventsFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? eventsJson = prefs.getStringList('events');
    print(eventsJson);
    if (eventsJson != null) {
      _events.clear();
      _events.addAll(
          eventsJson.map((json) => Event.fromJson(jsonDecode(json))).toList());
      notifyListeners();
    }
  }
}
