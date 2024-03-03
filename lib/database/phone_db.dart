import 'package:hive_flutter/hive_flutter.dart';

class PhoneDB {
  List<List<String>> favList = [];

  // Reference our box
  final _myBox = Hive.box('mybox');

  void loadData() {
    // Load data from Hive box
    favList = _myBox.get("fav", defaultValue: []);
  }

  void clearData() {
    // Clear data in memory and Hive box
    favList.clear();
    _myBox.put("fav", favList);
  }

  // Update the database
  void updateDataBase(List<String> phoneNumbers) {
    // Update the in-memory list
    favList = [phoneNumbers];

    // Update the Hive box
    _myBox.put("fav", favList);
  }
}
