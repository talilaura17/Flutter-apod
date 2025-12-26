// main_page.dart
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../keys/api_key.dart';
import '../models/ApodData.dart';
import '../widgets/astro_picture.dart';

class MainPage extends StatefulWidget{
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final String apodUrl = 'https://api.nasa.gov/planetary/apod';

  @override
  void initState() {
    _fetchDailyApodData(); // 在頁面生成時取得APOD 資訊
    super.initState();
  }

  @override
  void dispose(){
    super.dispose();
  }

  // 取得網路資料(使用api key)
  Future<ApodData?> _fetchDailyApodData() async {
    Uri url = Uri.parse('$apodUrl?api_key=$apiKey&thumbs=true');
    final response = await http.get(url, headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    });

    final parsedResponse = json.decode(response.body) as Map<String, dynamic>;
    return ApodData.fromJson(parsedResponse);
  }

  @override
  Widget build(BuildContext context) {
    Size deviceScreen = MediaQuery.of(context).size;

    return SingleChildScrollView(
      child: FutureBuilder(
        future: _fetchDailyApodData(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            ApodData? data = snapshot.data;
            //
            return AstroPicture(
              title: data?.title ?? '',
              pictureUrl: data?.url ?? '',
              desc: data?.desc ?? '',
              note: 'Place your note here!', // 待日後將儲存的筆記放進來
              isFavorite: false,
            );
          }
          if (snapshot.hasError) {
            return const Center(
                child: Text(
                  '頁面載入錯誤',
                  style: TextStyle(color: Colors.red, fontSize: 30),
                ));
          }
          return SizedBox(
              height: deviceScreen.height,
              width: deviceScreen.width,
              child: const Center(child: CircularProgressIndicator()));
        },
      ),
    );
  }
}