import 'package:capital_care/controllers/providers/calls_provider.dart';
import 'package:capital_care/controllers/providers/history_provider.dart';
import 'package:capital_care/controllers/providers/userprovider.dart';
import 'package:capital_care/models/calls_model.dart';
import 'package:capital_care/models/history_model.dart';
import 'package:capital_care/models/task_model.dart';
import 'package:capital_care/services/api_service.dart';
import 'package:capital_care/theme/appcolors.dart';
import 'package:capital_care/views/screens/leads/add_lead_screen.dart';
import 'package:capital_care/views/screens/task/add_task_screen.dart';
import 'package:capital_care/views/screens/call_details_screen.dart';
import 'package:capital_care/views/widgets/app_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
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
  List<Task> tasks = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    fetchHistory();
    fetchTasks();
  }

  void fetchHistory() async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<HistoryProvider>(
        context,
        listen: false,
      ).fetchHistory(widget.lead.lead_id);
    });
  }

  void fetchTasks() async {
    tasks = await ApiService.getTasksByLeadId(widget.lead.lead_id);
    setState(() {});
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> makeDirectCall(String number, dynamic lead) async {
    var status = await Permission.phone.status;
    if (!status.isGranted) {
      await Permission.phone.request();
    }

    if (await Permission.phone.isGranted) {
      await FlutterPhoneDirectCaller.callNumber(number);
      Future.delayed(const Duration(seconds: 2), () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CallDetailsScreen(lead: lead),
          ),
        );
      });

      submitCall(lead); // If needed, ensure this function is defined
    } else {
      print("CALL_PHONE permission denied");
    }
  }

  void submitCall(var lead) async {
    final storage = FlutterSecureStorage();
    final userId = await storage.read(key: "userId");
    Calls call = Calls(
      lead_id: lead.lead_id,
      emp_id: userId,
      name: lead.name,
      number: lead.number,
    );
    Provider.of<CallsProvider>(context, listen: false).addCall(call);
    // bool success = await ApiService.addCalls(call);
    // ScaffoldMessenger.of(
    //   context,
    // ).showSnackBar(SnackBar(content: Text(success ? "success" : "Error")));
  }

  Widget build(BuildContext context) {
    final historyProvider = Provider.of<HistoryProvider>(context, listen: true);
    history = historyProvider.history;
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
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CallDetailsScreen(lead: widget.lead),
            ),
          );
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
    int daysDiff = 0;
    bool formatError = false;
    try {
      DateTime d1 = DateTime.parse(widget.lead.next_meeting ?? "");
      DateTime d2 = DateTime.parse(widget.lead.createdAt ?? "");
      daysDiff = d1.difference(d2).inDays + 1;
    } catch (e) {
      daysDiff = 0;
      formatError = true;
    }

    final user = Provider.of<UserProvider>(context).user;

    return SafeArea(
      child: SingleChildScrollView(
        child: Container(
          color: const Color.fromARGB(255, 239, 238, 238),
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
                              widget.lead.name ?? '',
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
                                          contactName: widget.lead.name ?? '',
                                          contactNumber:
                                              widget.lead.number ?? '',
                                          email: widget.lead.email ?? '',
                                          source: widget.lead.source ?? '',
                                          priority: widget.lead.priority ?? '',
                                          status: widget.lead.status ?? '',
                                          next_meeting:
                                              widget.lead.next_meeting ?? '',
                                          refrence: widget.lead.refrence ?? '',
                                          description:
                                              widget.lead.description ?? '',
                                          address: widget.lead.address ?? '',
                                          loanType: widget.lead.loanType ?? '',
                                          dob: widget.lead.dob ?? '',
                                          loanAmount:
                                              widget.lead.est_budget ?? '',
                                          loanTerm: widget.lead.loan_term ?? '',
                                          employmentType:
                                              widget.lead.employment_type ?? '',
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
                                (widget.lead.est_budget == null ||
                                        widget.lead.est_budget == "")
                                    ? "\u20B9 0.00"
                                    : "\u20B9 ${widget.lead.est_budget}",
                              ),
                            ),
                            Expanded(
                              child: Text(
                                formatError
                                    ? ""
                                    : (widget.lead.createdAt ?? "").substring(
                                      0,
                                      10,
                                    ),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                "$daysDiff days",
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Icon(Icons.email, size: 18),
                            SizedBox(width: 6),
                            Text(widget.lead.email ?? ''),
                          ],
                        ),
                        SizedBox(height: 6),
                        GestureDetector(
                          onTap: () {
                            makeDirectCall(
                              widget.lead.number ?? '',
                              widget.lead,
                            );
                          },
                          child: Row(
                            children: [
                              Icon(Icons.phone, size: 18),
                              SizedBox(width: 6),
                              Text(widget.lead.number ?? ''),
                            ],
                          ),
                        ),
                        SizedBox(height: 6),
                        Row(
                          children: [
                            Icon(Icons.location_on, size: 18),
                            SizedBox(width: 6),
                            Expanded(child: Text(widget.lead.address ?? '')),
                          ],
                        ),
                        SizedBox(height: 6),
                        Row(
                          children: [
                            Icon(Icons.calendar_today, size: 18),
                            SizedBox(width: 6),
                            Text(
                              formatDateTime(widget.lead.next_meeting ?? ''),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Icon(Icons.calendar_month_rounded, size: 18),
                            Text(
                              " DOB : ",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(width: 6),
                            Expanded(child: Text(widget.lead.dob ?? '')),
                          ],
                        ),
                        SizedBox(height: 6),
                        Row(
                          children: [
                            Text(
                              "Loan Type :",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(width: 6),
                            Expanded(child: Text(widget.lead.loanType ?? '')),
                          ],
                        ),
                        SizedBox(height: 6),
                        Row(
                          children: [
                            Text(
                              "Loan Term :",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(width: 6),
                            Expanded(child: Text(widget.lead.loan_term ?? '')),
                          ],
                        ),
                        SizedBox(height: 6),
                        Row(
                          children: [
                            Text(
                              "Employment Type :",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(width: 6),
                            Expanded(
                              child: Text(widget.lead.employment_type ?? ''),
                            ),
                          ],
                        ),
                        SizedBox(height: 6),
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
                      _buildDetailRow("Assigned To :", widget.lead.owner ?? ''),
                      _buildDetailRow("Added By :", widget.lead.owner ?? ''),
                      _buildDetailRow("Source :", widget.lead.source ?? ''),
                      _buildDetailRow("Reference", widget.lead.refrence ?? ''),
                      _buildDetailRow(
                        "Description",
                        widget.lead.description ?? '',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildHistory() {
    return SafeArea(
      child: RefreshIndicator(
        onRefresh: () async {
          fetchHistory(); // Fetch latest data
          await Future.delayed(
            Duration(seconds: 1),
          ); // Fix: await should wrap a Future
        },
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children:
                  history.map((entry) {
                    String nextMeeting;
                    try {
                      nextMeeting = formatDateTime(entry.next_meeting ?? '');
                    } catch (e) {
                      nextMeeting = "";
                    }

                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          alignment: Alignment.topLeft,
                          width: 60,
                          child: Text(
                            "${formatDate(entry.createdAt ?? '')} \n${formatTime(entry.createdAt ?? '')}",
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
                                    color: const Color.fromARGB(
                                      255,
                                      203,
                                      202,
                                      202,
                                    ),
                                    width: 3,
                                    style: BorderStyle.solid,
                                  ),
                                ),
                              ),
                              Container(
                                width: 2,
                                height: 100,
                                color: Colors.grey.shade400,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "User : ${entry.owner ?? ''}",
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
                                        text: entry.status ?? '',
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
                                  "Loan Type : ${entry.loanType ?? ''}",
                                  style: TextStyle(color: Colors.purple),
                                ),
                                SizedBox(height: 2),
                                Text(
                                  "Schedule : $nextMeeting",
                                  style: TextStyle(color: Colors.purple),
                                ),
                                SizedBox(height: 2),
                                Text(
                                  "Remark : ${entry.remark ?? ''}",
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
        ),
      ),
    );
  }

  Widget buildTaskTab() {
    // String formatDateTime(String dateTimeString) {
    //   if (dateTimeString.isEmpty) {
    //     return "";
    //   }
    //   final dateTime = DateTime.parse(dateTimeString);
    //   final formatter = DateFormat('d-MMM-yyyy hh:mm a');
    //   return formatter.format(dateTime);
    // }

    return SafeArea(
      child: Expanded(
        child:
            tasks.isEmpty
                ? const Center(child: Text("No matching tasks found."))
                : ListView.builder(
                  padding: const EdgeInsets.all(10),
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    final t = tasks[index];
                    return Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 120,
                            height: 200,
                            decoration: BoxDecoration(
                              color: AppColors.primaryColor,
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(10),
                                bottomLeft: Radius.circular(10),
                              ),
                            ),
                            padding: const EdgeInsets.all(8),
                            child: Center(
                              child: Text(
                                formatDateTime(t.start_date),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          t.title,
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () {},
                                        icon: Icon(
                                          Icons.edit_rounded,
                                          size: 20,
                                          color: AppColors.primaryColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 5),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.person,
                                        color: Colors.grey,
                                      ),
                                      const SizedBox(width: 5),
                                      Text(
                                        t.choose_lead,
                                        style: const TextStyle(
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 5),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Icon(
                                        Icons.timer_outlined,
                                        color: Colors.grey,
                                      ),
                                      const SizedBox(width: 5),
                                      Expanded(
                                        child: Text(
                                          "${formatDateTime(t.start_date)} to ${formatDateTime(t.end_date)}",
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 5),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Icon(
                                        Icons.assignment,
                                        color: Colors.grey,
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Text(
                                          t.description,
                                          style: const TextStyle(
                                            color: Colors.grey,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 5),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          showDialog(
                                            context: context,
                                            builder:
                                                (context) => AlertDialog(
                                                  title: const Text(
                                                    "Task Description!",
                                                  ),
                                                  content: Text(t.description),
                                                  actions: [
                                                    TextButton(
                                                      onPressed:
                                                          () => Navigator.pop(
                                                            context,
                                                          ),
                                                      child: Text(
                                                        "Ok",
                                                        style: TextStyle(
                                                          color:
                                                              AppColors
                                                                  .primaryColor,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                          );
                                        },
                                        child: Text(
                                          "(see more...)",
                                          style: TextStyle(
                                            color: AppColors.primaryColor,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      InkWell(
                                        onTap: () {},
                                        child: const Icon(
                                          Icons.delete_rounded,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
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
  if (dateTimeString.isEmpty) {
    return "";
  }
  final dateTime = DateTime.parse(dateTimeString);
  final formatter = DateFormat('d MMM');
  return formatter.format(dateTime);
}

String formatTime(String dateTimeString) {
  if (dateTimeString.isEmpty) {
    return "";
  }
  final dateTime = DateTime.parse(dateTimeString).toLocal();
  final formatter = DateFormat('hh:mm a');
  return formatter.format(dateTime);
}

String formatDateTime(String dateTimeString) {
  if (dateTimeString.isEmpty) {
    return "";
  }
  final dateTime = DateTime.parse(dateTimeString).toLocal();
  final formatter = DateFormat('d-MMM-yyyy hh:mm a');
  return formatter.format(dateTime);
}
