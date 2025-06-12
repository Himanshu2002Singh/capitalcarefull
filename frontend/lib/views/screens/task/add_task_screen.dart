import 'package:capital_care/controllers/providers/lead_provider.dart';
import 'package:capital_care/controllers/providers/userprovider.dart';
import 'package:capital_care/models/leads_model.dart';
import 'package:capital_care/models/task_model.dart';
import 'package:capital_care/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dropdown_search/dropdown_search.dart';

import 'package:capital_care/theme/appcolors.dart';
import 'package:capital_care/views/widgets/custom_appbar.dart';
import 'package:capital_care/views/widgets/custom_button.dart';

class AddTaskScreen extends StatefulWidget {
  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  Leads? selectedLead;
  String? priority;

  DateTime? startDate;
  DateTime? endDate;

  bool isActive = false;

  final descriptionController = TextEditingController();
  final nameController = TextEditingController();

  void handle_submit() async {
    if (nameController.text == null || nameController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Title can't be empty")));
      return;
    }

    Task newTask = Task(
      emp_id: Provider.of<UserProvider>(context, listen: false).user?.empId,
      title: nameController.text,
      choose_lead: selectedLead?.name,
      start_date: startDate?.toIso8601String(),
      end_date: endDate?.toIso8601String(),
      priority: priority,
      is_active: isActive,
      description: descriptionController.text,
    );

    bool success = await ApiService.addTask(newTask);
    print(
      "==============================================>>>>>>>>>>submit called after",
    );
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(success ? "Success" : "Error")));
    if (success) {
      Navigator.pop(context);
    }
  }

  Future<void> _selectDateTime(BuildContext context, bool isStart) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime(2030),
    );

    if (picked != null) {
      setState(() {
        if (isStart) {
          startDate = picked;
        } else {
          endDate = picked;
        }
      });
    }
  }

  List<Leads> getFilteredLeads(String? filter, List<Leads> allLeads) {
    if (filter == null || filter.isEmpty) {
      return allLeads.take(10).toList(); // load initial 10
    } else {
      return allLeads
          .where(
            (lead) => lead.name.toLowerCase().contains(filter.toLowerCase()),
          )
          .take(10)
          .toList(); // filtered with limit
    }
  }

  @override
  Widget build(BuildContext context) {
    final allLeads = Provider.of<LeadProvider>(context, listen: false).leads;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppbar(title: "Add Task", leading: const BackButton()),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Add Title"),
            const SizedBox(height: 6),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                hintText: "Name",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),
            const Text("Choose Lead"),
            DropdownSearch<Leads>(
              selectedItem: selectedLead,
              items: allLeads,
              onChanged: (Leads? lead) => setState(() => selectedLead = lead),
              dropdownBuilder: (BuildContext context, Leads? selectedItem) {
                return Text(
                  selectedItem?.name ?? 'Lead Name',
                  style: const TextStyle(fontSize: 16),
                );
              },
              itemAsString: (Leads l) => l.name,
              compareFn: (Leads a, Leads b) => a.lead_id == b.lead_id,
              popupProps: PopupProps.menu(
                showSearchBox: true,
                searchFieldProps: const TextFieldProps(
                  decoration: InputDecoration(
                    hintText: 'Search lead...',
                    border: OutlineInputBorder(),
                  ),
                ),
                fit: FlexFit.loose,
                constraints: const BoxConstraints(maxHeight: 300),
                menuProps: MenuProps(
                  backgroundColor: Colors.white,
                  elevation: 6,
                  borderRadius: BorderRadius.circular(10),
                  shadowColor: Colors.black26,
                  // padding: const EdgeInsets.symmetric(vertical: 8),
                ),
                itemBuilder: (context, Leads item, bool isSelected) {
                  return Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color:
                          isSelected
                              ? AppColors.primaryColor.withOpacity(0.1)
                              : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      item.name,
                      style: TextStyle(
                        fontSize: 16,
                        color:
                            isSelected
                                ? AppColors.primaryColor
                                : Colors.black87,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  );
                },
              ),

              dropdownDecoratorProps: const DropDownDecoratorProps(
                dropdownSearchDecoration: InputDecoration(
                  // labelText: 'Choose Lead',
                  hintText: "Lead Name",
                  border: OutlineInputBorder(),
                ),
              ),
            ),

            const SizedBox(height: 16),
            const Text("Task Start Date"),
            GestureDetector(
              onTap: () => _selectDateTime(context, true),
              child: AbsorbPointer(
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText:
                        startDate != null
                            ? "${startDate!.toLocal()}".split(' ')[0]
                            : 'Select date',
                    border: const OutlineInputBorder(),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),
            const Text("Task End Date"),
            GestureDetector(
              onTap: () => _selectDateTime(context, false),
              child: AbsorbPointer(
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText:
                        endDate != null
                            ? "${endDate!.toLocal()}".split(' ')[0]
                            : 'Select date',
                    border: const OutlineInputBorder(),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            const Text("Task Priority"),
            buildDropdown(
              value: priority,
              hint: 'Select Priority',
              items: ['High', 'Mid', 'Low', 'Important'],
              onChanged: (val) => setState(() => priority = val),
            ),

            Row(
              children: [
                Checkbox(
                  value: isActive,
                  onChanged:
                      (value) => setState(() => isActive = value ?? false),
                ),
                const Text("Active Task"),
              ],
            ),

            const Text("Description"),
            TextField(
              controller: descriptionController,
              maxLines: 4,
              decoration: const InputDecoration(
                hintText: "Write about task.",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),
            CustomButton(
              text: "Add Task",
              onPressed: () {
                // TODO: Add Task Logic Here
                handle_submit();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget buildDropdown({
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
                  (item) =>
                      DropdownMenuItem<String>(value: item, child: Text(item)),
                )
                .toList(),
        onChanged: onChanged,
      ),
    );
  }
}
