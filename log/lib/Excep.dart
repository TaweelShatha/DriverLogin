// excep.dart

// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last, must_be_immutable, library_private_types_in_public_api
import 'package:flutter/material.dart';
import 'package:log/absent.dart';
import 'package:log/exception.dart';

class Excep extends StatefulWidget {
  @override
  _ExcepState createState() => _ExcepState();
}

class _ExcepState extends State<Excep> {
  bool isHelpVisible = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(
              'assets/whitelogo.png',
              height: 30.0,
            ),
          ),
        ],
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          AnimatedContainer(
            duration: Duration(seconds: 2),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.lightBlue, Colors.blue],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Absent()),
                    );
                  },
                  child: AnimatedContainer(
                    duration: Duration(seconds: 1),
                    padding: EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                      gradient: LinearGradient(
                        colors: [Colors.lightBlue, Colors.blue],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Column(
                      children: [
                        Hero(
                          tag: 'absentImage',
                          child: Image.asset(
                            'assets/absent.png',
                            height: 100.0,
                            width: 150.0,
                          ),
                        ),
                        SizedBox(height: 8.0),
                        AnimatedOpacity(
                          duration: Duration(seconds: 1),
                          opacity: 1.0,
                          child: Text(
                            'Request an absent',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(height: 8.0),
                        Icon(
                          Icons.play_arrow,
                          color: Colors.white,
                          size: 30.0,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 16),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ExceptionPage()),
                    );
                  },
                  child: AnimatedContainer(
                    duration: Duration(seconds: 1),
                    padding: EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                      gradient: LinearGradient(
                        colors: [Colors.lightBlue, Colors.blue],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Column(
                      children: [
                        Hero(
                          tag: 'exceptionImage',
                          child: Image.asset(
                            'assets/excep.png',
                            height: 90.0,
                            width: 80.0,
                          ),
                        ),
                        SizedBox(height: 8.0),
                        AnimatedOpacity(
                          duration: Duration(seconds: 1),
                          opacity: 1.0,
                          child: Text(
                            'Request an exception',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(height: 8.0),
                        Icon(
                          Icons.play_arrow,
                          color: Colors.white,
                          size: 30.0,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Help message
          AnimatedPositioned(
            duration: Duration(milliseconds: 300),
            bottom: isHelpVisible ? 16.0 : -150.0,
            right: 60.0,
            child: Container(
              height: 150.0,
              width: 300.0,
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: ListView(
                shrinkWrap: true,
                children: [
                  Text(
                    '● If you want to request an ABSENT day, please choose the "Request an Absent" button and specify a date. It will auto-fill the day, specify the shift you\'re working, and finally submit it to the admin.\n\n'
                    '● For any other request, please choose the "Request an Exception", fill the date, write your request, and submit it to the admin.',
                    style: TextStyle(
                      color: Colors.lightBlue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            isHelpVisible = !isHelpVisible;
          });
        },
        child: Text(
          '?',
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            color: const Color.fromARGB(255, 0, 0, 0),
          ),
        ),
        backgroundColor: Colors.white,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
