import 'package:capital_care/controllers/providers/userprovider.dart';
import 'package:capital_care/models/task_model.dart';
import 'package:capital_care/services/api_service.dart';
import 'package:capital_care/theme/appcolors.dart';
import 'package:capital_care/views/screens/task/add_task_screen.dart';
import 'package:capital_care/views/widgets/app_scaffold.dart';
import 'package:capital_care/views/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class TasksAssignedByMeScreen extends StatefulWidget {
  TasksAssignedByMeScreen({super.key});

  @override
  State<TasksAssignedByMeScreen> createState() =>
      _TasksAssignedByMeScreenState();
}

class _TasksAssignedByMeScreenState extends State<TasksAssignedByMeScreen> {
  List<Task> originalTasks = [];
  List<Task> filteredTasks = [];

  @override
  void initState() {
    super.initState();
    fetchTasks();
  }

  void fetchTasks() async {
    String? userId =
        Provider.of<UserProvider>(context, listen: false).user?.empId;
    if (userId != null) {
      originalTasks = await ApiService.getTasks(userId);
      filteredTasks = List.from(originalTasks);
      setState(() {});
    }
  }

  void filterTasks(String query) {
    if (query.isEmpty) {
      filteredTasks = List.from(originalTasks);
    } else {
      filteredTasks =
          originalTasks
              .where(
                (task) =>
                    task.title.toLowerCase().contains(query.toLowerCase()),
              )
              .toList();
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      isFloatingActionButton: true,
      floatingActionButtonIcon: const Icon(Icons.add),
      floatingActionButtonOnTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AddTaskScreen()),
        );
      },
      appBar: CustomAppbar(title: "Tasks Assigned By Me"),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            color: AppColors.primaryColor,
            child: SearchBar(
              constraints: const BoxConstraints(minHeight: 40),
              hintText: "Search by Task Name",
              hintStyle: MaterialStateProperty.all(
                const TextStyle(color: Colors.grey),
              ),
              leading: Icon(Icons.search, color: AppColors.primaryColor),
              backgroundColor: MaterialStateProperty.all(Colors.white),
              onChanged: filterTasks,
            ),
          ),
          Expanded(
            child:
                filteredTasks.isEmpty
                    ? const Center(child: Text("No matching tasks found."))
                    : ListView.builder(
                      padding: const EdgeInsets.all(10),
                      itemCount: filteredTasks.length,
                      itemBuilder: (context, index) {
                        final t = filteredTasks[index];
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
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
                                                      content: Text(
                                                        t.description,
                                                      ),
                                                      actions: [
                                                        TextButton(
                                                          onPressed:
                                                              () =>
                                                                  Navigator.pop(
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
        ],
      ),
    );
  }
}

String formatDateTime(String dateTimeString) {
  if (dateTimeString.isEmpty) {
    return "";
  }
  final dateTime = DateTime.parse(dateTimeString);
  final formatter = DateFormat('d-MMM-yyyy hh:mm a');
  return formatter.format(dateTime);
}
