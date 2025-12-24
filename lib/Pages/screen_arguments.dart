import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../models/screen_arguments.dart';

import 'main_page.dart';

class ExtractArgumentsScreen extends StatelessWidget {
  const ExtractArgumentsScreen({super.key});
  // 預先寫好此頁面的路徑名稱並設為static，可直接從類別取用
  static const routeName = '/extractArguments';

  @override
  Widget build(BuildContext context) {
    // 從settings.argument中取出物件並告訴flutter其型別為ScreenArguments
    final args = ModalRoute.of(context)!.settings.arguments as ScreenArguments;

    return Scaffold(
      appBar: AppBar(
        title: Text(args.title),
      ),
      body: Center(
        child: Text(args.message),
      ),
      bottomNavigationBar: Center(
        child: TextButton(
            onPressed: () {
              Navigator.pop(context, 'Hi There!');
            }, child: const Text('Nope.')),
      ),
    );
  }
}