import 'package:flutter/cupertino.dart';

class SchedulePage extends StatelessWidget{
  final TextStyle optionStyle;
  const SchedulePage(this.optionStyle, {super.key});

  @override
  Widget build(BuildContext context) => Text('Schedule', style: optionStyle);
}
