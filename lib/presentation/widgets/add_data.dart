import 'package:flutter/material.dart';
import 'package:schedrag/data/models/child_blocks.dart';

class EntryForm extends StatefulWidget {
  final TimeBlocksDb? db;
  const EntryForm({super.key, required this.db});

  @override
  State<EntryForm> createState() => _EntryFormState(db);
}

class _EntryFormState extends State<EntryForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _categoryController = TextEditingController();
  final _notesController = TextEditingController();

  final TimeBlocksDb? db;
  _EntryFormState(this.db);

  @override
  void dispose() {
    _nameController.dispose();
    _categoryController.dispose();
    _notesController.dispose();
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
              controller: _nameController,
              autovalidateMode: AutovalidateMode.always,
            ),
            TextFormField(
              decoration: const InputDecoration(
                icon: Icon(Icons.category_rounded),
                labelText: "Category",
              ),
              controller: _categoryController,
            ),
            TextFormField(
              decoration: const InputDecoration(
                icon: Icon(Icons.sticky_note_2_rounded),
                labelText: "Notes",
              ),
              controller: _notesController,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (db != null && _formKey.currentState!.validate()) {
            db?.insert(TimeBlock.detail(
                name: _nameController.text,
                category: _categoryController.text,
                notes: _notesController.text));
            Navigator.pop(context);
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
