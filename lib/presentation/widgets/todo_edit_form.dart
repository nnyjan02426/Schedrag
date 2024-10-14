import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';
import 'package:schedrag/data/models/todo_blocks.dart';
import 'package:date_field/date_field.dart';
import 'package:flex_color_picker/flex_color_picker.dart';

enum Tags { name, category, notes }

class EditForm extends StatefulWidget {
  final TodoBlocksDb? db;
  final TodoBlock block;
  const EditForm({super.key, required this.db, required this.block});

  @override
  State<EditForm> createState() => _EditFormState(db, block);
}

class _EditFormState extends State<EditForm> {
  final TodoBlocksDb? db;
  final TodoBlock block;
  late Color selectedColor;
  late List<TextEditingController> controllers;

  _EditFormState(this.db, this.block) {
    selectedColor = block.color!;
    controllers = [
      TextEditingController(text: block.name),
      TextEditingController(text: block.category),
      TextEditingController(text: block.notes),
    ];
    if (kDebugMode) {
      print("Editing block: ${block.id}");
    }
  }

  final _formKey = GlobalKey<FormState>();
  List<DateTime?> times = List<DateTime?>.filled(2, null);

  @override
  void dispose() {
    for (var controller in controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add New Edit"),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              decoration: const InputDecoration(
                icon: Icon(Icons.abc_rounded),
                labelText: "Name *",
              ),
              validator: (value) {
                return (value == null || value.isEmpty)
                    ? "new block must have a name"
                    : null;
              },
              controller: controllers[Tags.name.index],
              autovalidateMode: AutovalidateMode.onUnfocus,
            ),
            TextFormField(
              decoration: const InputDecoration(
                icon: Icon(Icons.category_rounded),
                labelText: "Category",
              ),
              controller: controllers[Tags.category.index],
            ),
            TextFormField(
              decoration: const InputDecoration(
                icon: Icon(Icons.sticky_note_2_rounded),
                labelText: "Notes",
              ),
              controller: controllers[Tags.notes.index],
            ),
            DateTimeFormField(
              decoration: const InputDecoration(
                icon: Icon(Icons.timer_outlined),
                labelText: "estimatedTime",
              ),
              initialValue: block.estimatedTime,
              onChanged: (value) => setState(() => times[0] = value),
            ),
            DateTimeFormField(
              decoration: const InputDecoration(
                icon: Icon(Icons.calendar_month_rounded),
                labelText: "deadline",
              ),
              initialValue: block.deadline,
              onChanged: (value) => setState(() => times[1] = value),
            ),
            Card(
              elevation: 2,
              child: ColorPicker(
                color: selectedColor,
                onColorChanged: (Color color) =>
                    setState(() => selectedColor = color),
                heading: Text("Select color",
                    style: Theme.of(context).textTheme.headlineSmall),
                subheading: Text("Select color shade",
                    style: Theme.of(context).textTheme.titleSmall),
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (db != null && _formKey.currentState!.validate()) {
            block.setDetail(
                name: controllers[Tags.name.index].text,
                category: controllers[Tags.category.index].text,
                estimatedTime: times[0],
                deadline: times[1],
                notes: controllers[Tags.notes.index].text,
                color: selectedColor);
            db?.update(block);
            Navigator.pop(context);
          }
        },
        child: const Icon(Icons.check),
      ),
    );
  }
}
