import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:holiday/main.dart';
import 'package:holiday/views/apiservices.dart';
import 'package:holiday/views/appbar.dart';
import 'package:holiday/views/data.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class AddHolidayPage extends StatefulWidget {
  @override
  _AddHolidayPageState createState() => _AddHolidayPageState();
}

class _AddHolidayPageState extends State<AddHolidayPage>
    with SingleTickerProviderStateMixin {
  DateTime? selectedDate;
  Country? selectedCountry;
  String? selectedRegion;
  String? selectedType;
  List<Country> countries = [];
  bool repeat = false;
  final _formkey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _regionController = TextEditingController();
  late AnimationController controller;
  bool isMenuBar = false;

  var CSCPickerPlus;
  String stateValue = '';
  String? countryValue;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  void _fetchData() async {
    try {
      List<Country> country = await ApiService().fetchCountry();

      setState(() {
        countries = country;
      });
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      title: "Add Holiday",

      body: Center(
        child: Form(
          key: _formkey,
          child: Container(
            width: MediaQuery.of(context).size.width / 2,
            height: MediaQuery.of(context).size.height / 1.2,

            padding: EdgeInsets.all(20),
            margin: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 150, 219, 240),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Add New Holiday',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),

                SizedBox(height: 40),
                Row(
                  children: [
                    Expanded(
                      child: _buildNameTextField(
                        "Holiday Name",
                        _nameController,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 40),

                // Date and Country
                Row(
                  children: [
                    Expanded(child: _buildDateField()),
                    
                    SizedBox(width: 20),

                    Expanded(
                      child: _buildSelectType("Select Type", selectedType, (
                        val,
                      ) {
                        setState(() => selectedType = val);
                      }),
                    ),
                  ],
                ),
                SizedBox(height: 40),

                Row(
                  children: [
                    Expanded(
                      child: _buildSelectCountry(
                        "Select Country",
                        selectedCountry,
                        (Country? val) {
                          setState(() {
                            selectedCountry = val;
                          });
                        },
                      ),
                    ),
                    SizedBox(width: 20),

                    Expanded(
                      child: _buildRegionTextField(
                        "RegionTextField",
                        _regionController,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 40),

                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Repeat:",
                        style: TextStyle(
                          fontWeight: FontWeight.w100,
                          fontSize: 18,
                        ),
                      ),

                      SizedBox(width: 20),
                      Switch(
                        value: repeat,
                        onChanged: (val) => setState(() => repeat = val),
                        activeColor: const Color.fromARGB(255, 20, 85, 82),
                      ),
                    ],
                  ),
                ),

                SizedBox(width: 20, height: 20),

                // Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {},
                      child: Text("Cancel"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 218, 237, 247),
                      ),
                    ),
                    SizedBox(width: 80),
                    ElevatedButton(
                      onPressed: () {
                        if (_formkey.currentState!.validate()) {
                          _submitHoliday();
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Please fill all required fields"),
                            ),
                          );
                        }
                      },
                      child: Text("Submit"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 218, 237, 247),
                      ),

                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNameTextField(String label, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a holiday name';
        }
        return null;
      },
    );
  }

  Widget _buildDateField() {
    return TextFormField(
      readOnly: true,
      controller: _dateController,
      decoration: InputDecoration(
        labelText: 'Select Date',
        filled: true,
        fillColor: Colors.white,
        suffixIcon: Icon(Icons.calendar_today),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
      ),
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
        );
        if (picked != null) {
          String formattedDate = DateFormat('yyyy-MM-dd').format(picked);
          setState(() {
            _dateController.text = formattedDate;
          });
        }
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select a date';
        }
        return null;
      },
    );
  }

  Widget _buildSelectType(
    String label,
    String? value,
    ValueChanged<String?> onChanged,
  ) {
    return DropdownButtonFormField<String>(
      value: value,
      items: ['Public', 'Bank', 'Religious', 'Observance']
          .map((item) => DropdownMenuItem(child: Text(item), value: item))
          .toList(),
      onChanged: (val) {
        setState(() => selectedType = val);
        debugPrint('Selected Type: $val');
      },
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select holiday type';
        }
        return null;
      },
    );
  }

  Widget _buildSelectCountry(
    String label,
    Country? selected,
    ValueChanged<Country?> onChanged,
  ) {
    return DropdownButtonFormField<Country>(
      value: selected,
      items: countries.map((country) {
        return DropdownMenuItem<Country>(
          value: country,
          child: Text(
            country.countryName,
            style: TextStyle(color: Colors.black),
          ),
        );
      }).toList(),

      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
      ),
      validator: (value) {
        if (value == null) {
          return 'Please choose country';
        }
        return null;
      },
    );
  }

  Widget _buildRegionTextField(String label, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please filled the region';
        }
        return null;
      },
    );
  }

  Future<void> _submitHoliday() async {
    final String apiUrl = "http://localhost:3000/holidays";
    final Map<String, dynamic> holidayJson = {
      'date': _dateController.text,
      'name': _nameController.text,
      'type': selectedType ?? '',
      'recurring': repeat,
      'country_code': selectedCountry?.countryCode ?? '',
      'region': _regionController.text,
    };

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(holidayJson),
      );
      Navigator.pop(context);
      if (response.statusCode == 201 || response.statusCode == 200) {
        print("Success: ${response.body}");
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Holiday submitted!")));
      } else {
        print("Error: ${response.statusCode}");
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Failed to submit")));
      }
    } catch (e) {
      print("Exception: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Network error")));
    }
  }
}
