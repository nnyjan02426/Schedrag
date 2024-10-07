import 'package:flutter/material.dart';

class AddDataPage extends StatelessWidget {
  const AddDataPage({super.key});

  @override
  Widget build(context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add New Entry"),
      ),
      body: const EntryForm(),
    );
  }
}

class EntryForm extends StatefulWidget {
  const EntryForm({super.key});

  @override
  State<EntryForm> createState() => _EntryFormState();
}

class _EntryFormState extends State<EntryForm> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(context) {
    return Form(
        key: _formKey,
        child: const Column(
          children: [],
        ));
  }
}
