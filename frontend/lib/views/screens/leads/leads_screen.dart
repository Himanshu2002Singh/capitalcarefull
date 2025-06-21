import 'package:capital_care/controllers/providers/lead_provider.dart';
import 'package:capital_care/controllers/providers/userprovider.dart';
import 'package:capital_care/theme/appcolors.dart';
import 'package:capital_care/views/screens/leads/add_lead_screen.dart';
import 'package:capital_care/views/screens/leads/lead_details_screen.dart';
import 'package:capital_care/views/widgets/app_scaffold.dart';
import 'package:capital_care/views/widgets/custom_appbar.dart';
import 'package:capital_care/views/widgets/lead_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LeadsScreen extends StatefulWidget {
  const LeadsScreen({super.key});

  @override
  State<LeadsScreen> createState() => _LeadsScreenState();
}

class _LeadsScreenState extends State<LeadsScreen> {
  String loanSelectedItem = "All";
  String selectedStatusItem = "All";
  String searchQuery = "";

  final List<String> loanTypeOptions = [
    "All",
    "Home Loan",
    "Mortgage Loan",
    "User Car Loan",
    "Business Loan",
    "Personal Loan",
    "DOD",
    "CC/OD",
    "CGTMSME",
    "Mutual Fund",
    "Insurance",
    "Other",
  ];

  final List<String> statusOptions = [
    "All",
    "Interested",
    "Call Back",
    "No Requirement",
    "Follow up",
    "Document Rejected",
    "Document Pending",
    "Not Pick",
    "Not Connected",
    "File Login",
    "Loan Section",
    "Loan Disbursement",
  ];

  @override
  void initState() {
    super.initState();
    Provider.of<LeadProvider>(context, listen: false).fetchLeads();
  }

  @override
  Widget build(BuildContext context) {
    final leadProvider = Provider.of<LeadProvider>(context);
    final leads = leadProvider.leads;
    final isLoading = leadProvider.isLoading;
    final user = Provider.of<UserProvider>(context).user;

    /// 🔍 Final filtered list (Loan Type + Status + Search Query)
    final filteredLeads =
        leads.where((lead) {
          final matchesLoan =
              loanSelectedItem == "All" || lead.loanType == loanSelectedItem;
          final matchesStatus =
              selectedStatusItem == "All" || lead.status == selectedStatusItem;
          final matchesSearch =
              searchQuery.isEmpty ||
              lead.name.toLowerCase().contains(searchQuery.toLowerCase());
          return matchesLoan && matchesStatus && matchesSearch;
        }).toList();

    return AppScaffold(
      isFloatingActionButton: true,
      appBar: CustomAppbar(
        title: "Leads",
        action: [
          const Text("Loan Type: ", style: TextStyle(color: Colors.white)),
          DropdownButton<String>(
            value: loanSelectedItem,
            style: const TextStyle(color: Colors.white),
            dropdownColor: Colors.black,
            iconEnabledColor: Colors.white,
            items:
                loanTypeOptions.map((type) {
                  return DropdownMenuItem(
                    value: type,
                    child: Text(
                      type,
                      style: const TextStyle(color: Colors.white),
                    ),
                  );
                }).toList(),
            onChanged: (value) {
              setState(() {
                loanSelectedItem = value!;
              });
            },
          ),
        ],
      ),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : leads.isEmpty
              ? const Center(child: Text("No leads found"))
              : RefreshIndicator(
                onRefresh: () => leadProvider.fetchLeads(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 🔍 Search Bar
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      child: TextField(
                        onChanged: (value) {
                          setState(() {
                            searchQuery = value;
                          });
                        },
                        decoration: InputDecoration(
                          hintText: "Search by name...",
                          prefixIcon: const Icon(Icons.search),
                          isDense: true, // Ye height kam karega
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 10,
                          ), // Adjust vertical height
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),

                    // 📊 Count
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        "Total Leads: ${filteredLeads.length}",
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ),

                    // 🏷 Status Filter Chips
                    Container(
                      height: 50,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: statusOptions.length,
                        itemBuilder: (context, index) {
                          final option = statusOptions[index];
                          return GestureDetector(
                            onTap: () {
                              selectedStatusItem = option;
                              setState(() {});
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 4,
                                vertical: 8,
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: AppColors.primaryColor,
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(20),
                                color:
                                    selectedStatusItem == option
                                        ? const Color.fromARGB(
                                          255,
                                          219,
                                          219,
                                          219,
                                        )
                                        : Colors.white,
                              ),
                              child: Text(
                                option,
                                style: const TextStyle(fontSize: 14),
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    // 📋 Leads List
                    Expanded(
                      child: ListView.builder(
                        itemCount: filteredLeads.length,
                        itemBuilder: (context, index) {
                          final lead = filteredLeads[index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) =>
                                          LeadDetailsScreen(lead: lead),
                                ),
                              );
                            },
                            child: LeadCard(lead: lead),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
      floatingActionButtonIcon: const Icon(Icons.add),
      floatingActionButtonOnTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) => AddLeadScreen(
                  title: "Add Lead",
                  userId: user?.empId ?? "",
                  userName: user?.ename ?? "",
                ),
          ),
        );
      },
    );
  }
}
