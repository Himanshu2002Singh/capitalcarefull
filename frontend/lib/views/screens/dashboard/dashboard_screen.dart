import 'package:capital_care/controllers/providers/lead_provider.dart';
import 'package:capital_care/theme/appcolors.dart';
import 'package:capital_care/views/screens/dashboard/pending_followups_screen.dart';
import 'package:capital_care/views/screens/leads/leads_screen.dart';
import 'package:capital_care/views/widgets/app_scaffold.dart';
import 'package:capital_care/views/widgets/custom_appbar.dart';
import 'package:capital_care/views/widgets/dialPadBottomSheet.dart';
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
    "Pending FollowUps",
    "Tomorrow FollowUps",
    "Today FollowUps",
    "Total Leads",
  ];

  final boxNavigationList = [
    PendingFollowUpsScreen(title: "Pending FollowUps"),
    PendingFollowUpsScreen(title: "Tomorrow FollowUps Detail"),
    PendingFollowUpsScreen(title: "Today FollowUps Detail"),
    LeadsScreen(),
  ];
  // var tomorrowLeads;
  // List leads = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   Provider.of<LeadProvider>(context, listen: false).fetchLeads();
    //   print("fetchleads called");
    // });
    // // WidgetsBinding.instance.addPostFrameCallback((_) {
    // leads = Provider.of<LeadProvider>(context, listen: false).leads;
    // });
    // final now = DateTime.now();
    // final tomorrowDate = DateTime(now.year, now.month, now.day + 1);

    // tomorrowLeads = leads.where((lead) {
    //   if (lead.next_meeting == null || lead.next_meeting.isEmpty) {
    //     return false;
    //   } else {
    //     final leadDate = DateTime.parse(lead.next_meeting);
    //     return leadDate.year == tomorrowDate.year &&
    //         leadDate.month == tomorrowDate.month &&
    //         leadDate.day == tomorrowDate.day;
    //   }
    // });
  }

  @override
  Widget build(BuildContext context) {
    final boxCountList = [0, 0, 0, 0];
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
                                builder: (context) => boxNavigationList[index],
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
                  Container(
                    height: 250,
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.blue.shade100),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 5,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: BarChart(
                      BarChartData(
                        alignment: BarChartAlignment.spaceAround,
                        maxY: 10,
                        barTouchData: BarTouchData(enabled: true),
                        // gridData: FlGridData(show: false),
                        titlesData: FlTitlesData(
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: true),
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, _) {
                                const titles = [
                                  'New',
                                  'Contacted',
                                  'Converted',
                                  'Closed',
                                ];
                                return Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Text(
                                    titles[value.toInt()],
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                );
                              },
                              reservedSize: 30,
                            ),
                          ),
                          rightTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          topTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                        ),
                        borderData: FlBorderData(show: false),
                        barGroups: [
                          _makeBarData(0, 6, Colors.red),
                          _makeBarData(1, 8, Colors.orange),
                          _makeBarData(2, 4, Colors.green),
                          _makeBarData(3, 7, Colors.blue),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Lead By Source",
                    style: TextStyle(color: Colors.blue, fontSize: 17),
                  ),
                  const SizedBox(height: 16),
                  //pie chart
                  Container(
                    height: 250,
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.blue.shade100),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 5,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: PieChart(
                      PieChartData(
                        sections: [
                          _getPieChartSections(Colors.red, 40, "New"),
                          _getPieChartSections(Colors.yellow, 40, "Contacted"),
                          _getPieChartSections(Colors.green, 40, "Converted"),
                          _getPieChartSections(Colors.blue, 40, "Closed"),
                        ],
                        centerSpaceRadius: 0,
                        sectionsSpace: 0,
                        borderData: FlBorderData(show: false),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  BarChartGroupData _makeBarData(int x, double y, Color color) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: color,
          width: 18,
          borderRadius: BorderRadius.circular(4),
        ),
      ],
    );
  }

  PieChartSectionData _getPieChartSections(
    Color color,
    int value,
    String title,
  ) {
    return PieChartSectionData(
      color: color,
      value: value.toDouble(),
      title: title,
      radius: 100,
      titleStyle: const TextStyle(color: Colors.white, fontSize: 12),
    );
  }
}
