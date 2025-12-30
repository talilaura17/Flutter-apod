import 'dart:convert';

import 'package:first_flutter_project01/models/apod_data.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:provider/provider.dart';

import '../api/constants.dart';
import '../keys/api_key.dart';
import '../utils/format_date.dart';
import 'favorite_state.dart';

class DailyApodState extends ChangeNotifier {

  ApodData dailyApod = ApodData('', '', '', '', '', '', false);

  Future<void> fetchDailyApodData() async {
    Uri url = Uri.parse('$apodEndpoint?api_key=$apiKey&thumbs=true');
    final response = await http.get(url, headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    });

    final parsedResponse = json.decode(response.body) as Map<String, dynamic>;
    dailyApod = ApodData.fromJson(parsedResponse);

    notifyListeners();
  }
}