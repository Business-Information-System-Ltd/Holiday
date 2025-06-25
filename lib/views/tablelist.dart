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
  List<PlutoRow> rows = [];
  List<PlutoRow> filteredRows = [];
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
    _loadHolidays();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    try {
      countries = await ApiService().fetchCountry();
      await _loadHolidays();
    } catch (e) {
      print("Error loading initial data: $e");
    } finally {
      setState(() => isLoading = false);
    }
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

      PlutoColumn(
        title: 'Type', 
        field: 'type',
        type: PlutoColumnType.text(),
      ),
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
              height: MediaQuery.of(context).size.height / 2,
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
                        onPressed: () async {
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
                            // ignore: unused_local_variable
                            final result = await ApiService().updateHoliday(
                              updatedHoliday,
                            );

                            setState(() {
                              row.cells['name']!.value = nameController.text;
                              row.cells['type']!.value = selectedType;
                              row.cells['country']!.value = selectedCountryCode;
                              row.cells['region']!.value =
                                  regionController.text;
                              row.cells['date']!.value = selectedDate
                                  ?.toIso8601String()
                                  .split('T')[0];
                              row.cells['repeat']!.value = isRecurring
                                  .toString();

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
              style: TextButton.styleFrom(foregroundColor: Colors.blue),
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () async {
                try {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) =>
                        const Center(child: CircularProgressIndicator()),
                  );

                  await deleteHoliday(row.cells['id']!.value.toString());

                  stateManager?.removeRows([row]);

                  Navigator.pop(context);
                  Navigator.pop(context);

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        '${row.cells['name']?.value} deleted successfully',
                      ),
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
              child: const Text(
                'Delete',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> deleteHoliday(String id) async {
    await ApiService().deleteHoliday(id);
  }

  Future<void> _loadHolidays() async {
    try {
      final holidayList = await ApiService().fetchHolidays();
      setState(() {
        holidays = holidayList;
        rows = holidayList.map((holiday) {
          final dateString = holiday.date;
          final formattedDate = dateString.contains('T')
              ? dateString.split('T')[0]
              : dateString;
          return PlutoRow(
            cells: {
              'id': PlutoCell(value: holiday.id),
              'date': PlutoCell(value: formattedDate),
              'name': PlutoCell(value: holiday.name),

              'type': PlutoCell(value: holiday.type),
              'country': PlutoCell(value: holiday.countryCode),
              'region': PlutoCell(value: holiday.region ?? ''),

              'repeat': PlutoCell(value: holiday.recurring.toString()),
              'actions': PlutoCell(value: ''),
            },
          );
        }).toList();
        print("Holidays fetched: ${holidayList.length}");
        filteredRows = List.from(rows);
      });
    } catch (e) {
      print("Error loading holidays: $e");
    }
  }

  void _searchData(String query) {
    if (stateManager == null) return;

    stateManager!.setFilter((row) {
      if (query.isEmpty) return true;

      final lowerQuery = query.toLowerCase();
      return row.cells['name']!.value.toString().toLowerCase().contains(
            lowerQuery,
          ) ||
          row.cells['type']!.value.toString().toLowerCase().contains(
            lowerQuery,
          ) ||
          row.cells['country']!.value.toString().toLowerCase().contains(
            lowerQuery,
          ) ||
          row.cells['region']!.value.toString().toLowerCase().contains(
            lowerQuery,
          ) ||
          row.cells['date']!.value.toString().toLowerCase().contains(
            lowerQuery,
          ) ||
          row.cells['repeat']!.value.toString().toLowerCase().contains(
            lowerQuery,
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    _context = context;

    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    }
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
                decoration: BoxDecoration(
                  border: Border.all(
                    color: const Color.fromARGB(255, 14, 12, 12),
                  ),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Row(
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
                        decoration: const InputDecoration(
                          hintText: "Search",
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(8.0),
                          isCollapsed: true,
                        ),
                        style: const TextStyle(color: Colors.black),
                        onSubmitted: (value) {
                          _searchData(value);
                        },
                      ),
                    ),
                    if (_searchController.text.isNotEmpty)
                      IconButton(
                        icon: const Icon(
                          Icons.clear,
                          color: Colors.black54,
                          size: 20,
                        ),
                        onPressed: () {
                          _searchController.clear();
                          _searchData('');
                        },
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
                    rows: filteredRows,
                    onLoaded: (PlutoGridOnLoadedEvent event) {
                      stateManager = event.stateManager;
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
