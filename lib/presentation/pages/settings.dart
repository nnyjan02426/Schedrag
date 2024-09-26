import 'package:flutter/cupertino.dart';

class SettingsPage extends StatelessWidget{
  final TextStyle optionStyle;
  const SettingsPage(this.optionStyle, {super.key});

  @override
  Widget build(BuildContext context) => Text('Settings', style: optionStyle);
}
