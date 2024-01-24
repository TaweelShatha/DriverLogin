// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, prefer_const_literals_to_create_immutables, await_only_futures
// shift.dart

import 'package:flutter/material.dart';
import 'package:log/DriverMap.dart';
import 'package:log/Home.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class Shift extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 50),
          _buildLogo(),
          SizedBox(height: 30),
          _buildShiftButtons(context),
          SizedBox(height: 20),
          _buildLoadingIndicator(),
          _buildAnimatedText(),
          SizedBox(height: 20),
          _buildAdditionalContent(context),
        ],
      ),
    );
  }

  Widget _buildLogo() {
    return Image.asset(
      'assets/whitelogo.png',
      height: 150.0,
    );
  }

  Widget _buildShiftButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildShiftButton(
          onTap: () => _showConfirmationDialog(
            context,
            "Start a shift",
            () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DriverMap()),
              );
            },
          ),
          imageAsset: 'assets/start.png',
          label: 'Start Shift',
        ),
        SizedBox(width: 30),
        _buildShiftButton(
          onTap: () => _showConfirmationDialog(
            context,
            "End your shift",
            () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Home.withoutToken()),
              );
            },
          ),
          imageAsset: 'assets/end.png',
          label: 'End Shift',
        ),
      ],
    );
  }

  Widget _buildShiftButton({
    required VoidCallback onTap,
    required String imageAsset,
    required String label,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Image.asset(
            imageAsset,
            height: 100.0,
          ),
          SizedBox(height: 10),
          Text(
            label,
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }

  void _showConfirmationDialog(
    BuildContext context,
    String message,
    VoidCallback onConfirmation,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirmation"),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                onConfirmation();
              },
              child: Text("Yes"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("No"),
            ),
          ],
        );
      },
    );
  }

  Widget _buildLoadingIndicator() {
    return SpinKitThreeBounce(
      color: Colors.white,
      size: 30.0,
    );
  }

  Widget _buildAnimatedText() {
    return DefaultTextStyle(
      style: TextStyle(fontSize: 20.0, color: Colors.white),
      child: AnimatedTextKit(
        animatedTexts: [
          WavyAnimatedText('Tap to Start/End a Shift'),
        ],
        totalRepeatCount: 3,
        pause: const Duration(milliseconds: 100),
        displayFullTextOnTap: true,
        stopPauseOnTap: true,
      ),
    );
  }

  Widget _buildAdditionalContent(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 30),
        ElevatedButton(
          onPressed: () async {
            Navigator.push(
              context,
             await MaterialPageRoute(builder: (context) => Home.withoutToken()),
            );
          },
          child: Text('Back Home'),
        ),
        SizedBox(height: 20),
      ],
    );
  }
}
