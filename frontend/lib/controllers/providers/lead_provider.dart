import 'package:capital_care/models/get_leads_model.dart';
import 'package:capital_care/services/api_service.dart';
import 'package:flutter/material.dart';

class LeadProvider with ChangeNotifier {
  var _leads = [];

  List get leads => _leads;

  Future<void> fetchLeads() async {
    _leads = await ApiService.fetchLeads();
    notifyListeners();
  }

  void addLead() {
    fetchLeads();
    notifyListeners();
  }
}
