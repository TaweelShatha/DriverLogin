// ignore_for_file: prefer_const_constructors, use_build_context_synchronously, avoid_print, sort_child_properties_last, unused_element, use_key_in_widget_constructors, prefer_const_constructors_in_immutables, deprecated_member_use

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:log/Home.dart';
import 'package:log/restpass.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(Driver());
}

class Driver extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
        home: SplashScreen(), 
      routes: {
        '/login': (context) => LoginPage(),
      },
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late final TextEditingController _usernameController, _passwordController;
  late final GlobalKey<FormState> _formKey;
  late FocusNode _usernameFocusNode, _passwordFocusNode;
  bool visibility = false;
  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();
    _usernameController = TextEditingController();
    _passwordController = TextEditingController();
    _usernameFocusNode = FocusNode();
    _passwordFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void login(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      void saveTokenToPreferences(String token) async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('jwtToken', token);
      }

      Future<String?> getTokenFromPreferences() async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        return prefs.getString('jwtToken');
      }

      Future<void> checkTokenSaved() async {
        String? savedToken = await getTokenFromPreferences();

        if (savedToken != null) {
          print('Token is saved on the device: $savedToken');
        } else {
          print('Token is not saved on the device.');
        }
      }

      final Uri apiUrl = Uri.parse(
          'https://671b-185-88-83-143.ngrok-free.app/api/auth/driverLogin');

      try {
        final response = await http.post(
          apiUrl,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'username': _usernameController.text,
            'password': _passwordController.text
          }),
        );

        final Map<String, dynamic> responseData = json.decode(response.body);

        if (response.statusCode == 200 &&
            responseData.containsKey('jwtToken')) {
          String token = responseData['jwtToken'];
          print('Token: $token');
          saveTokenToPreferences(token);
          checkTokenSaved();

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Home(token),
            ),
          );
        } else {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Invalid Credentials'),
                content: Text('Please check your username and password.'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('OK'),
                  ),
                ],
              );
            },
          );
        }
      } catch (error) {
        print('Error: $error');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.lightBlue,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 150),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/whitelogo.png',
                        height: 200.0,
                      ),
                      SizedBox(height: 25),
                      TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please Enter Username';
                          } else {
                            return null;
                          }
                        },
                        onEditingComplete: () {
                          _usernameFocusNode.unfocus();
                          FocusScope.of(context)
                              .requestFocus(_passwordFocusNode);
                        },
                        textInputAction: TextInputAction.next,
                        focusNode: _usernameFocusNode,
                        controller: _usernameController,
                        decoration: InputDecoration(
                          labelText: 'Username',
                          hintText: 'Enter your username',
                          filled: true,
                          fillColor: Colors.white,
                          prefixIcon: Icon(
                            Icons.person,
                            size: 30,
                          ),
                          prefixIconColor: Colors.blue,
                        ),
                      ),
                      SizedBox(height: 16.0),
                      TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter your password";
                          } else if (value.length < 6) {
                            return 'Password must be at least 6 characters';
                          } else {
                            return null;
                          }
                        },
                        onEditingComplete: () {
                          _passwordFocusNode.unfocus();
                          login(context);
                        },
                        focusNode: _passwordFocusNode,
                        keyboardType: TextInputType.visiblePassword,
                        controller: _passwordController,
                        obscureText: !visibility,
                        decoration: InputDecoration(
                          hintText: 'Enter your password',
                          filled: true,
                          fillColor: Colors.white,
                          prefixIcon: const Icon(
                            Icons.lock,
                            size: 30,
                          ),
                          prefixIconColor: Colors.blue,
                          suffixIcon: InkWell(
                            onTap: () {
                              setState(
                                () {
                                  visibility = !visibility;
                                },
                              );
                            },
                            child: Icon(
                              visibility == true
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 24.0),
                      ElevatedButton(
                        onPressed: () {
                          login(context);
                        },
                        child: Text(
                          'Sign In',
                          style: TextStyle(color: Colors.black),
                        ),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.white,
                        ),
                      ),
                      SizedBox(height: 8.0),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ResetPassword()),
                          );
                        },
                        child: Text('Forgot Password?'),
                        style: TextButton.styleFrom(
                          primary: Colors.white,
                        ),
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              FadeTransition(
            opacity: animation,
            child: LoginPage(),
          ),
        ),
      );
    });

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 15, 152, 248),
      body: Center(
        child: Image.asset('assets/logo.png'),
      ),
    );
  }
}
