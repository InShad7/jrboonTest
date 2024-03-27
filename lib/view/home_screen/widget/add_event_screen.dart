import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../../../controller/event_provider.dart';
import '../../../model/event_model.dart';
import '../../utils/utils.dart';
import 'title_field.dart';

class AddEventScreen extends StatefulWidget {
  const AddEventScreen({super.key, this.event});
  final Event? event;

  @override
  State<AddEventScreen> createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController titleController = TextEditingController();
  late DateTime fromDate;
  late DateTime toDate;

  bool allDaySelected = false;
  bool weeklySelected = false;
  bool monthlySelected = false;

  @override
  void initState() {
    super.initState();
    if (widget.event == null) {
      fromDate = DateTime.now();
      toDate = DateTime.now().add(const Duration(hours: 2));
    } else {
      final event = widget.event;
      titleController.text = event!.title;
      fromDate = event.timeFrom;
      toDate = event.timeto;
      allDaySelected = event.isAllDay;
      monthlySelected = event.isMonthly;
      weeklySelected = event.isWeekly;
      print(event.isMonthly);
    }
  }

  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const CloseButton(),
        actions: [
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
            ),
            onPressed: saveForm,
            icon: const Icon(Icons.done),
            label: const Text('Save'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              BuildTitleField(titleController: titleController),
              const SizedBox(height: 10),
              buildDateTimePicker(),
              repeatSelectionWidget(
                'All Day',
                (bool newValue) {
                  setState(() {
                    allDaySelected = newValue;
                    if (newValue) {
                      weeklySelected = false;
                      monthlySelected = false;
                    }
                  });
                },
                allDaySelected,
              ),
              repeatSelectionWidget(
                'Weekly',
                (bool newValue) {
                  setState(() {
                    weeklySelected = newValue;
                    if (newValue) {
                      allDaySelected = false;
                      monthlySelected = false;
                    }
                  });
                },
                weeklySelected,
              ),
              repeatSelectionWidget(
                'Monthly',
                (bool newValue) {
                  setState(() {
                    monthlySelected = newValue;
                    if (newValue) {
                      allDaySelected = false;
                      weeklySelected = false;
                    }
                  });
                },
                monthlySelected,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Row repeatSelectionWidget(
      String title, void Function(bool)? onChanged, bool value) {
    return Row(
      children: [
        Checkbox(
          value: value,
          onChanged:
              onChanged != null ? (val) => onChanged(val ?? false) : null,
        ),
        Text(title),
      ],
    );
  }

  Widget buildDateTimePicker() {
    return Column(
      children: [
        buildFrom(),
        buildTo(),
      ],
    );
  }

  Widget buildFrom() {
    return buildHeader(
      header: 'From',
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: dropDownField(
              text: Utils.toDate(fromDate),
              onClicked: () => pickFromDateTime(pickDate: true),
            ),
          ),
          Expanded(
            child: dropDownField(
              text: Utils.toTime(fromDate),
              onClicked: () => pickFromDateTime(pickDate: false),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTo() {
    return buildHeader(
      header: 'To',
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: dropDownField(
              text: Utils.toDate(toDate),
              onClicked: () => pickToDateTime(pickDate: true),
            ),
          ),
          Expanded(
            child: dropDownField(
              text: Utils.toTime(toDate),
              onClicked: () => pickToDateTime(pickDate: false),
            ),
          ),
        ],
      ),
    );
  }

  Widget dropDownField({
    required String text,
    required VoidCallback onClicked,
  }) {
    return ListTile(
      title: Text(text),
      onTap: onClicked,
    );
  }

  Widget buildHeader({required String header, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          header,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        child,
      ],
    );
  }

  Future pickFromDateTime({required bool pickDate}) async {
    final date = await pickDateTime(fromDate, pickDate: pickDate);

    if (date == null) return null;

    if (date.isAfter(toDate)) {
      toDate = DateTime(
        date.year,
        date.month,
        date.day,
        toDate.hour,
        toDate.minute,
      );
    }
    setState(() {
      fromDate = date;
    });
  }

  Future pickToDateTime({required bool pickDate}) async {
    final date = await pickDateTime(
      toDate,
      pickDate: pickDate,
      firstDate: pickDate ? fromDate : null,
    );

    if (date == null) return null;

    if (date.isAfter(toDate)) {
      toDate = DateTime(
        date.year,
        date.month,
        date.day,
        toDate.hour,
        toDate.minute,
      );
    }
    setState(() {
      toDate = date;
    });
  }

  Future<DateTime?> pickDateTime(DateTime initialDate,
      {required bool pickDate, DateTime? firstDate}) async {
    if (pickDate) {
      final date = await showDatePicker(
        context: context,
        initialDate: initialDate,
        firstDate: firstDate ?? DateTime(2018, 8),
        lastDate: DateTime(2100),
      );
      if (date == null) return null;

      final time = Duration(
        hours: initialDate.hour,
        minutes: initialDate.minute,
      );
      return date.add(time);
    } else {
      final timeOfDay = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(initialDate),
      );
      if (timeOfDay == null) return null;

      final date = DateTime(
        initialDate.year,
        initialDate.month,
        initialDate.day,
      );

      final time = Duration(
        hours: timeOfDay.hour,
        minutes: timeOfDay.minute,
      );
      return date.add(time);
    }
  }

  Future saveForm() async {
    final isValid = _formKey.currentState!.validate();

    if (isValid) {
      final event = Event(
        title: titleController.text,
        timeFrom: fromDate,
        timeto: toDate,
        isAllDay: allDaySelected,
        isWeekly: weeklySelected,
        isMonthly: monthlySelected,
      );

      final isEditing = widget.event != null;
      final provider = Provider.of<EventProvider>(context, listen: false);

      if (isEditing) {
        provider.editEvent(event, widget.event!);
      } else {
        provider.addEvent(event);
      }

      Navigator.pop(context);
    }
  }
}
