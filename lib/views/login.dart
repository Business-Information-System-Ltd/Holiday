import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:holiday/views/apiservices.dart';
import 'package:holiday/views/holidaycalendar.dart';
import 'package:holiday/views/register.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formkey = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  String? selectedRole;
  bool _isObscured = true;
  bool _isLoading = false;

  final List<String> roles = ['Admin', 'Staff', 'Manager']; 

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 218, 240, 247),
      appBar: AppBar(backgroundColor: const Color.fromARGB(255, 104, 217, 236)),
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
                    const Padding(
                      padding: EdgeInsets.only(top: 50),
                      child: Center(
                        child: Text(
                          "Login An Account",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 18, 16, 16),
                          ),
                        ),
                      ),
                    ),
                    ListTile(
                      leading: const Icon(
                        Icons.email_outlined,
                        color: Colors.black,
                        size: 40,
                      ),
                      title: TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          labelText: "Enter Your Email",
                          labelStyle: TextStyle(
                            color: Color.fromARGB(255, 18, 16, 16),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Color.fromARGB(255, 18, 16, 16),
                            ),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Color.fromARGB(255, 18, 16, 16),
                            ),
                          ),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        autofillHints: [AutofillHints.username],
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Enter Your Email";
                          }
                          return null;
                        },
                      ),
                    ),

                    ListTile(
                      leading: const Icon(
                        Icons.key,
                        color: Colors.black,
                        size: 40,
                      ),
                      title: TextFormField(
                        controller: _passwordController,
                        decoration: InputDecoration(
                          labelText: "Enter Your Password",
                          labelStyle: const TextStyle(
                            color: Color.fromARGB(255, 18, 16, 16),
                          ),
                          enabledBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Color.fromARGB(255, 18, 16, 16),
                            ),
                          ),
                          focusedBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Color.fromARGB(255, 18, 16, 16),
                              width: 2.0,
                            ),
                          ),
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _isObscured = !_isObscured;
                              });
                            },
                            icon: Icon(
                              _isObscured
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Color.fromARGB(255, 18, 16, 16),
                            ),
                          ),
                        ),
                        obscureText: _isObscured,

                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please Enter your Password!!";
                          }
                          return null;
                        },
                      ),
                    ),
                    ListTile(
                                      leading: const Icon(
                                        Icons.layers,
                                        color: Colors.black,
                                        size: 40,
                                      ),
                                      title: DropdownButtonFormField(
                                        value: selectedRole,
                                        decoration: const InputDecoration(
                                            labelText: "Choose Your Role",
                                            labelStyle:
                                                TextStyle(color:Color.fromARGB(255, 18, 16, 16)),
                                            enabledBorder: UnderlineInputBorder(
                                              borderSide:
                                                  BorderSide(color: Color.fromARGB(255, 18, 16, 16)),
                                            ),
                                            focusedBorder: UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Color.fromARGB(255, 18, 16, 16)))),
                                        dropdownColor:Colors.white,
                                        items: roles.map((role) {
                                          return DropdownMenuItem(
                                              value: role, child: Text(role));
                                        }).toList(),
                                        onChanged: (value) {
                                          setState(() {
                                            selectedRole = value;
                                          });
                                        },
                                        icon: const Icon(
                                          Icons.arrow_drop_down,
                                          color: Color.fromARGB(255, 18, 16, 16),
                                          size: 30,
                                        ),
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please select your role!!';
                                          }
                                          return null;
                                        },
                                      )),
                    ListTile(
                      title: const Text(
                        "Create an Account",
                        style: TextStyle(
                          color: Color.fromARGB(255, 18, 16, 16),
                          decoration: TextDecoration.underline,
                          decorationColor: Colors.black,
                          decorationThickness: 2.0,
                        ),
                      ),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const Register(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _loginUser,
                      style: ButtonStyle(
                        shape: WidgetStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        minimumSize: WidgetStateProperty.all(
                          const Size(150, 50),
                        ),
                      ),
                      child: const Text(
                        "Login",
                        style: TextStyle(
                          fontFamily: 'Schyler',
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _loginUser() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    if (_formkey.currentState?.validate() ?? false) {
      if (selectedRole == null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Please select a role")));
        return;
      }
      setState(() {
        _isLoading = true;
      });
      try {
        final apiService = ApiService();
        final userData = await apiService.loginUser(
          email,
          password,
          selectedRole!,
        );

        if (userData != null) {
          final hasFullAccess = userData['role'] == 'Admin';

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HolidayCalendar(userData: userData),
            ),
          );
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text("Login Successfully!!")));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Login failed: Invalid credentials")),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Error: $e")));
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}
