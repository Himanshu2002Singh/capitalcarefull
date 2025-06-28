import 'package:capital_care/models/leads_model.dart';
import 'package:capital_care/services/api_service.dart';
import 'package:flutter/material.dart';

class LeadProvider with ChangeNotifier {
  List<Leads> _leads = [];
  List<Leads> _allLeads = [];
  // List<Leads> _freshLeads = [];
  bool _isLoading = false;

  List<Leads> get leads => _leads;
  List<Leads> get allLeads => _allLeads;
  List<Leads> get freshLeads =>
      _allLeads.where((lead) => lead.status == "Fresh Lead").toList();
  bool get isLoading => _isLoading;

  Future<void> fetchLeads({DateTime? startDate, DateTime? endDate}) async {
    _isLoading = true;
    notifyListeners();

    try {
      _leads = await ApiService.fetchLeads(startDate, endDate);
    } catch (e) {
      print("Error fetching leads: $e");
      _leads = []; // fallback on error
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Future<void> fetchFreshLeads() async {
  //   _isLoading = true;
  //   notifyListeners();

  //   _freshLeads = _leads.where((lead) => lead.status == "Fresh Lead").toList();

  //   _isLoading = false;
  //   notifyListeners();
  //   print(_freshLeads);
  // }

  Future<void> fetchAllLeads() async {
    _isLoading = true;
    notifyListeners();
    try {
      _allLeads = await ApiService.fetchLeads(null, null);
    } catch (e) {
      print("Error fetching all leads: $e");
      _leads = []; // fallback on error
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<int> addLead(Leads newLead) async {
    try {
      int newId = await ApiService.addLead(newLead);
      // print("==================>>$id");
      // int newId = int.parse(id);
      if (newId != -1) {
        _allLeads.add(newLead);
        notifyListeners();
        return newId;
      }
      return -1;
    } catch (e) {
      print("Error adding lead: $e");
      return -1;
    }
  }

  Future<void> updateLead(Leads updatedLead, int leadId) async {
    try {
      bool success = await ApiService.updateLead(leadId, updatedLead);
      if (success) {
        final index = _leads.indexWhere((lead) => lead.lead_id == leadId);
        final index2 = _allLeads.indexWhere((lead) => lead.lead_id == leadId);
        if (index != -1) {
          final oldLead = _leads[index];

          final mergedLead = Leads(
            lead_id: oldLead.lead_id,
            person_id: updatedLead.person_id ?? oldLead.person_id,
            name: updatedLead.name ?? oldLead.name,
            number: updatedLead.number ?? oldLead.number,
            email: updatedLead.email ?? oldLead.email,
            dob: updatedLead.dob ?? oldLead.dob,
            owner: updatedLead.owner ?? oldLead.owner,
            branch: updatedLead.branch ?? oldLead.branch,
            source: updatedLead.source ?? oldLead.source,
            priority: updatedLead.priority ?? oldLead.priority,
            status: updatedLead.status ?? oldLead.status,
            next_meeting: updatedLead.next_meeting ?? oldLead.next_meeting,
            refrence: updatedLead.refrence ?? oldLead.refrence,
            description: updatedLead.description ?? oldLead.description,
            address: updatedLead.address ?? oldLead.address,
            loanType: updatedLead.loanType ?? oldLead.loanType,
            est_budget: updatedLead.est_budget ?? oldLead.est_budget,
            remark: updatedLead.remark ?? oldLead.remark,
            createdAt: oldLead.createdAt, // Usually won't change
            employment_type:
                updatedLead.employment_type ?? oldLead.employment_type,
            loan_term: updatedLead.loan_term ?? oldLead.loan_term,
          );

          _leads[index] = mergedLead;

          notifyListeners();
        }
        if (index2 != -1) {
          final oldLead = _allLeads[index2];

          final mergedLead = Leads(
            lead_id: oldLead.lead_id,
            person_id: updatedLead.person_id ?? oldLead.person_id,
            name: updatedLead.name ?? oldLead.name,
            number: updatedLead.number ?? oldLead.number,
            email: updatedLead.email ?? oldLead.email,
            dob: updatedLead.dob ?? oldLead.dob,
            owner: updatedLead.owner ?? oldLead.owner,
            branch: updatedLead.branch ?? oldLead.branch,
            source: updatedLead.source ?? oldLead.source,
            priority: updatedLead.priority ?? oldLead.priority,
            status: updatedLead.status ?? oldLead.status,
            next_meeting: updatedLead.next_meeting ?? oldLead.next_meeting,
            refrence: updatedLead.refrence ?? oldLead.refrence,
            description: updatedLead.description ?? oldLead.description,
            address: updatedLead.address ?? oldLead.address,
            loanType: updatedLead.loanType ?? oldLead.loanType,
            est_budget: updatedLead.est_budget ?? oldLead.est_budget,
            remark: updatedLead.remark ?? oldLead.remark,
            createdAt: oldLead.createdAt, // Usually won't change
            employment_type:
                updatedLead.employment_type ?? oldLead.employment_type,
            loan_term: updatedLead.loan_term ?? oldLead.loan_term,
          );
          _allLeads[index2] = mergedLead;
          notifyListeners();
        }
      }
    } catch (e) {
      print("Error updating lead: $e");
    }
  }
}
