import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kDebugMode, kIsWeb;
import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:schedrag/data/models/time_blocks.dart';

class TimetablePage extends StatefulWidget {
  const TimetablePage({super.key});

  @override
  State<TimetablePage> createState() => _TimetablePageState();
}

class _TimetablePageState extends State<TimetablePage> {
  final CalendarController<TimeBlock> controller = CalendarController(
    calendarDateTimeRange: DateTimeRange(
      start: DateTime(DateTime.now().year - 1),
      end: DateTime(DateTime.now().year + 1),
    ),
  );
  final CalendarEventsController<TimeBlock> eventController =
      CalendarEventsController<TimeBlock>();

  late ViewConfiguration currentConfiguration = viewConfigurations[0];
  List<ViewConfiguration> viewConfigurations = [
    CustomMultiDayConfiguration(
      name: 'Day',
      numberOfDays: 1,
      startHour: 3,
      endHour: 23,
    ),
    CustomMultiDayConfiguration(
      name: 'Custom',
      numberOfDays: 1,
    ),
    WeekConfiguration(),
    WorkWeekConfiguration(),
    MonthConfiguration(),
    ScheduleConfiguration(),
  ];

  TimeBlocksDb? db;

  @override
  void initState() {
    super.initState();
    // add new event
    db = TimeBlocksDb();
    loadInitialEvents();
    //db?.getAll().then((List<TimeBlock>? timeblocksdb) {
    //  if (timeblocksdb != null) {
    //    for (TimeBlock block in timeblocksdb) {
    //      eventController.addEvent(CalendarEvent(
    //        dateTimeRange:
    //            DateTimeRange(start: block.startTime, end: block.endTime),
    //        eventData: block,
    //      ));
    //    }
    //  }
    //});
  }

  Future<void> loadInitialEvents() async {
    // Debugging to check if db is initialized and fetches data correctly
    if (db == null) {
      if (kDebugMode) {
        print("Database is not initialized");
      }
      return;
    }

    List<TimeBlock>? timeblocksdb = await db?.getAll();

    if (timeblocksdb != null && timeblocksdb.isNotEmpty) {
      if (kDebugMode) {
        print('Fetched ${timeblocksdb.length} events from the database');
      }

      // Add the fetched events from the database to the event controller
      for (TimeBlock block in timeblocksdb) {
        if (kDebugMode) {
          print('Adding event: ${block.name}');
        }
        eventController.addEvent(CalendarEvent(
          dateTimeRange:
              DateTimeRange(start: block.startTime, end: block.endTime),
          eventData: block,
        ));
      }
    } else if (kDebugMode) {
      print('No events found in the database');
    }

    // Notify the calendar to update after events are added
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final calendar = CalendarView<TimeBlock>(
      controller: controller,
      eventsController: eventController,
      viewConfiguration: currentConfiguration,
      tileBuilder: _tileBuilder,
      multiDayTileBuilder: _multiDayTileBuilder,
      scheduleTileBuilder: _scheduleTileBuilder,
      components: CalendarComponents(
        calendarHeaderBuilder: _calendarHeader,
      ),
      eventHandlers: CalendarEventHandlers(
        onEventTapped: _onEventTapped,
        onEventChanged: _onEventChanged,
        onCreateEvent: _onCreateEvent,
        onEventCreated: _onEventCreated,
      ),
    );
    return SafeArea(
      child: Scaffold(
        body: calendar,
      ),
    );
  }

  CalendarEvent<TimeBlock> _onCreateEvent(DateTimeRange dateTimeRange) {
    TimeBlock newBlock = TimeBlock.detail(
        name: 'new event',
        category: null,
        notes: null,
        startTime: dateTimeRange.start,
        endTime: dateTimeRange.end);
    db?.insert(newBlock);
    return CalendarEvent(
      dateTimeRange: dateTimeRange,
      eventData: newBlock,
    );
  }

  Future<void> _onEventCreated(CalendarEvent<TimeBlock> event) async {
    // Add the event to the events controller.
    eventController.addEvent(event);

    // Deselect the event.
    eventController.deselectEvent();
  }

  Future<void> _onEventTapped(
    CalendarEvent<TimeBlock> event,
  ) async {
    if (isMobile) {
      eventController.selectedEvent == event
          ? eventController.deselectEvent()
          : eventController.selectEvent(event);
    }
  }

  Future<void> _onEventChanged(
    DateTimeRange initialDateTimeRange,
    CalendarEvent<TimeBlock> event,
  ) async {
    if (isMobile) {
      eventController.deselectEvent();
    }
  }

  Widget _tileBuilder(
    CalendarEvent<TimeBlock> event,
    TileConfiguration configuration,
  ) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      margin: EdgeInsets.zero,
      elevation: configuration.tileType == TileType.ghost ? 0 : 8,
      child: Center(
        child: configuration.tileType != TileType.ghost
            ? Text(event.eventData?.name ?? 'New Event')
            : null,
      ),
    );
  }

  Widget _multiDayTileBuilder(
    CalendarEvent<TimeBlock> event,
    MultiDayTileConfiguration configuration,
  ) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 2),
      elevation: configuration.tileType == TileType.selected ? 8 : 0,
      child: Center(
        child: configuration.tileType != TileType.ghost
            ? Text(event.eventData?.name ?? 'New Event')
            : null,
      ),
    );
  }

  Widget _scheduleTileBuilder(CalendarEvent<TimeBlock> event, DateTime date) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(event.eventData?.name ?? 'New Event'),
    );
  }

  Widget _calendarHeader(DateTimeRange dateTimeRange) {
    return Row(
      children: [
        DropdownMenu(
          onSelected: (value) {
            if (value == null) return;
            setState(() {
              currentConfiguration = value;
            });
          },
          initialSelection: currentConfiguration,
          dropdownMenuEntries: viewConfigurations
              .map((e) => DropdownMenuEntry(value: e, label: e.name))
              .toList(),
        ),
        IconButton.filledTonal(
          onPressed: controller.animateToPreviousPage,
          icon: const Icon(Icons.navigate_before_rounded),
        ),
        IconButton.filledTonal(
          onPressed: controller.animateToNextPage,
          icon: const Icon(Icons.navigate_next_rounded),
        ),
        IconButton.filledTonal(
          onPressed: () {
            controller.animateToDate(DateTime.now());
          },
          icon: const Icon(Icons.today),
        ),
      ],
    );
  }

  bool get isMobile {
    return kIsWeb ? false : Platform.isAndroid || Platform.isIOS;
  }
}
