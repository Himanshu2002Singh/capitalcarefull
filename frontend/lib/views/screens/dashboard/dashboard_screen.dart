import 'package:capital_care/controllers/providers/lead_provider.dart';
import 'package:capital_care/theme/appcolors.dart';
import 'package:capital_care/views/screens/dashboard/leads_count_screen.dart';
import 'package:capital_care/views/screens/leads/leads_screen.dart';
import 'package:capital_care/views/widgets/app_scaffold.dart';
import 'package:capital_care/views/widgets/bar_chart.dart';
import 'package:capital_care/views/widgets/custom_appbar.dart';
import 'package:capital_care/views/widgets/dialPadBottomSheet.dart';
import 'package:capital_care/views/widgets/piechart.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';

class DashboardScreen extends StatefulWidget {
  DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final boxColorList = [
    Colors.red,
    Colors.blueGrey,
    Colors.greenAccent,
    Colors.lightBlue,
  ];

  final boxIconList = [
    Icons.pending_actions,
    Icons.event_available,
    Icons.calendar_month,
    Icons.man,
  ];

  final boxTextList = [
    "File Login",
    "Tomorrow FollowUps",
    "Today FollowUps",
    "Total Leads",
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<LeadProvider>(context, listen: false).fetchLeads();
    });
  }

  @override
  Widget build(BuildContext context) {
    final leadProvider = Provider.of<LeadProvider>(context);
    final leads = leadProvider.leads;
    final now = DateTime.now();
    final tomorrow = DateTime(now.year, now.month, now.day + 1);

    final tomorrowLeads =
        leads.where((lead) {
          if (lead.next_meeting == null || lead.next_meeting.isEmpty) {
            return false;
          }
          final leadDate = DateTime.parse(lead.next_meeting);
          return leadDate.year == tomorrow.year &&
              leadDate.month == tomorrow.month &&
              leadDate.day == tomorrow.day;
        }).toList();

    final todayLeads =
        leads.where((lead) {
          if (lead.next_meeting == null || lead.next_meeting.isEmpty) {
            return false;
          }
          final leadDate = DateTime.parse(lead.next_meeting);
          return leadDate.year == now.year &&
              leadDate.month == now.month &&
              leadDate.day == now.day;
        }).toList();

    final documentSubmitedLeads =
        leads.where((leads) {
          if (leads.status == "Documents Submitted") {
            return true;
          } else {
            return false;
          }
        }).toList();

    final boxCountList = [
      documentSubmitedLeads.length,
      tomorrowLeads.length,
      todayLeads.length,
      leads.length,
    ];
    return AppScaffold(
      isFloatingActionButton: true,
      floatingActionButtonIcon: Icon(Icons.add),
      floatingActionButtonOnTap: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          builder: (_) => DialPadBottomSheet(),
        );
      },
      appBar: CustomAppbar(title: "DashBoard"),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: LayoutBuilder(
          builder: (context, constraints) {
            double boxWidth = (constraints.maxWidth - 12) / 2;

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 4 boxes
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: List.generate(4, (index) {
                      return GestureDetector(
                        onTap:
                            () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  if (index == 3) {
                                    return LeadsScreen();
                                  } else if (index == 0) {
                                    return LeadsCountScreen(
                                      title: "Document Submitted",
                                      leads: documentSubmitedLeads,
                                    );
                                  } else if (index == 1) {
                                    return LeadsCountScreen(
                                      title: "Tomorrow Leads",
                                      leads: tomorrowLeads,
                                    );
                                  } else {
                                    return LeadsCountScreen(
                                      title: "Today Leads",
                                      leads: todayLeads,
                                    );
                                  }
                                },
                              ),
                            ),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: boxColorList[index],
                          ),
                          padding: const EdgeInsets.all(10),
                          width: boxWidth,
                          child: IconTheme(
                            data: const IconThemeData(color: Colors.white),
                            child: DefaultTextStyle(
                              maxLines: 1,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(boxIconList[index]),
                                  const SizedBox(height: 10),
                                  Center(
                                    child: Column(
                                      children: [
                                        // Text("0"),
                                        Text("${boxCountList[index]}"),
                                        const SizedBox(height: 10),
                                        Text(boxTextList[index]),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),

                  const SizedBox(height: 20),
                  const Text(
                    "Lead Status",
                    style: TextStyle(color: Colors.blue, fontSize: 17),
                  ),
                  const SizedBox(height: 16),

                  // Bar chart
                  DynamicBarChart(),
                  const SizedBox(height: 20),
                  const Text(
                    "Lead By Source",
                    style: TextStyle(color: Colors.blue, fontSize: 17),
                  ),
                  const SizedBox(height: 16),
                  //pie chart
                  DynamicPieChart(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
