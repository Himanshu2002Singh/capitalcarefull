import 'package:capital_care/controllers/providers/calls_provider.dart';
import 'package:capital_care/controllers/providers/lead_provider.dart';
import 'package:capital_care/models/leads_model.dart';
import 'package:capital_care/services/api_service.dart';
import 'package:capital_care/theme/appcolors.dart';
import 'package:capital_care/views/screens/call_logs_screen.dart';
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
    Colors.orange,
    Colors.purple,
  ];

  final boxIconList = [
    Icons.pending_actions,
    Icons.event_available,
    Icons.calendar_month,
    Icons.man,
    Icons.call,
    Icons.call_received,
  ];

  final boxTextList = [
    "File Login",
    "Tomorrow FollowUps",
    "Today FollowUps",
    "Total Leads",
    "Total Calls",
    "Today Calls",
  ];
  List<Leads> leadsForGraph = [];
  int selectedDays = 7;
  List<int> dayOptions = [7, 15, 30, 60];

  @override
  void initState() {
    // TODO: implement initState
    getLeadsForGraph();
  }

  Future<void> getLeadsForGraph() async {
    final startDate = DateTime.now().subtract(Duration(days: selectedDays));
    final endDate = DateTime.now().add(const Duration(days: 1));
    leadsForGraph = await ApiService.fetchLeads(startDate, endDate);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final leadProvider = Provider.of<LeadProvider>(context, listen: true);
    final callProvider = Provider.of<CallsProvider>(context, listen: true);
    final calls = callProvider.totalCallsCount;
    final todayCalls = callProvider.todayCallsCount;

    final tomorrowLeads = leadProvider.tomorrowLeads;

    final todayLeads = leadProvider.todayLeads;
    final totalLeads = leadProvider.totalLeadsCount;

    final fileLoginLeads = leadProvider.fileLoginLeads;

    final boxCountList = [
      fileLoginLeads.length,
      tomorrowLeads.length,
      todayLeads.length,
      totalLeads,
      calls,
      todayCalls,
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
      body: SafeArea(
        child: Padding(
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
                      children: List.generate(6, (index) {
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
                                        title: "File Login Leads",
                                        // leads: fileLoginLeads,
                                      );
                                    } else if (index == 1) {
                                      return LeadsCountScreen(
                                        title: "Tomorrow Followups",
                                        // leads: tomorrowLeads,
                                      );
                                    } else if (index == 2) {
                                      return LeadsCountScreen(
                                        title: "Today Followups",
                                        // leads: todayLeads,
                                      );
                                    } else if (index == 4) {
                                      return CallLogsScreen();
                                    } else {
                                      return CallLogsScreen(
                                        title: "Today Calls",
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Lead Status",
                          style: TextStyle(color: Colors.blue, fontSize: 17),
                        ),
                        DropdownButton<int>(
                          value: selectedDays,
                          items:
                              dayOptions.map((days) {
                                return DropdownMenuItem<int>(
                                  value: days,
                                  child: Text("Last $days days"),
                                );
                              }).toList(),
                          onChanged: (newValue) {
                            if (newValue != null) {
                              setState(() {
                                selectedDays = newValue;
                                getLeadsForGraph(); // fetch new leads on change
                              });
                            }
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Bar chart
                    DynamicBarChart(leads: leadsForGraph),
                    const SizedBox(height: 20),
                    const Text(
                      "Lead By Source",
                      style: TextStyle(color: Colors.blue, fontSize: 17),
                    ),
                    const SizedBox(height: 16),
                    //pie chart
                    DynamicPieChart(leads: leadsForGraph),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
