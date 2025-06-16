import 'dart:ffi';

import 'package:capital_care/controllers/providers/lead_provider.dart';
import 'package:capital_care/controllers/providers/userprovider.dart';
import 'package:capital_care/models/calls_model.dart';
import 'package:capital_care/models/employee_model.dart';
import 'package:capital_care/models/history_model.dart';
import 'package:capital_care/models/leads_model.dart';

import 'package:capital_care/services/api_service.dart';
import 'package:capital_care/theme/appcolors.dart';
import 'package:capital_care/views/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';

class CallDetailsScreen extends StatefulWidget {
  final lead;
  final number;
  CallDetailsScreen({super.key, this.lead, this.number});

  @override
  State<CallDetailsScreen> createState() => _CallDetailsScreenState();
}

class _CallDetailsScreenState extends State<CallDetailsScreen> {
  String? feedbackStatus;

  String? priority;

  String? source;

  final TextEditingController nextMeetingController = TextEditingController();

  final TextEditingController budgetController = TextEditingController();

  final TextEditingController remarkController = TextEditingController();
  final TextEditingController contactNameController = TextEditingController();

  final TextEditingController descriptionController = TextEditingController();

  void handleSubmission() async {
    updateCall();
    if (feedbackStatus == null) {
      feedbackStatus = widget.lead.status;
    }

    if (priority == null) {
      priority = widget.lead.priority;
    }
    if (nextMeetingController.text.isEmpty) {
      nextMeetingController.text = widget.lead.next_meeting;
    }
    if (budgetController.text.isEmpty) {
      budgetController.text = widget.lead.est_budget;
    }
    if (remarkController.text.isEmpty) {
      remarkController.text = widget.lead.remark;
    }

    Leads updateLead = Leads(
      status: feedbackStatus!,
      priority: priority!,
      next_meeting: nextMeetingController.text,
      est_budget: budgetController.text,
      remark: remarkController.text,
    );

    History newHistory = History(
      lead_id: widget.lead.lead_id,
      owner: widget.lead.owner,
      next_meeting: nextMeetingController.text,
      status: feedbackStatus,
      remark: remarkController.text,
    );

    bool success1 = await ApiService.updateLead(
      widget.lead.lead_id,
      updateLead,
    );
    bool success2 = await ApiService.addHistory(newHistory);
    Provider.of<LeadProvider>(context, listen: false).addLead();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(success1 && success2 ? "success" : "Error")),
    );
    if (success1 && success2) {
      Navigator.pop(context);
    }
  }

  void updateCall() async {
    print("==================================> update call called");
    final storage = FlutterSecureStorage();
    final userId = await storage.read(key: "userId");

    if (userId == null) {
      print("User ID not found");
      return;
    }

    List<Calls> callList = await ApiService.getCalls(userId);

    if (callList.isEmpty) {
      print("No calls found for this user");
      return;
    }

    Calls newCall = Calls(remark: remarkController.text);

    bool success = await ApiService.updateCall(newCall, callList[0].call_id);

    print(
      success
          ? "=================> Call updated successfully"
          : "Failed to update call",
    );
  }

  void addLeadSubmission() async {
    updateCall();
    if (contactNameController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("fill contact name")));
      return;
    }
    final user = Provider.of<UserProvider>(context, listen: false).user;
    Leads newLead = Leads(
      name: contactNameController.text,
      number: widget.number,
      person_id: user?.empId,
      owner: user?.ename,
      source: source,
      description: descriptionController.text,
      status: feedbackStatus,
      next_meeting: nextMeetingController.text,
      remark: remarkController.text,
      est_budget: budgetController.text,
    );
    bool success = await ApiService.addLead(newLead);
    Provider.of<LeadProvider>(context, listen: false).addLead(newLead);
    updateHistory(user?.ename, user?.empId);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(success ? "Success" : "error")));

    if (success) Navigator.pop(context);
  }

  void updateHistory(ename, emp_id) async {
    List<Leads> leads = Provider.of<LeadProvider>(context, listen: false).leads;

    History newHistory = History(
      lead_id: leads[0].lead_id + 1,
      owner: ename,
      next_meeting: nextMeetingController.text,
      status: feedbackStatus,
      remark: remarkController.text,
    );
    await ApiService.addHistory(newHistory);

    Calls call = Calls(
      lead_id: leads[0].lead_id + 1,
      emp_id: emp_id,
      name: contactNameController.text,
      number: widget.number,
    );
    await ApiService.addCalls(call);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        title: const Text('You just called.....'),
        automaticallyImplyLeading: false,
        foregroundColor: AppColors.appBarForegroundColor,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.close),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.check_circle,
                    size: 70,
                    color: Color(0xFF03A9F4),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.lead == null
                            ? widget.number
                            : widget.lead.number,
                        style: TextStyle(fontSize: 20, color: Colors.black54),
                      ),
                      Text(
                        widget.lead == null ? "" : widget.lead.name,
                        style: TextStyle(fontSize: 16, color: Colors.black54),
                      ),
                      const Text(
                        '01:31:46',
                        style: TextStyle(fontSize: 16, color: Colors.black54),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 20),

              /// Feedback Status Dropdown
              buildDropdown(
                value: feedbackStatus,
                hint: 'Select Feedback Status',
                items: [
                  'Interested',
                  'Call Back',
                  'No Requirement',
                  'Follow up',
                  'Document Rejected',
                  'Document Pending',
                  'File Login',
                  'Loan Section',
                  'Loan Disbursement',
                ],
                onChanged: (val) => setState(() => feedbackStatus = val!),
              ),

              /// Priority Dropdown
              buildDropdown(
                value: priority,
                hint: 'Select Priority',
                items: [
                  'High Priority and Urgent',
                  'Med',
                  'Lower',
                  "Important",
                ],
                onChanged: (val) => setState(() => priority = val!),
              ),

              GestureDetector(
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(DateTime.now().year + 1),
                  );
                  if (pickedDate != null) {
                    nextMeetingController.text =
                        pickedDate.toLocal().toString().split(
                          ' ',
                        )[0]; // or use DateFormat
                  }
                },
                child: AbsorbPointer(
                  child: TextFormField(
                    controller: nextMeetingController,
                    decoration: InputDecoration(
                      hintText: 'Select Next Meeting Date',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ),

              /// Next Meeting DateTime Dropdown (Dummy)
              // buildDropdown(
              //   value: nextMeeting,
              //   hint: 'Select Next Meeting DateTime',
              //   items: ['Today 4 PM', 'Tomorrow 11 AM', 'Next Monday'],
              //   onChanged: (val) => setState(() => nextMeeting = val),
              // ),

              /// Estimation Date Dropdown (Dummy)
              // buildDropdown(
              //   value: estimationDate,
              //   hint: 'Select Estimation Date',
              //   items: ['10 May 2025', '12 May 2025', '15 May 2025'],
              //   onChanged: (val) => setState(() => estimationDate = val),
              // ),

              /// Budget
              buildTextField(
                controller: budgetController,
                hint: 'EstimationBudget',
                keyboardType: TextInputType.number,
              ),

              /// Remark
              buildTextField(controller: remarkController, hint: 'Remark'),
              SizedBox(height: 10),

              if (widget.lead == null)
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Contact Details",
                        style: TextStyle(
                          fontSize: 20,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      buildTextField(
                        controller: contactNameController,
                        hint: "Contact Name",
                      ),
                      buildDropdown(
                        value: source,
                        hint: "--Select Source--",
                        items: [
                          "Internet",
                          "Newspaper",
                          "Website",
                          "Refrence",
                          "Bulk excel",
                        ],
                        onChanged: (value) {
                          source = value;
                          setState(() {});
                        },
                      ),
                      buildTextField(
                        controller: descriptionController,
                        hint: "Description",
                      ),
                    ],
                  ),
                ),

              SizedBox(height: 20),

              /// Submit Button
              CustomButton(
                text: "SUBMIT",
                onPressed: () {
                  if (widget.lead == null) {
                    addLeadSubmission();
                  } else {
                    handleSubmission();
                  }
                },
              ),

              const SizedBox(height: 20),
              const Text(
                'fetching Recording file ...Please Wait',
                style: TextStyle(color: Colors.black54),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildDropdown({
    // required BuildContext context,
    required String? value,
    required String hint,
    required List<String> items,
    required void Function(String?) onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black38),
        borderRadius: BorderRadius.circular(5),
      ),
      child: DropdownButtonFormField<String>(
        value: value,
        isExpanded: true,
        dropdownColor: Colors.white,
        decoration: const InputDecoration(border: InputBorder.none),
        hint: Text(hint),
        style: const TextStyle(color: Colors.black87, fontSize: 16),
        items:
            items
                .map(
                  (item) => DropdownMenuItem<String>(
                    value: item,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 14,
                      ),
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: Colors.grey, width: 0.8),
                        ),
                      ),
                      width: double.infinity,
                      child: Text(item),
                    ),
                  ),
                )
                .toList(),
        onChanged: onChanged,
        selectedItemBuilder: (context) {
          return items.map((item) {
            return Align(alignment: Alignment.centerLeft, child: Text(item));
          }).toList();
        },
      ),
    );
  }

  Widget buildTextField({
    required TextEditingController controller,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        keyboardType: keyboardType,
        controller: controller,
        decoration: InputDecoration(
          hintText: hint,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}
