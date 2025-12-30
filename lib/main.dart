import 'package:first_flutter_project01/models/daily_apod_state.dart';
import 'package:first_flutter_project01/models/favorite_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'Pages/calendar_page.dart';
import 'Pages/favorite_page.dart';
import 'Pages/main_page.dart';
import 'Pages/screen_arguments.dart';
import 'Pages/test_text_input_page.dart';

void main() {
  runApp(
      MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) =>
                  FavoriteState(),),
            ChangeNotifierProvider(create: (context) =>
                  DailyApodState(),),
          ],
      child:  const MyApp(),
      )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),

      // 使用於 Navigator.pushNamed 導頁
      routes: {
        ExtractArgumentsScreen.routeName: (context) =>
        const ExtractArgumentsScreen(),

        MyStatefulWidget.routeName: (context) =>
        const MyStatefulWidget(),
      },

      home: const MyHomePage(),

    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 1;

  final List<Map<String, dynamic>> _pages = [
    {
      'title': '月曆',
      'widget': const CalendarPage(),
    },
    {
      'title': '今日照片',
      'widget': const MainPage(),
    },
    {
      'title': '我的收藏',
      'widget': const FavoritePage()
    }
  ]; // 加入三個頁面

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(_pages[_selectedIndex]['title']),
        //backgroundColor: Colors.blue,
      ),
      body: Center( child: _pages[_selectedIndex]['widget'], // 會因為_selectedIndex的改變而切換頁面
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month),
            label: '月曆',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '首頁',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: '我的收藏',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        selectedItemColor: Colors.blue,
        selectedFontSize: 14,
        unselectedFontSize: 14,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
