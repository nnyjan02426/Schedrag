import 'package:flutter/material.dart';
import 'package:schedrag/data/models/child_blocks.dart';
import 'package:date_field/date_field.dart';

enum Tags { name, category, notes }

class EntryForm extends StatefulWidget {
  final TimeBlocksDb? db;
  const EntryForm({super.key, required this.db});

  @override
  State<EntryForm> createState() => _EntryFormState(db);
}

class _EntryFormState extends State<EntryForm> {
  final TimeBlocksDb? db;

  final _formKey = GlobalKey<FormState>();
  final List<TextEditingController> controllers =
      List<TextEditingController>.generate(
          3, (int index) => TextEditingController());
  List<DateTime?> times = List<DateTime?>.filled(2, null);

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
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (db != null && _formKey.currentState!.validate()) {
            db?.insert(TimeBlock.detail(
                name: controllers[Tags.name.index].text,
                category: controllers[Tags.category.index].text,
                estimatedTime: times[0],
                deadline: times[1],
                notes: controllers[Tags.notes.index].text));
            Navigator.pop(context);
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
