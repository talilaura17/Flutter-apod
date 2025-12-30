// main_page.dart
import 'dart:convert';

import 'package:first_flutter_project01/models/daily_apod_state.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../api/constants.dart';
import '../keys/api_key.dart';
import '../models/apod_data.dart';
import '../widgets/astro_picture.dart';

class MainPage extends StatefulWidget{
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  bool _isLoading = false;

  @override
  void initState() {
    fetchDailyApodData(); // 在頁面生成時取得APOD 資訊
    super.initState();
  }

  @override
  void dispose(){
    super.dispose();
  }

  // 取得網路資料(使用api key)
  void fetchDailyApodData() async {
    setState(() {
      _isLoading = true;
    });

    await Provider.of<DailyApodState>(context, listen: false).fetchDailyApodData();

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size deviceScreen = MediaQuery.of(context).size;

    return _isLoading
        ? SizedBox(
            height: deviceScreen.height,
            width: deviceScreen.width,
            child: const Center(child: CircularProgressIndicator()),
          )
        : Consumer<DailyApodState>(
            builder: (context, dailyApodState, child){
              return AstroPicture(apodData: dailyApodState.dailyApod);
            }
          );

  }
}