import 'package:capital_care/controllers/providers/lead_provider.dart';
import 'package:capital_care/models/get_leads_model.dart';
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
  @override
  void initState() {
    super.initState();
    // Fetch leads only once when screen initializes

    Provider.of<LeadProvider>(context, listen: false).fetchLeads();
  }

  @override
  Widget build(BuildContext context) {
    final leadProvider = Provider.of<LeadProvider>(context);
    final leads = leadProvider.leads;

    return AppScaffold(
      isFloatingActionButton: true,
      appBar: CustomAppbar(title: "Leads"),
      body:
          leads.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : RefreshIndicator(
                onRefresh: () => leadProvider.fetchLeads(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("Total Leads: ${leads.length}"),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: leads.length,
                        itemBuilder: (context, index) {
                          final lead = leads[index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => LeadDetailsScreen(),
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
          MaterialPageRoute(builder: (context) => const AddLeadScreen()),
        );
      },
    );
  }
}
