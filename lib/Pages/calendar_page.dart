import 'package:first_flutter_project01/Pages/screen_arguments.dart';
import 'package:first_flutter_project01/Pages/test_text_input_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../models/screen_arguments.dart';

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
            Navigator.pushNamed(
              context,
              MyStatefulWidget.routeName,
              arguments: ScreenArguments(
                'Extract Arguments Screen',
                'This message is extracted in the build method.',
              ), // 指定要傳輸的參數
            );
          },
          child: const Text('Navigate to MyHome Page')),
    );
  }
}