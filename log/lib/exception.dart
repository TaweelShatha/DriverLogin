// exception.dart

// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, sort_child_properties_last

// exception.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ExceptionPage extends StatefulWidget {
  @override
  _ExceptionPageState createState() => _ExceptionPageState();
}

class _ExceptionPageState extends State<ExceptionPage> {
  DateTime currentDate = DateTime.now();
  TextEditingController dateController = TextEditingController();
  String autoFillDay = DateFormat('EEEE').format(DateTime.now());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue,
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        title: Text(
          'Request an Exception',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.info),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Information'),
                    content: Text('Provide the details and submit to request an exception.'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text('OK'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey,
                width: 3,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                Text(
                  'Fill in the details below:',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                SizedBox(height: 20),
                _buildDateFormField(),
                SizedBox(height: 16),
                _buildAutoFillDayField(),
                SizedBox(height: 16),
                _buildNoteField(),
                SizedBox(height: 16),
                _buildSubmitButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDateFormField() {
    return TextFormField(
      controller: dateController,
      readOnly: true,
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: currentDate,
          firstDate: DateTime(2000),
          lastDate: DateTime(2101),
        );
        if (pickedDate != null && pickedDate != currentDate) {
          setState(() {
            currentDate = pickedDate;
            dateController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
            autoFillDay = DateFormat('EEEE').format(pickedDate);
          });
        }
      },
      decoration: InputDecoration(
        labelText: 'Date',
        fillColor: Colors.white,
        filled: true,
        prefixIcon: Icon(Icons.calendar_today),
      ),
    );
  }

  Widget _buildAutoFillDayField() {
    return TextFormField(
      initialValue: autoFillDay,
      readOnly: true,
      decoration: InputDecoration(
        labelText: 'Auto Fill Day',
        fillColor: Colors.white,
        filled: true,
        prefixIcon: Icon(Icons.event_available),
      ),
    );
  }

  Widget _buildNoteField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'Note',
        fillColor: Colors.white,
        filled: true,
        prefixIcon: Icon(Icons.note),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return ElevatedButton(
      onPressed: () {
        // Implement submit to admin logic
        // You can add a confirmation dialog or navigate to a confirmation screen
      },
      child: Text('Submit to Admin'),
      style: ElevatedButton.styleFrom(
        textStyle: TextStyle(color: Colors.black),
      ),
    );
  }
}
