import 'package:capital_care/views/widgets/app_scaffold.dart';
import 'package:capital_care/views/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';

class CallLogsScreen extends StatelessWidget {
  final List<CallLogEntry> callLogs = [
    CallLogEntry(
      name: 'John Doe',
      number: '+91 9876543210',
      time: '10:30 AM',
      status: 'Missed',
      priority: 'High',
    ),
    CallLogEntry(
      name: 'Alice Smith',
      number: '+91 9123456780',
      time: '9:15 AM',
      status: 'Received',
      priority: 'Normal',
    ),
    CallLogEntry(
      name: 'Bob Johnson',
      number: '+91 8000123456',
      time: 'Yesterday',
      status: 'Dialed',
      priority: 'Low',
    ),
    // Add more entries as needed
  ];

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      isFloatingActionButton: false,
      appBar: CustomAppbar(title: "Phone"),
      body: ListView.builder(
        itemCount: callLogs.length,
        itemBuilder: (context, index) {
          final call = callLogs[index];
          return Card(
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              leading: CircleAvatar(child: Text(call.name[0])),
              title: Text(call.name),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Number: ${call.number}'),
                  Text('Time: ${call.time}'),
                  Text('Status: ${call.status}'),
                ],
              ),
              trailing: PriorityChip(priority: call.priority),
            ),
          );
        },
      ),
    );
  }
}

class CallLogEntry {
  final String name;
  final String number;
  final String time;
  final String status;
  final String priority;

  CallLogEntry({
    required this.name,
    required this.number,
    required this.time,
    required this.status,
    required this.priority,
  });
}

class PriorityChip extends StatelessWidget {
  final String priority;

  const PriorityChip({required this.priority});

  Color get color {
    switch (priority.toLowerCase()) {
      case 'high':
        return Colors.redAccent;
      case 'normal':
        return Colors.orange;
      case 'low':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(priority),
      backgroundColor: color.withOpacity(0.2),
      labelStyle: TextStyle(color: color, fontWeight: FontWeight.bold),
    );
  }
}
