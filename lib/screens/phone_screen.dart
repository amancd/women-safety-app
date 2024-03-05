import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_sms/flutter_sms.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:womensafety/database/phone_db.dart';

class PhoneScreen extends StatefulWidget {
  const PhoneScreen({Key? key}) : super(key: key);

  @override
  State<PhoneScreen> createState() => _PhoneScreenState();
}

class _PhoneScreenState extends State<PhoneScreen> {
  final _myBox = Hive.box('mybox');
  PhoneDB db = PhoneDB();

  String _emergencyPhoneNumber = "+911234567890"; // Default emergency phone number
  late Timer _locationTimer;
  int _numberOfMessages = 5;

  @override
  void initState() {
    if (_myBox.get("fav") != null) {
      db.loadData();
    }
    if (db.favList.isNotEmpty) {
      _emergencyPhoneNumber = "+91${db.favList[0][0]}";
    }
    _locationTimer = Timer.periodic(const Duration(minutes: 1), (Timer timer) {
      if (_numberOfMessages > 0) {
        startSendingLocation();
        _numberOfMessages--;
      } else {
        _locationTimer.cancel(); // Stop the timer after sending messages
      }
    });
    _requestSMSPermission();
    super.initState();
  }

  @override
  void dispose() {
    _locationTimer.cancel(); // Cancel the timer when the widget is disposed
    super.dispose();
  }

  void _requestSMSPermission() async {
    var status = await Permission.sms.status;
    if (status.isDenied) {
      await Permission.sms.request();
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white,
                        width: 6.0,
                      ),
                    ),
                    child: const CircleAvatar(
                      radius: 40,
                      backgroundImage: AssetImage("images/location.png"),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
              Text(
                "SOS Will Be Sent To $_emergencyPhoneNumber",
                style: const TextStyle(fontSize: 15),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: startSendingLocation,
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.purpleAccent,
                ),
                child: const Text("START"),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: stopSendingLocation,
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.purpleAccent,
                ),
                child: const Text("STOP"),
              ),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }

  void startSendingLocation() async {
    var status = await Permission.sms.status;
    LocationPermission permission;
    permission = await Geolocator.requestPermission();
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    // Compose SMS
    String message = "Help! I'm in danger. My current location is:\n"
        "Latitude: ${position.latitude}\nLongitude: ${position.longitude}\n"
        "https://www.google.com/maps?q=${position.latitude},${position.longitude}";

    // Assuming the first phone number is the emergency contact
    String phoneNumber = _emergencyPhoneNumber;

    _sendSms(phoneNumber, message);
  }

  void _sendSms(String phoneNumber, String message) async {
    try {
      await sendSMS(message: message, recipients: [phoneNumber], sendDirect: true);
    } catch (error) {
      print("Failed to send SMS: $error");
    }
  }

  void stopSendingLocation() {
    _locationTimer.cancel();
  }
}
