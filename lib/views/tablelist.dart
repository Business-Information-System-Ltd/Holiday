import 'package:flutter/material.dart';
import 'package:holiday/views/apiservices.dart';
import 'package:holiday/views/appbar.dart';
import 'package:holiday/views/data.dart';
import 'package:pluto_grid/pluto_grid.dart';

class Tablelist extends StatefulWidget {
  const Tablelist({Key? key}) : super(key: key);

  @override
  State<Tablelist> createState() => TablelistState();
}

class TablelistState extends State<Tablelist> {
  TextEditingController _searchController = TextEditingController();
  late List<PlutoColumn> columns;
  late List<PlutoRow> rows;
  List<Holiday> holidays = [];
  List<Holiday> filterData = [];
  List<Country> countries = [];

  bool isLoading = true;
  late BuildContext _context;
  PlutoGridStateManager? stateManager;
  @override
  void initState() {
    super.initState();
    initColumn();
    fetchData();
  }

  void initColumn() {
    columns = [
      PlutoColumn(
  title: 'ID',
  field: 'id',
  type: PlutoColumnType.text(),
  hide: true,
),

      PlutoColumn(
        title: 'Date',
        field: 'date',
        type: PlutoColumnType.date(),
        width: 150,
      ),
      PlutoColumn(
        title: 'Name',
        field: 'name',
        type: PlutoColumnType.text(),
        width: 500,
      ),

      PlutoColumn(title: 'Type', field: 'type', type: PlutoColumnType.text()),
      PlutoColumn(
        title: 'Country',
        field: 'country',
        type: PlutoColumnType.text(),
        width: 200,
      ),
      PlutoColumn(
        title: 'Region',
        field: 'region',
        type: PlutoColumnType.text(),
        width: 150,
      ),
      PlutoColumn(
        title: 'Repeat',
        field: 'repeat',
        type: PlutoColumnType.text(),
        width: 150,
      ),
      PlutoColumn(
        title: 'Actions',
        field: 'actions',
        type: PlutoColumnType.text(),
        enableColumnDrag: false,
        enableSorting: false,
        enableContextMenu: false,
        enableDropToResize: false,
        textAlign: PlutoColumnTextAlign.center,
        renderer: (rendererContext) {
          return Row(
            children: [
              IconButton(
                icon: Icon(Icons.edit, color: Colors.blue),
                onPressed: () {
                  final row = rendererContext.row;
                  _showEditDialog(row);
                  print("Edit ${row.cells['name']?.value}");
                },
              ),
              SizedBox(width: 20),
              IconButton(
                icon: Icon(Icons.delete, color: Colors.blue),
                onPressed: () {
                  final row = rendererContext.row;
                  _showDeleteDialog(row);
                  print("Delete ${row.cells['name']?.value}");
                  rendererContext.stateManager.removeRows([row]);
                },
              ),
            ],
          );
        },
      ),
    ];
  }
//Edit
  void _showEditDialog(PlutoRow row) {
    final TextEditingController nameController = TextEditingController(
      text: row.cells['name']!.value,
    );
    final typeOptions = ['Public', 'National', 'Religious', 'Optional'];
    String selectedType = row.cells['type']!.value;

    final TextEditingController regionController = TextEditingController(
      text: row.cells['region']!.value,
    );
    String selectedCountryCode = row.cells['country']!.value;
    DateTime? selectedDate =
        DateTime.tryParse(row.cells['date']!.value) ?? DateTime.now();
    bool isRecurring = row.cells['repeat']!.value.toLowerCase() == 'true';

    showDialog(
      context: _context,
      builder: (context) {
        return Dialog(
          backgroundColor: const Color(0xFF9BE2F3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Container(
              width: MediaQuery.of(context).size.width / 3,
              height: MediaQuery.of(context).size.height /2,
              child: Column(
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
                              selectedDate = picked;
                              (context as Element).markNeedsBuild();
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
                                  "${selectedDate?.toLocal()}".split(' ')[0],
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
                            if (value != null) selectedType = value;
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
                        child: DropdownButtonFormField<String>(
                          value: selectedCountryCode,
                          items: countries.map((country) {
                            return DropdownMenuItem(
                              value: country.countryCode,
                              child: Text(country.countryName),
                            );
                          }).toList(),
                          onChanged: (value) {
                            if (value != null) selectedCountryCode = value;
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
                          isRecurring = value;
                          (context as Element).markNeedsBuild();
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
                        onPressed: () async{
                           final updatedHoliday = Holiday(
                          id: row.cells['id']!.value,
                          name: nameController.text,
                          type: selectedType,
                          region: regionController.text,
                          countryCode: selectedCountryCode,
                          date: selectedDate.toString(),
                          recurring: isRecurring,
                           createdAt: '', 
                           updatedAt: '',
                        );
                        try {
                          final result = await ApiService().updateHoliday(updatedHoliday);
                          
                          setState(() {
                            row.cells['name']!.value = nameController.text;
                            row.cells['type']!.value = selectedType;
                            row.cells['country']!.value = selectedCountryCode;
                            row.cells['region']!.value = regionController.text;
                            row.cells['date']!.value = selectedDate
                                ?.toIso8601String()
                                .split('T')[0];
                            row.cells['repeat']!.value = isRecurring.toString();

                            stateManager?.notifyListeners();
                          });

                           Navigator.pop(context);
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
              ),
            ),
          ),
        );
      },
    );
  }
//Search
  void _searchData(String query) {
    setState(() {
      if (query.isEmpty) {
        filterData = List.from(holidays);
      } else {
        filterData = holidays.where((data) {
          final date = data.date.toLowerCase();
          final name = data.name.toLowerCase();
          final type = data.type.toLowerCase();
          final country = data.countryCode.toString().toLowerCase();
          final region = (data.region ?? '').toLowerCase();
          final repeat = data.recurring.toString().toLowerCase();
          final searchLower = query.toLowerCase();

          return date.contains(searchLower) ||
              name.contains(searchLower) ||
              type.contains(searchLower) ||
              country.contains(searchLower) ||
              region.contains(searchLower) ||
              repeat.contains(searchLower);
        }).toList();
      }
      rows = filterData.map((h) {
        return PlutoRow(
          cells: {
            'id': PlutoCell(value: h.id),

            'date': PlutoCell(value: h.date),
            'name': PlutoCell(value: h.name),
            'type': PlutoCell(value: h.type),
            'country': PlutoCell(value: h.countryCode),
            'region': PlutoCell(value: h.region ?? ''),
            'repeat': PlutoCell(value: h.recurring.toString()),
            'actions': PlutoCell(value: ''),
          },
        );
      }).toList();
    });
  }

  Future<void> fetchData() async {
    try {
      List<Holiday> holiday = await ApiService().fetchHolidays();
      setState(() {
        holidays = holiday;
        filterData = List.from(holidays);
        rows = filterData
            .map(
              (h) => PlutoRow(
                cells: {
                  'id': PlutoCell(value: h.id),

                  'date': PlutoCell(value: h.date),
                  'name': PlutoCell(value: h.name),
                  'type': PlutoCell(value: h.type),
                  'country': PlutoCell(value: h.countryCode),
                  'region': PlutoCell(value: h.region ?? ''),
                  'repeat': PlutoCell(value: h.recurring.toString()),
                  'actions': PlutoCell(value: ''),
                },
              ),
            )
            .toList();
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching data: $e');
      
    }
  }


// Delete
void _showDeleteDialog(PlutoRow row) {
  showDialog(
    context: _context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: const Color.fromARGB(255, 93, 96, 98),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text(
          "Confirm Delete",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        content: Text(
          "Are you sure you want to delete?",
          style: const TextStyle(color: Colors.white),
          
        ),
        actions: [
          TextButton(
          style: TextButton.styleFrom(
            foregroundColor: Colors.blue,
          ),
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
            
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            onPressed: () async {
              try {
                
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) => const Center(
                    child: CircularProgressIndicator(),
                  ),
                );
                
                await deleteHoliday(row.cells['id']!.value.toString());
                
                stateManager?.removeRows([row]);
                
                
               Navigator.pop(context);
                Navigator.pop(context); 
                
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${row.cells['name']?.value} deleted successfully'),
                    backgroundColor: const Color.fromARGB(255, 241, 245, 241),
                  ),
                );
              } catch (e) {
                Navigator.pop(context); // 
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Failed to delete: $e'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      );
    },
  );
}

// Add this method to call the API service for deleting a holiday
Future<void> deleteHoliday(String id) async {
  await ApiService().deleteHoliday(id);
}


  @override
  Widget build(BuildContext context) {
    _context = context;
    return MainScaffold(
      title: "Holidays List",
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.4,
                height: 50,
                // padding: const EdgeInsets.symmetric(horizontal: 8.0),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: const Color.fromARGB(255, 14, 12, 12),
                  ),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Row(
                  //mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.search, color: Colors.black),
                      onPressed: () {
                        _searchData(_searchController.text);
                      },
                    ),
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        onChanged: _searchData,
                        textAlign: TextAlign.start,
                        decoration: const InputDecoration(
                          hintText: "Search",
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(8.0),
                          isCollapsed: true,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: PlutoGrid(
                    columns: columns,
                    rows: rows,
                    onLoaded: (PlutoGridOnLoadedEvent event) {
                      stateManager = event.stateManager;
                      if (rows.isEmpty) {
                        fetchData();
                      }
                    },
                    onChanged: (PlutoGridOnChangedEvent event) {
                      print(event);
                    },
                    configuration: const PlutoGridConfiguration(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
