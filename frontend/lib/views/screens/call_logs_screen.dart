import 'package:capital_care/models/calls_model.dart';
import 'package:capital_care/services/api_service.dart';
import 'package:capital_care/views/widgets/app_scaffold.dart';
import 'package:capital_care/views/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';

class CallLogsScreen extends StatefulWidget {
  @override
  State<CallLogsScreen> createState() => _CallLogsScreenState();
}

class _CallLogsScreenState extends State<CallLogsScreen> {
  List<Calls> callLogs = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchCallLogs();
  }

  void fetchCallLogs() async {
    final storage = FlutterSecureStorage();
    final userId = await storage.read(key: "userId");
    callLogs = await ApiService.getCalls(userId!);
    setState(() {});
  }

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
                  Text('Time: ${formatDateTime(call.createdAt)}'),
                  // Text('Status: ${call.status}'),
                ],
              ),
              // trailing: PriorityChip(priority: call.priority),
            ),
          );
        },
      ),
    );
  }
}

String formatDateTime(String dateTimeString) {
  if (dateTimeString.isEmpty || dateTimeString == null) {
    return "";
  }
  final dateTime = DateTime.parse(dateTimeString).toLocal();
  final formatter = DateFormat('d MMM yyyy hh:mm a');
  return formatter.format(dateTime);
}
