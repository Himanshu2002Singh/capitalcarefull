import 'package:capital_care/models/leads_model.dart';
import 'package:capital_care/services/api_service.dart';
import 'package:flutter/material.dart';

class LeadProvider with ChangeNotifier {
  List<Leads> _leads = [];
  bool _isLoading = false;

  List<Leads> get leads => _leads;
  bool get isLoading => _isLoading;

  Future<void> fetchLeads() async {
    _isLoading = true;
    notifyListeners();

    try {
      _leads = await ApiService.fetchLeads();
    } catch (e) {
      print("Error fetching leads: $e");
      _leads = []; // fallback on error
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addLead() async {
    await fetchLeads();
    notifyListeners();
  }
}
