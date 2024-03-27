import 'package:flutter/material.dart';

class Event {
  final String title;
  final DateTime timeFrom;
  final DateTime timeto;
  final Color bgColor;
  final bool isAllDay;
  final bool isWeekly;
  final bool isMonthly;
  final String? recurrenceRule;

  Event({
    required this.title,
    required this.timeFrom,
    required this.timeto,
    this.bgColor = Colors.lightGreenAccent,
    this.isAllDay = false,
    this.isWeekly = false,
    this.isMonthly = false,
    this.recurrenceRule,
  });

  // Method to check if the event is recurring
  bool isRecurring() => isWeekly || isMonthly;

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'timeFrom': timeFrom.toIso8601String(),
      'timeto': timeto.toIso8601String(),
      'bgColor': bgColor.value, // Store color value as int
      'isAllDay': isAllDay,
      'isWeekly': isWeekly,
      'isMonthly': isMonthly,
      'recurrenceRule': recurrenceRule,
    };
  }

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      title: json['title'],
      timeFrom: DateTime.parse(json['timeFrom']),
      timeto: DateTime.parse(json['timeto']),
      bgColor: Color(json['bgColor']),
      isAllDay: json['isAllDay'],
      isWeekly: json['isWeekly'],
      isMonthly: json['isMonthly'],
      recurrenceRule: json['recurrenceRule'],
    );
  }
}
