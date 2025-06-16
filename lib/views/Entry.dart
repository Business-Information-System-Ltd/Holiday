import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: AddHolidayPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class AddHolidayPage extends StatefulWidget {
  @override
  _AddHolidayPageState createState() => _AddHolidayPageState();
}

class _AddHolidayPageState extends State<AddHolidayPage> {
  DateTime? selectedDate;
  String? selectedCountry;
  String? selectedRegion;
  String? selectedType;
  bool repeat = false;
  final _formkey=GlobalKey<FormState>();
  final TextEditingController _nameController=TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  
  var CSCPickerPlus;
  String stateValue = '';
  String? countryValue;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF678B96),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 104, 217, 236),
        title: Center(
          child: Text("Holiday", style: TextStyle(fontSize: 24)),
        ),
        actions: [Icon(Icons.person_outline)],
        leading: Icon(Icons.menu),
        ),

      body: Center(
        child:Form(
          key: _formkey,
        child: Container(
          width: MediaQuery.of(context).size.width / 1.8,
          height: MediaQuery.of(context).size.height /1.5,

          padding: EdgeInsets.all(20),
          margin: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 150, 219, 240),
            borderRadius: BorderRadius.circular(10),
            
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Add New Holiday',
                  style: TextStyle(fontSize: 20, color: Colors.white)),
              SizedBox(height: 30),

              // Date and Country
              Row(
                children: [ 
                  Expanded(
                    
                    child: _buildDateField(),
                    
                    ),
                  SizedBox(width: 20),
                
                  Expanded(
                    child: _buildSelectCountry("Select Country", selectedCountry, (val) {
                    setState(() => selectedCountry = val);

                  
                  })),
                ],
              ),
              SizedBox(height: 30),

              // Name and Region
              Row(
                children: [
                  Expanded(child:
                   _buildTextField("Holiday Name", _nameController)),
                  SizedBox(width: 20),

                  Expanded(
                    child: _buildSelectRegion("Select Region", selectedRegion, (val) {
                    setState(() => selectedRegion = val);
                  })),
                ],
              ),
              SizedBox(height: 30),
               Row(
                children: [
                  Expanded(child: _buildSelectType("Select Type", selectedType, (val) {
                    setState(() => selectedType = val);
                  })),
                  SizedBox(width: 20),
                  Expanded(
                    child: 
                      Row(
                        children: [
                          Text("Repeat:",style: TextStyle(fontWeight: FontWeight.w100,fontSize: 18),),
                          SizedBox(width: 30),
                          Switch(
                            value: repeat,
                            onChanged: (val) => setState(() => repeat = val),
                            activeColor: const Color.fromARGB(255, 20, 85, 82),
                                             ),
                        ],
                      ),
                  ),
                  
                ],
              ),
              SizedBox(height: 30),

              // Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {},
                    child:Text("Cancel"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 91, 231, 208),
                    ),
                  ),
                  SizedBox(width: 80,),
                  ElevatedButton(
                    onPressed: () {},
                    child: Text("Submit"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 91, 231, 208),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      )));
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
           String formattedDate = DateFormat('dd-MM-yyyy').format(picked);  
            setState(() {
              _dateController.text = formattedDate;
            });        //  _dateController.text =
          //               DateFormat('yyyy-MM-dd').format(picked);
        }
      },
      // decoration: InputDecoration(
      //   labelText: 'Select Date',
      //   filled: true,
      //   fillColor: Colors.white,
      //   suffixIcon: Icon(Icons.calendar_today),
      //   border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
      // ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
      ),
    );
  }

  Widget _buildSelectRegion(String label, String? value, ValueChanged<String?> onChanged) {
     return TextFormField(
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
      ),
    );
  }

  Widget _buildSelectCountry(String label, String? value, ValueChanged<String?> onChanged) {
    return DropdownButtonFormField<String>(
      value: value,
      items: ['Myanmar','English','China','Thailand','Japan','Korean']
          .map((item) => DropdownMenuItem(child: Text(item), value: item))
          .toList(),
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
      ),
    );
  }
  Widget _buildSelectType(String label, String? value, ValueChanged<String?> onChanged) {
    return DropdownButtonFormField<String>(
      value: value,
      items: ['Public','Bank','Religious','Observance']
          .map((item) => DropdownMenuItem(child: Text(item), value: item))
          .toList(),
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
      ),
    );
  }}
