import 'package:capital_care/models/calls_model.dart';
import 'package:capital_care/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class CallsProvider with ChangeNotifier {
  List<Calls> _calls = [];
  List<Calls> _todayCalls = [];

  List<Calls> get calls => _calls;
  List<Calls> get todayCalls => _todayCalls;

  Future<void> addCall(Calls call) async {
    try {
      bool success = await ApiService.addCalls(call);
      if (success) {
        _calls.add(call);
        _todayCalls.add(call);
        notifyListeners();
      }
    } catch (e) {
      print("Error adding new call");
    }
  }

  Future<void> fetchTotalCalls() async {
    // Simulate a network call
    try {
      _calls = await ApiService.getCalls();
    } catch (e) {
      print("Error fetching calls: $e");
      _calls = []; // fallback on error
    } finally {
      notifyListeners();
    }
  }

  Future<void> fetchTodayCalls() async {
    final now = DateTime.now();
    _todayCalls =
        _calls.where((call) {
          final callDate = DateTime.parse(call.createdAt);
          return callDate.year == now.year &&
              callDate.month == now.month &&
              callDate.day == now.day;
        }).toList();
    // Simulate a network call
    // try {
    //   _todayCalls = await ApiService.getCallsByDates();
    // } catch (e) {
    //   print("Error fetching calls: $e");
    //   _calls = []; // fallback on error
    // } finally {
    //   notifyListeners();
    // }
  }
}
