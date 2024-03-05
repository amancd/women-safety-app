import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:womensafety/database/phone_db.dart';
import 'package:womensafety/screens/phone_screen.dart';
import 'package:womensafety/widgets/navigation.dart';

class AskPhone extends StatefulWidget {
  const AskPhone({Key? key}) : super(key: key);

  @override
  State<AskPhone> createState() => _AskPhoneState();
}

class _AskPhoneState extends State<AskPhone> {
  final List<TextEditingController> _controllers = List.generate(
    4,
        (index) => TextEditingController(),
  );

  final _myBox = Hive.box('mybox');
  PhoneDB db = PhoneDB();
  final List<List<String>> _favList = [];

  bool _isPhoneNumberValid = true;
  int _selectedNumberOfPhones = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Navigation(),
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              db.clearData();

            },
          ),
        ],
      ),
      body: SingleChildScrollView(
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
                    height: 10,
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Enter Phone Number To Send Live Location In Emergency",
                  style: TextStyle(fontSize: 15),
                ),
              ),
              const SizedBox(
                height: 40,
              ),

              DropdownButton<int>(
                value: _selectedNumberOfPhones,
                items: [1, 2, 3, 4].map((int value) {
                  return DropdownMenuItem<int>(
                    value: value,
                    child: Text("Enter $value phone number${value > 1 ? 's' : ''}"),
                  );
                }).toList(),
                onChanged: (int? newValue) {
                  setState(() {
                    _selectedNumberOfPhones = newValue ?? 1;
                  });
                },
              ),

              // Dynamically generate input fields based on the selected number
              for (int i = 0; i < _selectedNumberOfPhones; i++)
                Column(
                  children: [
                    TextField(
                      controller: _controllers[i],
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: "Phone Number ${i + 1}",
                        hintText: "Enter Phone Number",
                        errorText: _isPhoneNumberValid
                            ? null
                            : "Enter a valid 10-digit phone number",
                        border: const OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),

              ElevatedButton(
                onPressed: () => _savePhoneNumbers(),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.purpleAccent,
                ),
                child: const Text("Save"),
              ),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }

  void _savePhoneNumbers() {
    bool allValid = true;
    _favList.clear();

    for (int i = 0; i < _selectedNumberOfPhones; i++) {
      final phoneNumber = _controllers[i].text.trim();

      if (phoneNumber.length == 10) {
        _favList.add([phoneNumber]);
      } else {
        allValid = false;
      }
    }

    if (allValid) {
      setState(() {
        _isPhoneNumberValid = true;
      });

      _myBox.put("fav", _favList);
    } else {
      setState(() {
        _isPhoneNumberValid = false;
      });
    }

    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const PhoneScreen()),
    );
  }
}
