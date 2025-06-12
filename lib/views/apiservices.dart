import 'dart:convert';

import 'package:holiday/views/data.dart';
import 'package:http/http.dart' as http;

class HolidayApiService{
    final String baseUrl = 'http://localhost:3000/holidays';

//Get All Holidays
Future<List<Holiday>> getAllHoildays() async {
    final response = await http.get(Uri.parse(baseUrl));
    if(response.statusCode == 200){
        final List<dynamic> jsonList = jsonDecode(response.body);
        return jsonList.map((json)=> Holiday.fromJson(json)).toList();

    }else{
        throw Exception('Failed to load holidays');
    }
}
Future<List<Holiday>> getHolidayInRange(String start, String end) async {
  final url = '$baseUrl?date_gte=$start&date_lte=$end';
  print('Fetching holidays with URL: $url'); // Debug print

  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    final List<dynamic> jsonList = jsonDecode(response.body);
    print('Fetched ${jsonList.length} holidays'); // Debug print
    return jsonList.map((json) => Holiday.fromJson(json)).toList();
  } else {
    print('Response: ${response.statusCode} - ${response.body}');
    throw Exception('Failed to load holidays in range');
  }
}



  /// Check if a date is a holiday
  Future<Map<String, bool>> isHoliday(String date) async {
    final uri =Uri.parse('$baseUrl?date=$date');
    final response = await http.get(uri);
    if (response.statusCode == 200) {
     final List<dynamic> holidays = jsonDecode(response.body);
    final isHoliday = holidays.isNotEmpty;
    return { "is_holiday": isHoliday };
    } else {
      throw Exception('Failed to check holiday');
    }
  }

  /// Add a new holiday (admin only)
  Future<Holiday> addHoliday(Holiday holiday) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(holiday.toJson()),
    );
    if (response.statusCode == 201 || response.statusCode == 200) {
      return Holiday.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to add holiday');
    }
  }

  /// Update a holiday by ID
  Future<Holiday> updateHoliday(Holiday holiday) async {
    final response = await http.put(
      Uri.parse('$baseUrl/${holiday.id}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(holiday.toJson()),
    );
    if (response.statusCode == 200) {
      return Holiday.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update holiday');
    }
  }
  Future<void> deleteHoliday(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));
    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Failed to delete holiday');
    }
  }
}