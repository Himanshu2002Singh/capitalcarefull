import 'package:capital_care/controllers/providers/userprovider.dart';
import 'package:capital_care/models/history_model.dart';
import 'package:capital_care/services/api_service.dart';
import 'package:capital_care/theme/appcolors.dart';
import 'package:capital_care/views/screens/leads/add_lead_screen.dart';
import 'package:capital_care/views/screens/task/add_task_screen.dart';
import 'package:capital_care/views/screens/call_details_screen.dart';
import 'package:capital_care/views/widgets/app_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class LeadDetailsScreen extends StatefulWidget {
  final lead;

  const LeadDetailsScreen({super.key, required this.lead});

  @override
  _LeadDetailsScreenState createState() => _LeadDetailsScreenState();
}

class _LeadDetailsScreenState extends State<LeadDetailsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<History> history = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    fetchHistory();
  }

  void fetchHistory() async {
    history = await ApiService.getHistory(widget.lead.lead_id);
    setState(() {});
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return AppScaffold(
      isFloatingActionButton: true,
      floatingActionButtonIcon: Icon(Icons.add),
      floatingActionButtonOnTap: () {
        if (_tabController.index == 2) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddTaskScreen()),
          );
        } else {
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(builder: (context) => CallDetailsScreen()),
          // );
        }
      },
      appBar: AppBar(
        elevation: 0,
        title: Text("Lead Details"),
        backgroundColor: AppColors.primaryColor,
        foregroundColor: AppColors.appBarForegroundColor,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: Container(
            color: const Color.fromARGB(
              255,
              239,
              238,
              238,
            ), // Background for TabBar
            child: TabBar(
              dividerColor: Colors.transparent,
              padding: EdgeInsets.only(top: 10, left: 10, right: 10),
              controller: _tabController,
              tabs: const [
                Tab(text: "DETAILS"),
                Tab(text: "HISTORY"),
                Tab(text: "TASK"),
              ],
              labelColor: Colors.white, // Text color when selected
              unselectedLabelColor:
                  Colors.black, // Text color when not selected
              indicatorSize: TabBarIndicatorSize.tab,
              indicator: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color.fromARGB(255, 168, 223, 248),
                    AppColors.primaryColor,
                  ],
                  begin: Alignment.topRight,
                  end: Alignment.topLeft,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ),

      body: TabBarView(
        controller: _tabController,
        children: [buildDetailsTab(), buildHistory(), buildTaskTab()],
      ),
    );
  }

  Widget buildDetailsTab() {
    DateTime d1 = DateTime.parse(widget.lead.next_meeting);
    DateTime d2 = DateTime.parse(widget.lead.createdAt);
    final int daysDiff = ((d1).difference(d2).inDays);
    final user = Provider.of<UserProvider>(context).user;

    return SingleChildScrollView(
      child: Container(
        color: const Color.fromARGB(255, 239, 238, 238), // B,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              // Main card
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            widget.lead.name,
                            style: TextStyle(fontSize: 20),
                          ),
                          IconButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => AddLeadScreen(
                                        title: "Edit Lead",
                                        userId: user?.empId ?? "",
                                        userName: user?.ename ?? "",
                                        lead_id: widget.lead.lead_id,
                                        contactName: widget.lead.name,
                                        contactNumber: widget.lead.number,
                                        email: widget.lead.email,
                                        // branch: widget.lead.branch,
                                        source: widget.lead.source,
                                        priority: widget.lead.priority,
                                        status: widget.lead.status,
                                        next_meeting: widget.lead.next_meeting,
                                        refrence: widget.lead.refrence,
                                        description: widget.lead.description,
                                        address: widget.lead.address,
                                        loanType: widget.lead.loanType,
                                      ),
                                ),
                              );
                            },
                            icon: Icon(Icons.edit),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              widget.lead.est_budget == ""
                                  ? "\u20B9 0.00"
                                  : "\u20B9 ${widget.lead.est_budget}",
                            ),
                          ),
                          Expanded(
                            child: Text(
                              (widget.lead.next_meeting).substring(0, 10),
                            ),
                          ),
                          Expanded(child: Text("$daysDiff days")),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Icon(Icons.email, size: 18),
                          SizedBox(width: 6),
                          Text(widget.lead.email),
                        ],
                      ),
                      SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(Icons.phone, size: 18),
                          SizedBox(width: 6),
                          Text(widget.lead.number),
                        ],
                      ),
                      SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(Icons.location_on, size: 18),
                          SizedBox(width: 6),
                          Expanded(child: Text(widget.lead.email)),
                        ],
                      ),
                      SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(Icons.calendar_today, size: 18),
                          SizedBox(width: 6),
                          Text(formatDateTime(widget.lead.createdAt)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 20),
              // Other Details Section
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Other Details",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Divider(),
                    _buildDetailRow("Assigned To :", widget.lead.owner),
                    _buildDetailRow("Added By :", widget.lead.owner),
                    _buildDetailRow("Source :", widget.lead.source),
                    _buildDetailRow("Reference", widget.lead.refrence),
                    _buildDetailRow("Description", widget.lead.description),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildHistory() {
    // setState(() {});
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children:
              history.map((entry) {
                // int index = history.indexOf(entry);
                // bool isLast = index == history.length - 1;
                // print(entry);

                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      alignment: Alignment.topLeft,
                      width: 60,
                      // padding: EdgeInsets.only(top: 12),
                      child: Text(
                        "${formatDate(entry.createdAt)} \n${formatTime(entry.createdAt)}",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.start,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Column(
                        children: [
                          Container(
                            height: 25,
                            width: 25,
                            decoration: BoxDecoration(
                              color: Colors.green,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: const Color.fromARGB(255, 203, 202, 202),
                                width: 3,
                                style: BorderStyle.solid,
                              ),
                            ),
                          ),

                          Container(
                            // margin: EdgeInsets.only(left: 15),
                            width: 2,
                            height: 100, // adjust this height based on spacing
                            color: Colors.grey.shade400,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Container(
                        // margin: EdgeInsets.symmetric(vertical: 10),
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "User : ${entry.owner}",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 4),
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: "Status : ",
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  TextSpan(
                                    text: entry.status,
                                    style: TextStyle(
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              "Schedule : ${formatDateTime(entry.next_meeting)}",
                              style: TextStyle(color: Colors.purple),
                            ),
                            SizedBox(height: 2),
                            Text(
                              "Remark : ${entry.remark}",
                              style: TextStyle(color: Colors.brown),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              }).toList(),
        ),
      ),
    );
  }

  Widget buildTaskTab() {
    return Center(child: Text("No data found"));
  }

  Widget _buildDetailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("$title ", style: TextStyle(color: Colors.blue)),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}

String formatDate(String dateTimeString) {
  final dateTime = DateTime.parse(dateTimeString);
  final formatter = DateFormat('d MMM');
  return formatter.format(dateTime);
}

String formatTime(String dateTimeString) {
  final dateTime = DateTime.parse(dateTimeString);
  final formatter = DateFormat('hh:mm a');
  return formatter.format(dateTime);
}

String formatDateTime(String dateTimeString) {
  final dateTime = DateTime.parse(dateTimeString);
  final formatter = DateFormat('d-MMM-yyyy hh:mm a');
  return formatter.format(dateTime);
}

// class HistoryEntry {
//   final String dateTime;
//   final String user;
//   final String status;
//   final String schedule;
//   final String remark;

//   HistoryEntry({
//     required this.dateTime,
//     required this.user,
//     required this.status,
//     required this.schedule,
//     required this.remark,
//   });
// }
