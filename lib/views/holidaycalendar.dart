import 'package:flutter/material.dart';
import 'package:holiday/views/Entry.dart';
import 'package:holiday/views/apiservices.dart';
import 'package:holiday/views/appbar.dart';
import 'package:holiday/views/data.dart';
import 'package:holiday/views/tablelist.dart';
import 'package:intl/intl.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:table_calendar/table_calendar.dart';

class HolidayCalendar extends StatefulWidget {
    final dynamic userData;
   const HolidayCalendar({super.key, required  this.userData});

  @override
  State<HolidayCalendar> createState() => HolidayCalendarState();
  
}

class HolidayCalendarState extends State<HolidayCalendar> {
  List<Holiday> holidays = [];
  String selectedType = 'All';
  
  DateTime focusDay = DateTime(DateTime.now().year, DateTime.now().month);
  DateTime? selectedDay;
   List<PlutoRow> rows = [];
  bool isLoading = false;
  List<Country> countries = [];
  PlutoGridStateManager? stateManager;
  
  
  
 @override
void initState() {
  super.initState();
  _loadCountries();
  _loadHolidays();
}

Future<void> _loadCountries() async {
  try {
    final result = await ApiService().fetchCountry();
    setState(() {
      countries = result;
    });
  } catch (e) {
    print('Failed to load countries: $e');
  }
}
  void _showEditDialog(BuildContext context, Holiday holiday) {
  final TextEditingController nameController =
      TextEditingController(text: holiday.name);
  final typeOptions = ['Public', 'Bank', 'Religious', 'Observance'];
  String selectedType = holiday.type;

  final TextEditingController regionController =
      TextEditingController(text: holiday.region);
   int? selectedCountryCode = holiday.countryId;
   String selectedCountryName = countries
    .firstWhere((c) => c.id == selectedCountryCode,
        orElse: () => Country(id: -1, countryCode: '', countryName: ''))
    .countryName;
   DateTime selectedDate = DateTime.tryParse(holiday.date) ?? DateTime.now();

   bool isRecurring = holiday.recurring;

showDialog(
  context: context,
  builder: (context) {
    return Dialog(
      backgroundColor: const Color(0xFF9BE2F3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Container(
          width: MediaQuery.of(context).size.width / 2.9,
          height: MediaQuery.of(context).size.height / 1.5,
          child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setModalState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Edit Holiday",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: 'Holiday Name',
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 15,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),
                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () async {
                            final picked = await showDatePicker(
                              context: context,
                              initialDate: selectedDate,
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2100),
                            );
                            if (picked != null) {
                              setModalState(() {
                                selectedDate = picked;
                              });
                            }
                          },
                          child: InputDecorator(
                            decoration: InputDecoration(
                              labelText: 'Select Date',
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 15,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "${selectedDate.toLocal()}".split(' ')[0],
                                  style: const TextStyle(fontSize: 16),
                                ),
                                const Icon(Icons.calendar_today),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: selectedType,
                          items: typeOptions.map((type) {
                            return DropdownMenuItem(
                              value: type,
                              child: Text(type),
                            );
                          }).toList(),
                          onChanged: (value) {
                            if (value != null) {
                              setModalState(() {
                                selectedType = value;
                              });
                            }
                          },
                          decoration: InputDecoration(
                            labelText: 'Select Type',
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 15,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<int>(
                          value: selectedCountryCode,
                          items: countries
                              .map((country) => DropdownMenuItem<int>(
                                    value: country.id,
                                    child: Text(country.countryName),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            if (value != null) {
                              setModalState(() {
                                selectedCountryCode = value;
                              });
                            }
                          },
                          decoration: InputDecoration(
                            labelText: 'Select Country',
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 15,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: TextField(
                          controller: regionController,
                          decoration: InputDecoration(
                            labelText: 'Region',
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 15,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Repeat:", style: TextStyle(fontSize: 16)),
                      const SizedBox(width: 10),
                      Switch(
                        value: isRecurring,
                        onChanged: (value) {
                          setModalState(() {
                            isRecurring = value;
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.purple,
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text("Cancel"),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.purple,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        onPressed: () async {
                          final updatedHoliday = Holiday(
                            id: holiday.id,
                            name: nameController.text,
                            type: selectedType,
                            region: regionController.text,
                            countryId: selectedCountryCode,
                            country: countries.firstWhere((c) => c.id == selectedCountryCode).countryName,
                            date: DateFormat('yyyy-MM-dd').format(selectedDate),
                            recurring: isRecurring,
                            createdBy: holiday.createdBy,
                            createdAt: holiday.createdAt,
                            updatedAt: DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),
                          );
                          try {
                            final result = await ApiService().updateHoliday(updatedHoliday);
                            setState(() {
                              final index = holidays.indexWhere((h) => h.id == holiday.id);
                              if (index != -1) {
                                holidays[index] = updatedHoliday;
                              }
                            });
                            Navigator.pop(context);
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context)=>Tablelist(userData: null,))
                              );
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Failed to update: $e')),
                            );
                          }
                        },
                        child: const Text("Submit"),
                      ),
                      ],
                    ),
                  ],
                );
            },
            ),
          ),
      )
        );
      },
    );
  }


  Future<void> _loadHolidays() async {
    setState(() => isLoading = true);
    try {
      final holidayList = await ApiService().fetchHolidays(focusDay.year);
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
                    List<String> monthNames = [
                    'January', 'February', 'March', 'April', 'May', 'June',
                    'July', 'August', 'September', 'October', 'November', 'December'
                  ];
                    return DropdownMenuItem(
                      value: index + 1,
                      child: Text(monthNames[index]),
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

                      onDaySelected: (selected, focused) async {
                        setState(() {
                          selectedDay = selected;
                          focusDay = focused;
                        });

                        final holiday = getHolidayByDate(selected);
                       await Future.delayed(const Duration(milliseconds: 150));
                       if (holiday !=null){
                         showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: Text("Holiday"),
                          content: Text("Name: ${holiday.name}\nType: ${holiday.type}"),
                          actions: [
                            TextButton(
                              onPressed: (){
                                Navigator.pop(context);
                              }, 
                              child: Text("Cancle"),
                              ),
                            TextButton(    
                               onPressed: (){
                                Navigator.pop(context);
                               if (countries.isEmpty) {
                               ScaffoldMessenger.of(context).showSnackBar(
                               SnackBar(content: Text('Countries are not loaded yet!')),
                              );
                            return;
                            }
                            _showEditDialog(context, holiday);
                         },
                             child: Text("Edit"))
                         ],
                        )                                    
                     );
                       }else{
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: Text(
                           "No Holiday",
                          ),
                          content: holiday != null
                              ? Text(
                                  "Name: ${holiday.name}\nType: ${holiday.type}",
                                )
                              : Text("Do you want to add new holiday for this day?"),
                          actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text("Cancel"),
                                  ),
                               
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context); 
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => AddHolidayPage( selectedHoliday: holiday,selectedDate: selectedDay ?? DateTime.now()),                             ),
                                      );
                                    },
                                    child: Text("Ok"),
                                  ),
                                ],
                        ),
                      );}
                    },
                    holidayPredicate: (day) {
                      return filteredHolidays.any(
                        (h) => isSameDay(DateTime.parse(h.date), day),
                      );
                    },
                      calendarBuilders: CalendarBuilders(
                      defaultBuilder: (context, day, focusedDay) {
                        
                        if (day.weekday == DateTime.saturday || day.weekday == DateTime.sunday) { 
                          return GestureDetector(
                          onTap: () {
                            if (day.weekday == DateTime.saturday) {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text("Holiday"),
                                  content: Text("Saturday is a holiday!"),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: Text("OK"),
                                    ),
                                  ],
                                ),
                              );
                            }else{
                              if (day.weekday == DateTime.sunday) {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text("Holiday"),
                                  content: Text("Sunday is a holiday!"),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: Text("OK"),
                                    ),
                                  ],
                                ),
                              );
                            }
                           }
                          },
                          child: Container(                           
                            margin: const EdgeInsets.all(6.0),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 5, 76, 88),
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                               '${day.day}',
                               style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                          ));
                        }
                        return null; 
                        
                      },
                      holidayBuilder: (context, day, focusedDay) {
                        return Container(
                          margin: const EdgeInsets.all(6.0),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 21, 187, 30),
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            '${day.day}',
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                        );
                      },
                      )
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}



