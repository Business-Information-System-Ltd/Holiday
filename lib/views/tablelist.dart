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
  bool isLoading = true;
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
                  print("Edit ${row.cells['name']?.value}");
                },
              ),
              SizedBox(width: 20,),
              IconButton(
                icon: Icon(Icons.delete, color: Colors.blue),
                onPressed: () {
                  final row = rendererContext.row;
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
      // Optionally show error to user
    }
  }

  @override
  Widget build(BuildContext context) {
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
