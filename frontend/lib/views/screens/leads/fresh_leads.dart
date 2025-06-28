import 'package:capital_care/controllers/providers/lead_provider.dart';
import 'package:capital_care/views/screens/leads/lead_details_screen.dart';
import 'package:capital_care/views/widgets/app_scaffold.dart';
import 'package:capital_care/views/widgets/custom_appbar.dart';
import 'package:capital_care/views/widgets/lead_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FreshLeads extends StatefulWidget {
  const FreshLeads({super.key});

  @override
  State<FreshLeads> createState() => _FreshLeadsState();
}

class _FreshLeadsState extends State<FreshLeads> {

  @override
  Widget build(BuildContext context) {
    final leadProvider = Provider.of<LeadProvider>(context, listen: true);
    final leads = leadProvider.freshLeads;

    return AppScaffold(
      appBar: CustomAppbar(title: "Fresh Leads"),
      body:
          leadProvider.isLoading
              ? const Center(child: CircularProgressIndicator())
              : leads.isEmpty
              ? const Center(child: Text("No fresh leads available."))
              : ListView.builder(
                itemCount: leads.length,
                itemBuilder: (context, index) {
                  final lead = leads[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LeadDetailsScreen(lead: lead),
                        ),
                      );
                    },
                    child: LeadCard(lead: lead),
                  );
                },
              ),
      isFloatingActionButton: false,
    );
  }
}
