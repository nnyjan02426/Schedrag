import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:schedrag/presentation/presentation.dart';

void main() => runApp(const Schedrag());

class Schedrag extends StatelessWidget {
  const Schedrag({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Schedrag',
      theme: ThemeData(
        //colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      //home: const MyHomePage(title: 'Flutter Demo Home Page'),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    late Widget page;
    switch (_selectedIndex) {
      case 0:
        page = SchedulePage(optionStyle);
        if (kDebugMode) {
          print('Page [Schedule] selected');
        }
      case 1:
        page = TodoPage(optionStyle);
        if (kDebugMode) {
          print('Page [Todo] selected');
        }
      case 2:
        page = TimetablePage(optionStyle);
        if (kDebugMode) {
          print('Page [Timetable] selected');
        }
      case 3:
        page = SettingsPage(optionStyle);
        if (kDebugMode) {
          print('Page [Settings] selected');
        }
      default:
        throw UnimplementedError('no widget for $_selectedIndex');
    }

    return Scaffold(
      body: Center(
        child: page,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,

        // colors
        backgroundColor: Theme.of(context).colorScheme.onSurface,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Theme.of(context).colorScheme.secondary,

        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.today_rounded),
            label: 'Schedule',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Todo',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.table_chart),
            label: 'Timetable',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
