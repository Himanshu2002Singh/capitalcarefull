import 'package:capital_care/controllers/providers/calls_provider.dart';
import 'package:capital_care/models/calls_model.dart';
import 'package:capital_care/services/api_service.dart';
import 'package:capital_care/theme/appcolors.dart';
import 'package:capital_care/views/widgets/app_scaffold.dart';
import 'package:capital_care/views/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CallLogsScreen extends StatefulWidget {
  final String? title;

  const CallLogsScreen({super.key, this.title});

  @override
  State<CallLogsScreen> createState() => _CallLogsScreenState();
}

class _CallLogsScreenState extends State<CallLogsScreen> {
  List<Calls> callLogs = [];
  DateTime? startDate;
  DateTime? endDate;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    final today = DateTime.now();
    startDate =
        widget.title != "Today Calls"
            ? DateTime(2025, 5, 1)
            : DateTime(today.year, today.month, today.day);
    endDate = DateTime(today.year, today.month, today.day);
    fetchCallLogs();
  }

  Future<void> fetchCallLogs() async {
    setState(() => isLoading = true);
    try {
      if (startDate != null && endDate != null) {
        callLogs = await ApiService.getCallsByDates(
          startDate: startDate,
          endDate: endDate!.add(const Duration(days: 1)),
        );
      } else {
        callLogs =
            widget.title != "Today Calls"
                ? await Provider.of<CallsProvider>(context, listen: false).calls
                : await Provider.of<CallsProvider>(
                  context,
                  listen: false,
                ).todayCalls;
      }
    } catch (e) {
      print("Error fetching call logs: $e");
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> _selectStartDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: startDate ?? DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() => startDate = picked);
      if (endDate != null) fetchCallLogs();
    }
  }

  Future<void> _selectEndDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: endDate ?? DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() => endDate = picked);
      if (startDate != null) fetchCallLogs();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      isFloatingActionButton: false,
      appBar: CustomAppbar(title: "Call Logs"),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width - 20,
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.lightBlue.shade100, Colors.lightBlue.shade50],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: (MediaQuery.of(context).size.width - 60) / 2,
                    child: ElevatedButton(
                      onPressed: _selectStartDate,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                      ),
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          startDate != null
                              ? "Start: ${DateFormat('d MMM yyyy').format(startDate!)}"
                              : "Pick Start Date",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: (MediaQuery.of(context).size.width - 60) / 2,
                    child: ElevatedButton(
                      onPressed: _selectEndDate,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                      ),
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          endDate != null
                              ? "End: ${DateFormat('d MMM yyyy').format(endDate!)}"
                              : "Pick End Date",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child:
                  isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : callLogs.isEmpty
                      ? const Center(child: Text("No call logs found"))
                      : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        itemCount: callLogs.length,
                        itemBuilder: (context, index) {
                          final call = callLogs[index];
                          return Card(
                            elevation: 4,
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 8.0,
                              ),
                              child: ListTile(
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                ),
                                leading: CircleAvatar(
                                  backgroundColor: Colors.indigo,
                                  child: Text(
                                    call.name.isNotEmpty
                                        ? call.name[0].toUpperCase()
                                        : '?',
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                                title: Text(
                                  call.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 4),
                                    Text("Number: ${call.number}"),
                                    Text(
                                      "Time: ${formatDateTime(call.createdAt)}",
                                    ),
                                    const SizedBox(height: 6),

                                    // 👇 Responsive Remark Row
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // Expanded to prevent overflow
                                        Expanded(
                                          child: Text(
                                            call.remark != null &&
                                                    call.remark!
                                                        .trim()
                                                        .isNotEmpty
                                                ? "Remark: ${call.remark}"
                                                : "Remark: No remark available",
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),

                                        const SizedBox(width: 4),

                                        // View button (tap to show full remark)
                                        InkWell(
                                          onTap: () {
                                            showDialog(
                                              context: context,
                                              builder:
                                                  (context) => AlertDialog(
                                                    title: const Text(
                                                      "Call Remark",
                                                    ),
                                                    content: Text(
                                                      call.remark != null &&
                                                              call.remark != ""
                                                          ? call.remark
                                                          : 'No remark available.',
                                                      style: const TextStyle(
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                    actions: [
                                                      TextButton(
                                                        onPressed:
                                                            () =>
                                                                Navigator.of(
                                                                  context,
                                                                ).pop(),
                                                        child: const Text(
                                                          "Close",
                                                        ),
                                                      ),
                                                    ],
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            12,
                                                          ),
                                                    ),
                                                  ),
                                            );
                                          },
                                          child: Text(
                                            " (view)",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: AppColors.primaryColor,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
            ),
          ],
        ),
      ),
    );
  }
}

String formatDateTime(String dateTimeString) {
  if (dateTimeString.isEmpty) return "";
  final dateTime = DateTime.parse(dateTimeString).toLocal();
  return DateFormat('d MMM yyyy, hh:mm a').format(dateTime);
}
