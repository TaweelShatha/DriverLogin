// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, library_private_types_in_public_api, sort_child_properties_last, avoid_print
// absent.dart

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Absent extends StatefulWidget {
  @override
  _AbsentState createState() => _AbsentState();
}

class _AbsentState extends State<Absent> {
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
          'Request an Absent',
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
                    content: Text(
                      'Provide the details and submit to request an absent.',
                    ),
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
                _buildShiftDropdown(),
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

  Widget _buildShiftDropdown() {
    return DropdownButtonFormField<String>(
      value: 'Morning',
      items: ['Morning', 'Evening'].map((shift) {
        return DropdownMenuItem<String>(
          value: shift,
          child: Text(shift),
        );
      }).toList(),
      onChanged: (value) {
        // Handle shift change
      },
      decoration: InputDecoration(
        labelText: 'Shift',
        fillColor: Colors.white,
        filled: true,
        prefixIcon: Icon(Icons.access_time),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return ElevatedButton(
      onPressed: () async {
        await submitRequestToAdmin();
      },
      child: Text('Submit to Admin'),
      style: ElevatedButton.styleFrom(
        textStyle: TextStyle(color: Colors.black),
      ),
    );
  }

  Future<void> submitRequestToAdmin() async {
    try {
      String? jwtToken = await getTokenFromPreferences();

      // Ensure proper padding of the JWT token
      String paddedToken = jwtToken! + '=' * ((4 - jwtToken.length % 4) % 4);

      Map<String, dynamic> decodedToken = json.decode(utf8.decode(
          base64.decode(base64Url.normalize(paddedToken.split('.')[1]))));
      int userId = decodedToken['id']?.toInt() ?? 0;

      Map<String, dynamic> requestBody = {
        "applicationDate": DateFormat('dd-MM-yyyy').format(currentDate),
        "day": autoFillDay,
        "note": _getShift(),
        "notificationType": "Absent",
      };

      // Send HTTP POST request
      Uri apiUrl = Uri.parse(
          'https://671b-185-88-83-143.ngrok-free.app/api/notifications/add/$userId');
      final response = await http.post(
        apiUrl,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        print('Request sent successfully!');
      } else {
        print('Error sending request. Status code: ${response.statusCode}');
      }
    } catch (error) {
      // Handle network errors
      print('Error sending request: $error');
    }
  }

  String _getShift() {
    return 'Morning';
  }

  Future<String?> getTokenFromPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(prefs.getString('jwtToken'));
    return prefs.getString('jwtToken');
  }
}
