import 'package:capital_care/theme/appcolors.dart';
import 'package:capital_care/views/widgets/custom_appbar.dart';
import 'package:capital_care/views/widgets/custom_button.dart';
import 'package:flutter/material.dart';

class AddTaskScreen extends StatefulWidget {
  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  String? leadName;
  String? assignUser;
  String? observerUser;
  String? priority = "Mid";

  DateTime? startDate;
  DateTime? endDate;

  bool isActive = false;

  final descriptionController = TextEditingController();
  final nameController = TextEditingController();

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
            items.map((item) {
              return DropdownMenuItem<String>(value: item, child: Text(item));
            }).toList(),
        onChanged: onChanged,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
            buildDropdown(
              value: leadName,
              hint: 'Lead Name',
              items: ['Alice', 'Bob', 'Charlie'],
              onChanged: (val) => setState(() => leadName = val),
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
                            : 'Select date and time',
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
                            : 'Select date and time',
                    border: const OutlineInputBorder(),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),
            const Text("Task Assign To"),
            buildDropdown(
              value: assignUser,
              hint: 'Select Assign User',
              items: ['User 1', 'User 2', 'User 3'],
              onChanged: (val) => setState(() => assignUser = val),
            ),

            const SizedBox(height: 16),
            const Text("Task Observer"),
            buildDropdown(
              value: observerUser,
              hint: 'Select Observer User',
              items: ['Observer A', 'Observer B'],
              onChanged: (val) => setState(() => observerUser = val),
            ),

            const SizedBox(height: 16),
            const Text("Task Priority"),
            buildDropdown(
              value: priority,
              hint: 'Select Priority',
              items: ['High', 'Mid', 'Low', 'Important'],
              onChanged: (val) => setState(() => priority = val),
            ),

            // const SizedBox(height: 10),
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

            const SizedBox(height: 10),
            const Text("Description"),
            TextField(
              controller: descriptionController,
              maxLines: 4,
              decoration: const InputDecoration(
                hintText: "Write about task.",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            CustomButton(text: "Add Task", onPressed: () {}),
          ],
        ),
      ),
    );
  }
}
