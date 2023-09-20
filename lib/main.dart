import 'package:flutter/material.dart';
import 'package:online_events/models/list_event.dart';
import 'package:online_events/theme.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    const textStyle = TextStyle(
      color: OnlineTheme.black,
      fontWeight: FontWeight.bold,
      fontFamily: 'SourceSans',
      fontSize: 15,
      fontStyle: FontStyle.normal,
      decoration: TextDecoration.none,
    );

    final padding = MediaQuery.of(context).padding + const EdgeInsets.all(20);

    return MaterialApp(
      title: 'Online Events',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Padding(
          padding: padding,
          child: const Stack(
            children: [
              Positioned(
                left: 0,
                right: 0,
                top: 25,
                height: 100,
                child: Text(
                  'Kommende arrangementer',
                  style: textStyle,
                ),
              ),
              Positioned.fill(top: 50, child: EventList()),
            ],
          ),
        ),
      ),
    );
  }
}

final testModels = [
  ListEventModel(
    category: Category.sosialt,
    name: 'Buldring med OIL!',
    date: DateTime(2023, 9, 25),
    registered: 3,
    capacity: 20,
  ),
  ListEventModel(
    category: Category.bedpress,
    name: 'Bedriftspresentasjon med Sopra Steria',
    date: DateTime(2023, 9, 26),
    registered: 0,
    capacity: 40,
  ),
  ListEventModel(
    category: Category.annet,
    name: 'genVORS',
    date: DateTime(2023, 9, 27),
    registered: 0,
    capacity: 200,
  ),
];

class EventList extends StatelessWidget {
  const EventList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: buildItem,
      itemCount: testModels.length,
    );
  }

  Widget buildItem(BuildContext context, int index) {
    return EventListItem(
      model: testModels[index],
    );
  }
}

class EventListItem extends StatelessWidget {
  final ListEventModel _model;

  const EventListItem({super.key, required ListEventModel model}) : _model = model;

  ListEventModel get model => _model;

  Color categoryColor() {
    switch (_model.category) {
      case Category.bedpress:
        return OnlineTheme.red;
      case Category.sosialt:
        return OnlineTheme.green;
      case Category.utflukt:
        return OnlineTheme.yellow;
      case Category.kurs:
        return OnlineTheme.blue;
      case Category.ekskursjon:
        return OnlineTheme.lightBlue;
      case Category.annet:
        return OnlineTheme.purple;
    }
  }

  String categoryString() {
    final string = _model.category.toString().split('.').last;
    return string[0].toUpperCase() + string.substring(1);
  }

  String dateString() {
    final month = _model.date.month;
    final day = _model.date.day;

    return '${day.toString().padLeft(2, '0')}.${month.toString().padLeft(2, '0')}';
  }

  String peopleString() {
    return '${_model.registered}/${_model.capacity}';
  }

  @override
  Widget build(BuildContext context) {
    final color = categoryColor();
    final categoryLabel = categoryString();

    final textStyle = TextStyle(
      color: color,
      fontWeight: FontWeight.normal,
      fontFamily: 'SourceSans',
      fontSize: 12,
      fontStyle: FontStyle.normal,
      decoration: TextDecoration.none,
    );

    return Container(
      decoration: const BoxDecoration(border: Border(top: BorderSide(color: OnlineTheme.gray, width: 1))),
      height: 30,
      child: Row(children: [
        // SizedBox.square(
        //   dimension: 30,
        //   child: Container(
        //     margin: const EdgeInsets.all(10),
        //     width: 10,
        //     height: 10,
        //     color: color,
        //   ),
        // ),
        // SizedBox(
        //   width: 80,
        //   child: Text(
        //     categoryLabel,
        //     style: textStyle.copyWith(fontWeight: FontWeight.bold),
        //   ),
        // ),
        Expanded(
          child: Text(
            _model.name,
            style: textStyle.copyWith(color: OnlineTheme.black),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        SizedBox(
          width: 80,
          child: Row(
            children: [
              const SizedBox(
                width: 30,
                child: Icon(
                  Icons.calendar_month_outlined,
                  color: OnlineTheme.black,
                  size: 20,
                ),
              ),
              Text(dateString(), style: textStyle.copyWith(color: OnlineTheme.black)),
            ],
          ),
        ),
        SizedBox(
          width: 80,
          child: Row(
            children: [
              const SizedBox(
                width: 30,
                child: Icon(
                  Icons.person_outline_outlined,
                  color: OnlineTheme.black,
                  size: 20,
                ),
              ),
              Text(peopleString(), style: textStyle.copyWith(color: OnlineTheme.black)),
            ],
          ),
        ),
      ]),
    );
  }
}
