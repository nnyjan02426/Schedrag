import 'package:flutter/material.dart';
import 'package:schedrag/data/models/child_blocks.dart';

class TodoPage extends StatefulWidget {
  final TextStyle optionStyle;
  const TodoPage(this.optionStyle, {super.key});

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  final db = TimeBlocksDb();
  late Future<List<TimeBlock>?> dbList;
  int num = 0;

  @override
  void initState() {
    dbList = db.getAll();
    super.initState();
  }

  @override
  Widget build(context) {
    return Scaffold(
      body: FutureBuilder<List<TimeBlock>?>(
        builder: (con, snap) {
          if (snap.hasData) {
            return ListView.builder(
              itemCount: snap.data!.length,
              itemBuilder: (context, index) {
                return ListTile(
                    title: Text(snap.data![index].name.toString()),
                    onTap: () {});
              },
            );
          } else {
            return CircularProgressIndicator();
          }
        },
        future: dbList,
      ),
      //body: ListView(
      //  children: [
      //    for (var row in db.getAll())
      //      ListTile(title: Text(row['name']), onTap: () {}),
      //  ],
      //),
      floatingActionButton: FloatingActionButton(
        // add new timeblock
        onPressed: () {
          db.insert(TimeBlock.name('name_$num'));
          print('name_$num/n');
          num++;
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
