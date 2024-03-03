import 'package:flutter/material.dart';
import 'package:womensafety/screens/ask_phone_no.dart';


class Navigation extends StatelessWidget {
  Navigation({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Drawer(
        width: 280,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              buildHeader(context, Theme.of(context).brightness == Brightness.light
                  ? Colors.cyan.shade700
                  : Colors.black26,),
              buildMenuItems(context),
            ],
          ),
        ));
  }
}

Widget buildHeader(BuildContext context, Color bgcolor) {
  return Material(
    child: InkWell(
      child: Container(
        color: bgcolor,
        padding: EdgeInsets.only(
          top: 15 + MediaQuery
              .of(context)
              .padding
              .top,
          bottom: 20,),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white,  // Set the color of the border
                  width: 6.0,           // Set the width of the border
                ),
              ),
              child: const CircleAvatar(
                radius: 40,
                backgroundImage: AssetImage("assets/logo.jpg"),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              'EmpowerSafe App',
              style: TextStyle(
                  fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20,),
            const Center(
              child: Text(
                "\"Adopt A Pet! 🐶\"",
                style: TextStyle(
                    fontSize: 16,
                    fontStyle: FontStyle.italic, color: Colors.white, fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),
      ),
    ),
  );
}


Widget buildMenuItems(BuildContext context) {
  return Container(
    padding: const EdgeInsets.only(top: 30, right: 20, left: 30, bottom: 20),
    child: Wrap(
      runSpacing: 12,
      alignment: WrapAlignment.center,
      children: [
        ListTile(
          leading: const Icon(Icons.home, color: Colors.black),
          title: const Text("Home", style: TextStyle(color: Colors.black)),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const AskPhone()),
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.call, color: Colors.black),
          title: const Text("Phone Number", style: TextStyle(color: Colors.black)),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const AskPhone()),
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.emergency, color: Colors.black),
          title: const Text("SOS Feature", style: TextStyle(color: Colors.black)),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const AskPhone()),
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.share, color: Colors.black),
          title: const Text("Share", style: TextStyle(color: Colors.black)),
          onTap: () {

          },
        ),
      ],
    ),
  );
}


void _shareResult() {
  String playStoreLink = 'https://play.google.com/store/apps/details?id=com.atomdyno.petapp';
  String message = 'Download Pet App on Play Store: $playStoreLink';

  // Share.share(message);
}