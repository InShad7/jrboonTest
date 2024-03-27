import 'package:flutter/material.dart';
import 'package:jrboon/view/home_screen/widget/add_event_Screen.dart';
import 'package:jrboon/view/home_screen/widget/calendar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Jrboon Calendar'),
      ),
      body: const CalendarWidget(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurple,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddEventScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
