import 'package:flutter/material.dart';
import 'package:holiday/views/apiservices.dart';
import 'package:holiday/views/data.dart';
import 'package:pluto_grid/pluto_grid.dart';

void main(){
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const _PLutoGridState(),
    );
  }
}
class _PLutoGridState extends StatefulWidget {
  const _PLutoGridState({Key? key}) : super(key: key);

  @override
  State<_PLutoGridState> createState() => __PLutoGridStateState();
}

class __PLutoGridStateState extends State<_PLutoGridState> {
    late List<PlutoColumn> columns;
    late List<PlutoRow> rows;
    List<Holiday> holidays=[];
      PlutoGridStateManager? stateManager;
   @override
   void initState() {
   super.initState(); 
    initColumn();
   fetchData();
  
   }

   void initColumn(){
    columns=[
      PlutoColumn(
      title: 'Name', 
      field: 'name', 
      type: PlutoColumnType.text(),
      ),
      PlutoColumn(
        title: 'Date', 
        field: 'date', 
        type: PlutoColumnType.date()
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
        ),
      PlutoColumn(
        title: 'Region', 
        field: 'region', 
        type: PlutoColumnType.text(),
        ),
      PlutoColumn(
        title: 'Repeat', 
        field: 'repeat', 
        type: PlutoColumnType.text(),
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
          // titleTextAlign: PlutoColumnTextAlign.center,
          renderer: (rendererContext) {
            return Row(
              // mainAxisAlignment: MainAxisAlignment.center,
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(Icons.edit, color: Colors.blue),
                  onPressed: () {
                    final row = rendererContext.row;
                    print("Edit ${row.cells['name']?.value}");
                  },
                ),
                // IconButton(
                //   icon: Icon(Icons.delete, color: Colors.blue),
                //   onPressed: () {
                //     final row = rendererContext.row;
                //     print("Delete ${row.cells['name']?.value}");
                //     rendererContext.stateManager.removeRows([row]);
                //   },
                // ),
                IconButton(
  icon: Icon(Icons.delete, color: Colors.blue),
  onPressed: () async {
    final row = rendererContext.row;
    final int id = row.cells['id']!.value;

    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Confirm Delete"),
        content: Text("Are you sure you want to delete this item?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: Text("Cancel")),
          TextButton(onPressed: () => Navigator.pop(context, true), child: Text("Delete")),
        ],
      ),
    );

   if (confirm == true) {
  bool success = await ApiService().;
      if (success) {
        rendererContext.stateManager.removeRows([row]);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Deleted")));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Delete failed")));
      }
    }
  },
),

              ],
            );
          },
        ),
    ];
   }
  //  late  PlutoGridStateManager stateManager;
    // Future<void>fetchData()async{
    //   final response=await http.get(Uri.parse('http://localhost:3000/holidays/'));
    //   if(response.statusCode==200){
    //      List<dynamic>jsondata=json.decode(response.body);
    //      setState(() {
    //      rows=jsondata.map((holiday){
    //       return PlutoRow(
    //         cells: {
              // 'name':PlutoCell(value:holiday['name']),
              // 'date':PlutoCell(value:holiday['date']),
              // 'type':PlutoCell(value:holiday['type']),
              // 'country':PlutoCell(value: holiday['country']),
              // 'region':PlutoCell(value: holiday['region']),
              // 'repeat':PlutoCell(value: holiday['repeat']),
              // 'actions': PlutoCell(value: holiday['actions'] ?? ''),
    //         },);
    //      }).toList();
    //      });
    //   }else{
    //     print('Reguest failed:${response.statusCode}');
    //   }
    //   }
    void fetchData() async{
      List<Holiday> holiday = await ApiService().fetchHolidays();
      setState(() {
        holidays=holiday;
        rows= holiday.map((h){
          return PlutoRow(
            cells: {
              'id':PlutoCell(value: h.id),
              'name':PlutoCell(value:h.name),
              'date':PlutoCell(value:h.date),
              'type':PlutoCell(value:h.type),
              'country':PlutoCell(value: h.countryCode),
              'region':PlutoCell(value: h.region),
              'repeat':PlutoCell(value: h.recurring.toString()),
              'actions': PlutoCell(value:''),
            }
            
            );
        }).toList();
      });
    }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center( 
          child:Text("Holiday List"),),),
          body: Container(
          padding: const EdgeInsets.all(15),
          child:SizedBox(
          height: MediaQuery.of(context).size.height,
          child: PlutoGrid(
          columns: columns,
           rows: rows,
          // columnGroups: columnGroups,
          onLoaded: (PlutoGridOnLoadedEvent event) {
            stateManager = event.stateManager;
            // stateManager.setShowColumnFilter(true);
          },
          onChanged: (PlutoGridOnChangedEvent event) {
            print(event);
          },
          configuration: const PlutoGridConfiguration(),
                  ),
                )
            ));}}