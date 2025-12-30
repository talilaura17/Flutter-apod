import 'dart:convert';

import 'package:provider/provider.dart';

import 'package:first_flutter_project01/models/viewed_date_state.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:table_calendar/table_calendar.dart';
import '../keys/api_key.dart';

import '../models/apod_data.dart';
import '../widgets/astro_picture.dart';
import '../widgets/calendar_day_cell.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {

  final DateTime today = DateTime.now();
  late final DateTime safeEndDate = DateTime(today.year, today.month, today.day - 1);
  late DateTime _focusedDay = safeEndDate;
  late DateTime _selectedDay = safeEndDate;
  late DateTime current = safeEndDate;

  bool _isLoading = false;
  final String apodUrl = 'https://api.nasa.gov/planetary/apod';

  final Map<String, ApodData> _dailyApodMap = {};

  @override
  void initState() {
    super.initState();
    String firstDayofMonth = formatDate(DateTime(current.year, current.month, 1));
    _fetchDailyApodData(firstDayofMonth, formatDate(current));
  }

  Future<void> _fetchDailyApodData(String startDate, String endDate) async {

    if(_dailyApodMap[startDate] != null && _dailyApodMap[endDate] != null){
      // 已經有前後時間的資料，代表當月都抓過了，不必再call api抓一次
      return;
    }

    setState(() {
      _isLoading = true;
    });

    Uri url = Uri.parse('$apodUrl?api_key=$apiKey&thumbs=true&start_date=$startDate&end_date=$endDate');
    final response = await http.get(url, headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    });

    final parsedResponse = json.decode(response.body) as List<dynamic>;
    List<Map<String, dynamic>> dataList = parsedResponse.map((data) => data as Map<String, dynamic>).toList();
    for (var data in dataList){
      _dailyApodMap[data['date']] = ApodData.fromJson(data);
    }

    setState(() {
      _isLoading = false;
    });
  }

  String formatDate(DateTime datetime) {
    return '${datetime.year}-${datetime.month < 10 ? '0${datetime.month}' : datetime.month}-${datetime.day < 10 ? '0${datetime.day}' : datetime.day}';
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: _isLoading
      ? const CircularProgressIndicator()
      : TableCalendar(
        headerStyle: const HeaderStyle(formatButtonVisible: false),
        firstDay: DateTime.utc(current.year - 2, 01, 01),
        lastDay: safeEndDate,
        focusedDay: _focusedDay,
        selectedDayPredicate: (day) {
          return isSameDay(_selectedDay, day);
        },
        onPageChanged: (focusedDay){
          setState(() {
            //_selectedDay = focusedDay;
            _focusedDay = focusedDay;
          });
          if (focusedDay.month <= current.month){
            String lastDayOfMonth = formatDate(DateTime(focusedDay.year, focusedDay.month + 1, 0));
            _fetchDailyApodData(formatDate(focusedDay),
                DateTime(focusedDay.year, focusedDay.month + 1, 0).isAfter(current)
                    ? formatDate(current)
                    : lastDayOfMonth
            );
          }
        },
        onDaySelected: (selectedDay, focusedDay) {
          setState(() {
            _selectedDay = selectedDay;
            _focusedDay = focusedDay; // update `_focusedDay` here as well
          });
        },
        onDayLongPressed: ((selectedDay, focusedDay) {
          context.read<ViewedDateState>().markViewed(formatDate(selectedDay));
          String date = formatDate(focusedDay);
          // 長按日期時導向該日的天文圖片頁面
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return Scaffold(
              appBar: AppBar(title: Text(formatDate(selectedDay)),),
              body: AstroPicture(
                apodData: ApodData(_dailyApodMap[date]?.title ?? '',
                                  _dailyApodMap[date]?.url ?? '',
                                  _dailyApodMap[date]?.mediaType ?? '',
                                  _dailyApodMap[date]?.desc ?? '',
                                  _dailyApodMap[date]?.date ?? '',
                                  '',
                                  false)
              ),
            );
          }));
        }),
        calendarBuilders:
        CalendarBuilders(
          defaultBuilder: (context, day, focusedDay) =>
            Consumer<ViewedDateState>(
                builder: (context, viewed, child){
                  final isViewed = viewed.isViewed(formatDate(day));
                  return
                    Center(child: CalendarDayCell(
                    day: day,
                    hasDot: _dailyApodMap[formatDate(day)] != null,
                    dotColor: isViewed ? Colors.green : Colors.red,
                  ));
                }
            ),
          selectedBuilder: (context, day, focusedDay) =>
              Consumer<ViewedDateState>(
                  builder: (context, viewed, child){
                    final isViewed = viewed.isViewed(formatDate(day));
                    return
                      Center(
                        child: CalendarDayCell(
                          day: day,
                          decoration: BoxDecoration(
                            color: Colors.blue[300],
                            shape: BoxShape.circle,
                          ),
                      hasDot: _dailyApodMap[formatDate(day)] != null,
                      dotColor: isViewed ? Colors.green : Colors.red,
                    ));
                  }
              ),
          todayBuilder: (context, day, focusedDay) =>
              Consumer<ViewedDateState>(
                builder: (context, viewed, child){
                  final isViewed = viewed.isViewed(formatDate(day));
                  return
                    Center(
                      child: CalendarDayCell(
                        day: day,
                        decoration: BoxDecoration(
                          color: Colors.blue[100],
                          shape: BoxShape.circle,
                        ),
                      hasDot: _dailyApodMap[formatDate(day)] != null,
                      dotColor: isViewed ? Colors.green : Colors.red,
                      ),
                    );
                }
              )
      )
      )
    );
  }
}