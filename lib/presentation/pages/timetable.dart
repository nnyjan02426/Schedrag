import 'package:flutter/cupertino.dart';

class TimetablePage extends StatelessWidget{
  final TextStyle optionStyle;
  const TimetablePage(this.optionStyle, {super.key});

  @override
  Widget build(BuildContext context) => Text('Timetable', style: optionStyle);
}
