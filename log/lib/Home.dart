// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, prefer_const_literals_to_create_immutables, sized_box_for_whitespace, use_build_context_synchronously, prefer_const_constructors_in_immutables, library_private_types_in_public_api, avoid_print, deprecated_member_use
// home.dart

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:log/DriverMap.dart';
import 'package:log/shift.dart';
import 'package:log/Excep.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:log/main.dart';
import 'package:path_provider/path_provider.dart';


class Home extends StatefulWidget {
  final String? jwtToken;

  Home(this.jwtToken);
  Home.withoutToken() : jwtToken = null;

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  File? _image;
  late Map<String, dynamic> decodedToken;

  @override
  void initState() {
    super.initState();

    // Decode the JWT token only if it is provided
    if (widget.jwtToken != null) {
      decodedToken = _decodeToken(widget.jwtToken!);
      // Fetch and display profile image
      _fetchAndDisplayProfileImage(decodedToken['id']);
    }
  }

  Map<String, dynamic> _decodeToken(String token) {
    final parts = token.split('.');
    if (parts.length != 3) {
      throw Exception('Invalid token');
    }

    final payload = parts[1];
    final String decoded =
        utf8.decode(base64Url.decode(base64Url.normalize(payload)));

    return json.decode(decoded);
  }

  Future<void> _fetchAndDisplayProfileImage(int userId) async {
    try {
      final response = await http.get(
        Uri.parse('https://671b-185-88-83-143.ngrok-free.app/api/drivers/8'),
      );
      final Map<String, dynamic> responseData = json.decode(response.body);

      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');
      if (response.statusCode == 200) {
        String imageBase64 = responseData['image'];
        Uint8List imageBytes = base64.decode(imageBase64);
        // Display the image
        final tempDir = await getTemporaryDirectory();
        final tempFile = File('${tempDir.path}/profile_image.png');
        await tempFile.writeAsBytes(imageBytes);
        setState(() {
          _image = File.fromRawPath(imageBytes);
        });
      } else {
        // Handle the case when the request is not successful
        print('Failed to fetch profile image: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching profile image: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    String name = decodedToken['sub']?.toString() ?? 'Default Name';
    int id = decodedToken['id']?.toInt() ?? 0;

    return Scaffold(
      backgroundColor: Colors.lightBlue,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 1,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Image.asset(
          'assets/whitelogo.png',
          height: 40,
        ),
        actions: [
          TextButton(
            onPressed: () async {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    content: Row(
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(width: 16),
                        Text("Logging out..."),
                      ],
                    ),
                  );
                },
              );

              await Future.delayed(Duration(seconds: 2));

              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            },
            child: Text(
              'Logout',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  _showImagePickerDialog();
                },
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
                      CircleAvatar(
                        radius: 40,
                        backgroundImage: _image != null
                            ? FileImage(_image!)
                            : AssetImage('assets/profile.png') as ImageProvider,
                      ),
                      SizedBox(height: 8),
                      Text(
                        'ID: $id',
                        style: TextStyle(color: Colors.white),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Name: $name',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Shift()),
                      );
                    },
                    child: Column(
                      children: [
                        Image.asset(
                          'assets/shift.png',
                          height: 100.0,
                        ),
                        Text(
                          'Control shift',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 16),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Excep()),
                      );
                    },
                    child: Column(
                      children: [
                        Image.asset(
                          'assets/excep.png',
                          height: 100.0,
                        ),
                        Text(
                          'Request a change',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    Text(
                      'Additional Widgets',
                      style: TextStyle(color: Colors.white),
                    ),
                    SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () {
                        // Add functionality for the button
                      },
                      child: Text('Button'),
                    ),
                    SizedBox(height: 8),
                  ],
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) {
                      return Container(
                        padding: EdgeInsets.only(right: 16.0),
                        height: 200,
                        child: Center(
                          child: Text(
                            'Welcome to your control panel! \n\n'
                            'This miniature App will provide you with the necessary tools to ease your work \n\n'
                            'Feel free to contact us at ',
                            style: TextStyle(
                              color: Colors.black,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
                    },
                  );
                },
                child: Text('What\'s here for me?'),
              ),
              SizedBox(height: 16),
              InkWell(
                onTap: () {
                  launch('mailto:helpdesk@bustrack.com');
                },
                child: Container(
                  width: 80,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    ),
                  ),
                  child: Icon(
                    Icons.email,
                    color: Colors.blue,
                    size: 24,
                  ),
                ),
              ),
              SizedBox(height: 16),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DriverMap()),
                  );
                },
                child: Container(
                  width: 80,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    ),
                  ),
                  child: Icon(
                    Icons.map,
                    color: Colors.blue,
                    size: 24,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showImagePickerDialog() async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Upload New Profile Image?"),
          actions: [
            TextButton(
              onPressed: () async {
                Navigator.pop(context);

                final imagePicker = ImagePicker();
                final pickedFile =
                    await imagePicker.pickImage(source: ImageSource.gallery);

                if (pickedFile != null) {
                  setState(() {
                    _image = File(pickedFile.path);
                  });
                }
              },
              child: Text("Gallery"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Cancel"),
            ),
          ],
        );
      },
    );
  }
}
