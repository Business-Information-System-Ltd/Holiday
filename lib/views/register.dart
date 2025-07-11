import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:holiday/views/apiservices.dart';
import 'package:holiday/views/data.dart';
import 'package:holiday/views/holidaycalendar.dart';
import 'package:holiday/views/login.dart';


class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formkey = GlobalKey<FormState>();
  final TextEditingController _nameController=TextEditingController();
  final TextEditingController _emailController=TextEditingController();
  final TextEditingController _passwordController=TextEditingController();
  String? selectedRole;
  String stateValue = '';
  bool _obscureText = true;
  List<User> user = [];


 void _fetchData() async {
    try {
      
      List<User> users = await ApiService().fetchUser();
      setState(() {
        
        user = users;
      });
    } catch (e) {
      print("Fail to load: $e");
     
    }
  }

  String? passwordValidation(String value) {
    String pattern =
        r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$';
    RegExp regex = RegExp(pattern);
    if (value.isEmpty) {
      return 'Please Enter Your Password';
    } else if (!regex.hasMatch(value)) {
      return 'Your Password must include at least 8 characters.\n The password must also include an uppercase, lowercase letters, number, and special character';
    }
    return null;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:  const Color.fromARGB(255, 218, 240, 247),
      appBar: AppBar(
       backgroundColor:  const Color.fromARGB(255, 104, 217, 236),
       title: Center(child: Text('Holiday'),),
      ),
      body: Center(
        child: Container(
          child: SingleChildScrollView(
            child: Form(
              key: _formkey,
              child: Container(
                width: MediaQuery.of(context).size.width / 2.5,
                height: MediaQuery.of(context).size.height / 1.3,
                      
                padding: EdgeInsets.all(20),
                margin: EdgeInsets.all(16),
                decoration: BoxDecoration( 
                  color: Color.fromARGB(255, 150, 219, 240),
                  borderRadius: BorderRadius.circular(10),
                ),
               
                    child: Column(
                    children: [
                      Text(
                        "Create An Account",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color:Color.fromARGB(255, 18, 16, 16),
                        ),
                      ),
                      const SizedBox(height: 30),
                      _buildNameTextField("Enter Your Name", _nameController, Icons.person),
                      const SizedBox(height: 20),
                      _buildEmailTextField("Enter Your Email", _emailController, Icons.email),
                      const SizedBox(height: 20),
                      
                      const SizedBox(height: 20),
                       _buildSelectRoleField("Select Type", selectedRole, (
                      val,
                    ) {
                      setState(() => selectedRole = val);
                    }),
                      const SizedBox(height: 20),
                      _buildPasswordField(
                        "Enter Your Password",
                        _passwordController,
                        _obscureText,
                        () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                        Icons.key_off_outlined,
                      ),
                      const SizedBox(height: 20),
                      Align(
                          alignment: Alignment.centerLeft,
                          child: TextButton(
                            onPressed: () {
                             Login();
                            },
                            child: Text("Login an Account", style: TextStyle(color: Color.fromARGB(255, 18, 16, 16))),
                          ),
                        ),
                      ElevatedButton(
                       onPressed: _submitForm,
                                  style: ButtonStyle(
                                      shape: WidgetStateProperty.all(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0)),
                                      ),
                                      minimumSize: WidgetStateProperty.all(
                                          const Size(150, 50))),
                                          
                                  child: const Text(
                                    "Submit",
                                    style: TextStyle(
                                        fontFamily: 'Schyler',
                                        color: Colors.black,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                      
                      )
                    ],
                  ),  
                
                ),
              ),
          )),
      ));
  }
  void _submitForm() async {
    if (_formkey.currentState!.validate()) {
      try {
        final selectedrole = selectedRole;
        if (selectedrole == null || selectedrole.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Please select a role")),
          );
          return;
        }

        final userData = {
          'username': _nameController.text,
          'email': _emailController.text,
          'password': _passwordController.text,
          'role': selectedRole,
        };

        await ApiService().registerUser(userData);

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const HolidayCalendar(userData: null,)),
        );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Registration successful!")),
        );
      } catch (e) {
        print("Failed to register user: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Registration failed: ${e.toString()}")),
        );
      }
    }
  }
}
Widget _buildNameTextField(String label,TextEditingController controller, IconData person){
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
   
Widget _buildEmailTextField(String label,TextEditingController controller, IconData email){
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
         return 'Please enter email';
        }
        return null;
      },
    );
  }
Widget _buildPasswordField(String label, TextEditingController controller, bool obscureText, VoidCallback toggleObscureText, IconData key) {
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
      onChanged: onChanged,
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
   
  
