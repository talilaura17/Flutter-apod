import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'main_page.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: TextButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return Scaffold(
                  appBar: AppBar(
                    title: const Text('Lunation Matrix'),
                  ),
                  body: const MainPage());
            }));
          },
          child: const Text('Navigate to MyHome Page')),
    );
  }
}