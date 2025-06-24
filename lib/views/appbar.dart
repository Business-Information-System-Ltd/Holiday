import 'package:flutter/material.dart';
import 'package:holiday/views/Entry.dart';
import 'package:holiday/views/tablelist.dart';

class MainScaffold extends StatelessWidget {
  final String title;
  final Widget body;

  const MainScaffold({super.key, required this.title, required this.body});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 238, 239, 240),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 104, 217, 236),
        title: Center(child: Text(title, style: const TextStyle(fontSize: 24),)),
      ),
      drawer: Container(
        width: MediaQuery.of(context).size.width * 0.2, 
        child: Drawer(
          backgroundColor: Colors.blueGrey,
          child: ListView(
            padding: const EdgeInsets.all(8.0),
            children: [
              SizedBox(
                height: 80,
                child: const DrawerHeader(
                  child: Center(child: Text('Menu', style: TextStyle(fontSize: 24))),
                ),
              ),
              ListTile(
                leading: Icon(Icons.add),
                title: Text('Add Holiday'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddHolidayPage()),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.table_chart),
                title: Text('Holiday Table'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Tablelist()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      body: body,
    );
  }
}
