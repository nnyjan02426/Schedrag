import 'package:flutter/cupertino.dart';

class TodoPage extends StatelessWidget {
  final TextStyle optionStyle;
  const TodoPage(this.optionStyle, {super.key});

  @override
  Widget build(BuildContext context) => Text('Todo', style: optionStyle);
}
