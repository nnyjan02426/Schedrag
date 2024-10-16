import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:schedrag/data/models/todo_blocks.dart';
import 'package:schedrag/presentation/widgets/todo_edit_form.dart';
import 'package:schedrag/presentation/widgets/todo_entry_form.dart';

class TodoPage extends StatefulWidget {
  final TextStyle optionStyle;
  const TodoPage(this.optionStyle, {super.key});

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  late Future<List<TodoBlock>?> dbList;
  var num = 0;

  @override
  Widget build(context) {
    return ChangeNotifierProvider(
      create: (context) => TodoBlocksDb(),
      child: Consumer<TodoBlocksDb>(builder: (context, todoblocksdb, child) {
        dbList = todoblocksdb.getAll();
        return Scaffold(
          body: FutureBuilder<List<TodoBlock>?>(
            builder: (con, snap) {
              if (snap.hasData) {
                return ListView.builder(
                  itemCount: snap.data!.length,
                  itemBuilder: (context, index) {
                    return Card(
                      color: snap.data![index].color,
                      elevation: 3,
                      child: ListTile(
                          title: Text(snap.data![index].name.toString()),
                          onTap: () {
                            if (kDebugMode) {
                              print(
                                  "[name]: ${snap.data![index].name.toString()}");
                            }
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditForm(
                                      db: todoblocksdb,
                                      block: snap.data![index]),
                                ));
                          }),
                    );
                  },
                );
              } else {
                return const Center(child: Text("Waiting..."));
              }
            },
            future: dbList,
          ),
          floatingActionButton: FloatingActionButton(
            // add new timeblock
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EntryForm(db: todoblocksdb),
                  ));
            },
            child: const Icon(Icons.add),
          ),
        );
      }),
    );
  }
}
