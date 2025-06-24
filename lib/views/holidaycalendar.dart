import 'package:flutter/material.dart';
import 'package:holiday/views/apiservices.dart';
import 'package:holiday/views/appbar.dart';
import 'package:holiday/views/data.dart';
import 'package:table_calendar/table_calendar.dart';

class HolidayCalendar extends StatefulWidget {
  const HolidayCalendar({super.key});

  @override
  State<HolidayCalendar> createState() => HolidayCalendarState();
}

class HolidayCalendarState extends State<HolidayCalendar> {
  List<Holiday> holidays = [];
  String selectedType = 'All';
  DateTime focusDay = DateTime(DateTime.now().year, DateTime.now().month);
  DateTime? selectedDay;
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    _loadHolidays();
  }

  Future<void> _loadHolidays() async {
    setState(() => isLoading = true);
    try {
      final holidayList = await ApiService().fetchHolidays();
      setState(() {
        holidays = holidayList;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      print("Failed to load holidays");
    }
  }

  List<Holiday> get filteredHolidays {
    return selectedType == 'All'
        ? holidays
        : holidays.where((h) => h.type == selectedType).toList();
  }

  Holiday? getHolidayByDate(DateTime day) {
    try {
      return filteredHolidays.firstWhere(
        (h) => isSameDay(DateTime.parse(h.date), day),
      );
    } catch (_) {
      return null;
    }
  }

  Future<void> _refreshData() async {
    setState(() {
      selectedType = 'All';
      focusDay = DateTime.now();
    });
    await _loadHolidays();
  }

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      title: "Holidays Calendar",
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.all(16.0),
                child: DropdownButton<int>(
                  value: focusDay.month,
                  items: List.generate(12, (index) {
                    return DropdownMenuItem(
                      value: index + 1,
                      child: Text("${index + 1}"),
                    );
                  }),
                  onChanged: (value) async {
                    if (value != null) {
                      setState(() {
                        focusDay = DateTime(focusDay.year, value);
                      });
                      await _loadHolidays();
                    }
                  },
                ),
              ),
              SizedBox(width: 30),
              DropdownButton<String>(
                value: selectedType,
                items: ["All", ...holidays.map((e) => e.type).toSet()].map((
                  type,
                ) {
                  return DropdownMenuItem(value: type, child: Text(type));
                }).toList(),
                onChanged: (value) async {
                  if (value != null) {
                    setState(() {
                      selectedType = value;
                    });
                    await _loadHolidays();
                  }
                },
              ),
              if (selectedType != 'All')
                IconButton(
                  onPressed: _refreshData,
                  icon: const Icon(Icons.close),
                  tooltip: "Clear filter",
                ),
              IconButton(
                onPressed: _refreshData,
                icon: const Icon(Icons.refresh),
                tooltip: "Refresh Data",
              ),
            ],
          ),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : GestureDetector(
                    onTap: () => _loadHolidays(),
                    child: TableCalendar(
                      focusedDay: focusDay,
                      firstDay: DateTime.utc(2020, 1, 1),
                      lastDay: DateTime.utc(2030, 12, 31),
                      calendarFormat: CalendarFormat.month,
                      availableCalendarFormats: const {
                        CalendarFormat.month: 'Month',
                      },
                      selectedDayPredicate: (day) =>
                          isSameDay(selectedDay, day),

                      onDaySelected: (selected, focused) {
                        setState(() {
                          selectedDay = selected;
                          focusDay = focused;
                        });

                        final holiday = getHolidayByDate(selected);
                        showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: Text(
                              holiday != null ? "🥳 Holiday 🥳" : "No Holiday",
                            ),
                            content: holiday != null
                                ? Text(
                                    "Name: ${holiday.name}\nType: ${holiday.type}",
                                  )
                                : Text("This day is not a holiday."),
                          ),
                        );
                      },

                      holidayPredicate: (day) {
                        return filteredHolidays.any(
                          (h) => isSameDay(DateTime.parse(h.date), day),
                        );
                      },

                      calendarStyle: const CalendarStyle(
                        holidayDecoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.green,
                        ),
                        holidayTextStyle: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
