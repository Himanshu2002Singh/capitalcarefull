// import 'package:cdipl/helpers/tokenmanager.dart';
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// import '../models/usermodel.dart';

// class UserProvider with ChangeNotifier {
//   User? _user;
//   String? token;
//   User? get user => _user; // Define a getter for _user

//   void setUser(User user) {
//     _user = user;
//     notifyListeners();
//   }

//   void setToken(newtoken) {
//     token = newtoken;
//     // notifyListeners();
//   }

//   void setPoins(int points) {
//     _user?.points += points;
//     notifyListeners();
//   }

//   void logout() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     await prefs.clear();

//     await TokenManager.removeToken();
//     token = null;
//     _user = null;
//     notifyListeners();
//   }
// }
