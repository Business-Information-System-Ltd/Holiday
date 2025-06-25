import 'dart:convert';

import 'package:holiday/views/data.dart';
import 'package:http/http.dart' as http;

class ApiService{
    final String baseUrl = 'http://localhost:3000';
    final String holidayEndPoint = "http://localhost:3000/holidays";
    final String countryEndPoint ="http://localhost:3000/countries";

//Get All Holidays
Future<List<Holiday>> fetchHolidays() async {
    final response = await http.get(Uri.parse("http://localhost:3000/holidays"));
    if(response.statusCode == 200){
        final List<dynamic> jsonList = jsonDecode(response.body);
        return jsonList.map((json)=> Holiday.fromJson(json)).toList();

    }else{
        throw Exception('Failed to load holidays');
    }
}
Future<List<Holiday>> getSortedHolidays() async {
  final url = '$holidayEndPoint?_sort=date&_order=asc';

  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    final List<dynamic> jsonList = jsonDecode(response.body);
    return jsonList.map((json) => Holiday.fromJson(json)).toList();
  } else {
    print('Error: ${response.statusCode} - ${response.body}');
    throw Exception('Failed to load sorted holidays');
  }
}
Future<List<Holiday>> getHolidayInRange(String start, String end) async {
  final url = '$holidayEndPoint?date_gte=$start&date_lte=$end';
// final uri = Uri.parse(baseUrl).replace(queryParameters: {
//     'date_gte': start,
//     'date_lte': end,
//   });
  //final url = '$baseUrl?date_gte=' + start + '&date_lte=' + end;
  print('Fetching holidays with URL: $holidayEndPoint');

  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    final List<dynamic> jsonList = jsonDecode(response.body);
    //final List<dynamic> holidaysJson = jsonMap['holidays'] ?? [];
    print('Fetched ${jsonList.length} holidays'); 
    return jsonList.map((json) => Holiday.fromJson(json)).toList();
  } else {
    print('Response: ${response.statusCode} - ${response.body}');
    throw Exception('Failed to load holidays in range');
  }
}



  /// Check if a date is a holiday
  Future<Map<String, bool>> isHoliday(String date) async {
    final uri =Uri.parse('$holidayEndPoint?date=$date');
    final response = await http.get(uri);
    if (response.statusCode == 200) {
     final List<dynamic> holidays = jsonDecode(response.body);
    final isHoliday = holidays.isNotEmpty;
    return { "is_holiday": isHoliday };
    } else {
      throw Exception('Failed to check holiday');
    }
  }

  /// Add a new holiday 
  Future<Holiday> postHoliday(Holiday holiday) async {
    final response = await http.post(
      Uri.parse(holidayEndPoint),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(holiday.toJson()),
    );
    if (response.statusCode == 201 || response.statusCode == 200) {
      return Holiday.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to add holiday');
    }
  }

  /// Update 
  Future<Holiday> updateHoliday(Holiday holiday) async {
    final response = await http.put(
      Uri.parse('$holidayEndPoint/${holiday.id}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(holiday.toJson()),
    );
    if (response.statusCode == 200) {
      return Holiday.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update holiday');
    }
  }
  Future<void> deleteHoliday(String id) async {
    final response = await http.delete(Uri.parse('$holidayEndPoint/$id'));
    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Failed to delete holiday');
    }
  }
//   Future<bool> deleteHolidayById(String name) async {
//   try {
//     final queryUrl = Uri.parse('http://localhost:3000/holidays?name=$name');
//     final response = await http.get(queryUrl);

//     if (response.statusCode == 200) {
//       final List holidays = jsonDecode(response.body);
//       if (holidays.isNotEmpty) {
//         final id = holidays[0]['id'];
//         final deleteUrl = Uri.parse('http://localhost:3000/holidays/$id');
//         final deleteResponse = await http.delete(deleteUrl);
//         return deleteResponse.statusCode == 200;
//       }
//     }
//     return false;
//   } catch (e) {
//     print("Delete error: $e");
//     return false;
//   }
// }
  //Country
   Future<List<Country>> fetchCountry() async {
    final response = await http.get(Uri.parse(countryEndPoint));
    if (response.statusCode == 200) {
      List<dynamic> body = json.decode(response.body);
      print(response.body);
      return body.map((dynamic item) => Country.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load Country');
    }
  }
   Future<Holiday> postCountry(Country country) async {
    final response = await http.post(
      Uri.parse(countryEndPoint),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(country.toJson()),
    );
    if (response.statusCode == 201 || response.statusCode == 200) {
      return Holiday.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to add country');
    }
  }

  /// Update 
  Future<Holiday> updateCountry(Country country) async {
    final response = await http.put(
      Uri.parse('$countryEndPoint/${country.id}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(country.toJson()),
    );
    if (response.statusCode == 200) {
      return Holiday.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update country');
    }
  }
  Future<void> deleteCountry(int id) async {
    final response = await http.delete(Uri.parse('$countryEndPoint/$id'));
    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Failed to delete country');
    }
  }

}
Future<bool> deleteHolidayByName(String name) async {
  try {
    final queryUrl = Uri.parse('http://localhost:3000/holidays?name=$name');
    final response = await http.get(queryUrl);

    if (response.statusCode == 200) {
      final List holidays = jsonDecode(response.body);
      if (holidays.isNotEmpty) {
        final id = holidays[0]['id'];
        final deleteUrl = Uri.parse('http://localhost:3000/holidays/$id');
        final deleteResponse = await http.delete(deleteUrl);
        return deleteResponse.statusCode == 200;
      }
    }
    return false;
  } catch (e) {
    print("Delete error: $e");
    return false;
  }
}
