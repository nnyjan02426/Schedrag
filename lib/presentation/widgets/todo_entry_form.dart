import 'package:flutter/material.dart';
import 'package:schedrag/data/models/todo_blocks.dart';
import 'package:date_field/date_field.dart';
import 'package:flex_color_picker/flex_color_picker.dart';

enum Tags { name, category, notes }

class EntryForm extends StatefulWidget {
  final TodoBlocksDb? db;
  const EntryForm({super.key, required this.db});

  @override
  State<EntryForm> createState() => _EntryFormState(db);
}

class _EntryFormState extends State<EntryForm> {
  final TodoBlocksDb? db;

  final _formKey = GlobalKey<FormState>();
  final List<TextEditingController> controllers =
      List<TextEditingController>.generate(
          3, (int index) => TextEditingController());
  List<DateTime?> times = List<DateTime?>.filled(2, null);
  Color selectedColor = Colors.white;

  _EntryFormState(this.db);

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
        title: const Text("Add New Entry"),
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
              onChanged: (value) => setState(() => times[0] = value),
            ),
            DateTimeFormField(
              decoration: const InputDecoration(
                icon: Icon(Icons.calendar_month_rounded),
                labelText: "deadline",
              ),
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
            db?.insert(TodoBlock.detail(
                name: controllers[Tags.name.index].text,
                category: controllers[Tags.category.index].text,
                estimatedTime: times[0],
                deadline: times[1],
                notes: controllers[Tags.notes.index].text,
                color: selectedColor));
            Navigator.pop(context);
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
