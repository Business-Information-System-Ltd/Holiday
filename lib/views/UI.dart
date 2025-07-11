import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

void main(){
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home:const Login(),
    );
  }
}
class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formkey = GlobalKey<FormState>();
  final TextEditingController _nameController=TextEditingController();
  final TextEditingController _passwordController=TextEditingController();
  String? selectedRole;
  String stateValue = '';
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:  const Color.fromARGB(255, 218, 240, 247),
      appBar: AppBar(
       backgroundColor:  const Color.fromARGB(255, 104, 217, 236),
       title: Center(child: Text('Holiday'),),
      ),
      body: Center(
        child: Form(
          key: _formkey,
          child: Container(
            width: MediaQuery.of(context).size.width / 2.5,
            height: MediaQuery.of(context).size.height / 1.5,

            padding: EdgeInsets.all(20),
            margin: EdgeInsets.all(16),
            decoration: BoxDecoration( 
              color: Color.fromARGB(255, 150, 219, 240),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children:[
                Text(
                  'Login',
                  style: TextStyle(fontSize: 20,color: Colors.white),
                ),
                 SizedBox(height:30),
                 _buildNameTextField(
                  "Username",
                   _nameController,
                ),
                SizedBox(height: 30),
                _buildPasswordField(
                  "Password",
                  _passwordController,
                  _obscureText,
                  () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                ),
                SizedBox(height:30),   
                _buildSelectRoleField(
                  'Role',
                  selectedRole,
                  (val) {
                    setState(() {
                      selectedRole = val!;
                    });
                  },
                ),
                SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {
                    if (_formkey.currentState!.validate()) {
                      debugPrint('Form submitted successfully');
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 218, 237, 247),
                  ),
                  child: Text("Login"),
                ),

                 ], 
                ),

            
            ),
    )));
  }
}
Widget _buildNameTextField(String label,TextEditingController controller){
  return TextFormField(
    controller: controller,
    decoration: InputDecoration(
      labelText: label,
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
    ),
    validator: (value){
      if(value==null || value.isEmpty){
         return 'Please enter username';
        }
        return null;
      },
    );
  }
   

Widget _buildPasswordField(String label, TextEditingController controller, bool obscureText, VoidCallback toggleObscureText) {
  return TextFormField(
    controller: controller,
    obscureText: obscureText,
    decoration: InputDecoration(
      labelText: label,
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
      suffixIcon: IconButton(
        icon: Icon(
          obscureText ? Icons.visibility_off : Icons.visibility,
        ),
        onPressed: toggleObscureText,
      ),
    ),
    validator: (value) {
      if (value == null || value.isEmpty) {
        return 'Please filled your password';
      }
      return null;
    },
  );
}
Widget _buildSelectRoleField(String label, String? value, ValueChanged<String?> onChanged){
  return DropdownButtonFormField<String>(
      value: value,
      items: ['Admin','Staff','Manager']
          .map((item) => DropdownMenuItem(child: Text(item), value: item))
          .toList(),
      onChanged: (val) {
        // setState(() => selectedRole = val);
        debugPrint('Selected Role: $val');
     
       },
        decoration: InputDecoration(
        labelText: label,
        filled: true, 
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select role';
        }
        return null;
      },
    );
  }
   
  
