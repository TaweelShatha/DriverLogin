// ignore_for_file: prefer_interpolation_to_compose_strings, avoid_print, prefer_const_constructors, sort_child_properties_last, library_private_types_in_public_api, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

class ResetPassword extends StatefulWidget {
  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  bool resetByEmail = true;
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reset Password'),
        backgroundColor: Colors.lightBlue,
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        color: Colors.lightBlue,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select Reset Method:',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Row(
              children: [
                Radio(
                  value: true,
                  groupValue: resetByEmail,
                  onChanged: (value) {
                    setState(() {
                      resetByEmail = value!;
                    });
                  },
                ),
                Text(
                  'Reset by Email',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                  ),
                ),
              ],
            ),
            if (resetByEmail)
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Enter your email',
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
            Row(
              children: [
                Radio(
                  value: false,
                  groupValue: resetByEmail,
                  onChanged: (value) {
                    setState(() {
                      resetByEmail = value!;
                    });
                  },
                ),
                Text(
                  'Reset by Phone Number',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                  ),
                ),
              ],
            ),
            if (!resetByEmail)
              TextField(
                controller: phoneNumberController,
                decoration: InputDecoration(
                  labelText: 'Enter your phone number',
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                if (resetByEmail) {
                  sendRecoveryEmail(emailController.text);
                } else {
                  sendTextMessage(phoneNumberController.text);
                }
              },
              child: Text(
                'Submit',
                style: TextStyle(color: Colors.black),
              ),
              style: ElevatedButton.styleFrom(
                primary: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showInfoAlert(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void sendRecoveryEmail(String email) async {
    final smtpServer = gmail('taweelshatha90@gmail.com', 'ksyf virg rxem mkuq');

    final message = Message()
      ..from = Address('shathataweel90@gmail.com', 'Bus Track')
      ..recipients.add(email)
      ..subject = 'Password Reset'
      ..text =
          'Click the link to reset your password: https://example.com/reset';

    try {
      final sendReport = await send(message, smtpServer);
      showInfoAlert('Password reset email sent successfully.');
      print('Message sent: ' + sendReport.toString());
    } catch (e) {
      showInfoAlert('Error sending password reset email.');
      print('Error: $e');
    }
  }

  void sendTextMessage(String phoneNumber) {
    showInfoAlert('Text message sent to $phoneNumber');
    print('Text message sent to $phoneNumber');
  }
}
