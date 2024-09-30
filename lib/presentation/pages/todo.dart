import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:schedrag/presentation/widgets/block_widgets.dart';

class TodoPage extends StatelessWidget {
  final TextStyle optionStyle;
  final db = TimeBlocksDb();
  TodoPage(this.optionStyle, {super.key});

  int num = 0;
  List<Map> table = await db.getAll();

  @override
  //Widget build(BuildContext context) => Text('Todo', style: optionStyle);
  Widget build(context) {
    return Scaffold(
      body: ListView(
        children: [
          for(Map row in table)
          ListTile(title: Text(row['name']), onTap: () {}),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        // add new timeblock
        onPressed: () {
          db.insert(TimeBlock('name_$num'));
          num++;
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
