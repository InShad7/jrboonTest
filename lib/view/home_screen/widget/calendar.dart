import 'package:flutter/material.dart';
import 'package:jrboon/controller/event_provider.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../../../model/event_data_source.dart';
import 'task_widget.dart';

class CalendarWidget extends StatelessWidget {
  const CalendarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<EventProvider>(context);
    final events = provider.events;
    return SfCalendar(
      view: CalendarView.month,
      dataSource: EventDataSource(events),
      // monthViewSettings: const MonthViewSettings(
      //   appointmentDisplayMode: MonthAppointmentDisplayMode.indicator,
      //   showAgenda: true,
      // ),
      initialSelectedDate: DateTime.now(),
      cellBorderColor: Colors.transparent,
      onLongPress: (details) {
        provider.setDate(details.date!);
        showModalBottomSheet(
          context: context,
          builder: (context) => const TaskWidget(),
        );
      },
      onTap: (details) {
        provider.setDate(details.date!);
      },
    );
  }
}
