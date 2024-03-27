
import 'package:flutter/material.dart';

class BuildTitleField extends StatelessWidget {
  const BuildTitleField({
    super.key,
    required this.titleController,
  });

  final TextEditingController titleController;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: titleController,
      style: const TextStyle(
        fontSize: 20,
      ),
      decoration: const InputDecoration(
        hintText: 'Add Event Title',
      ),
      validator: (title) => title != null && title.isEmpty
          ? 'Title cannot be empty'
          : null,
      onFieldSubmitted: (value) {},
    );
  }
}
