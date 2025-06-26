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
      Calls? newCall = await ApiService.addCalls(call);
      if (newCall != null) {
        print("===========================>${newCall.number}");
        _calls.add(newCall);
        _todayCalls.add(newCall);
        notifyListeners();
      }
    } catch (e) {
      print("Error adding new call: $e");
    }
  }

  Future<bool> updateLastCallRemark(String newRemark) async {
    if (_calls.isEmpty) {
      print("No calls to update");
      return false;
    }

    // Get last call
    Calls lastCall = _calls.last;
    print("===================>${lastCall.call_id}");
    // Create updated call with required fields
    Calls updatedCall = Calls(
      call_id: lastCall.call_id,
      lead_id: lastCall.lead_id,
      emp_id: lastCall.emp_id,
      name: lastCall.name,
      number: lastCall.number,
      remark: newRemark, // only remark is changed
      createdAt: lastCall.createdAt,
    );

    try {
      bool success = await ApiService.updateCall(updatedCall, lastCall.call_id);

      if (success) {
        // Update _calls list
        int index = _calls.lastIndexWhere((c) => c.call_id == lastCall.call_id);
        if (index != -1) _calls[index] = updatedCall;

        // Update _todayCalls list if needed
        int todayIndex = _todayCalls.indexWhere(
          (c) => c.call_id == lastCall.call_id,
        );
        if (todayIndex != -1) _todayCalls[todayIndex] = updatedCall;

        notifyListeners();
        return true;
      } else {
        print("❌ API update failed");
        return false;
      }
    } catch (e) {
      print("❌ Exception during update: $e");
      return false;
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
