import 'package:capital_care/theme/appcolors.dart';
import 'package:capital_care/views/screens/auto_call_dashboard_screen.dart';
import 'package:capital_care/views/screens/call_logs_screen.dart';
import 'package:capital_care/views/screens/dashboard/dashboard_screen.dart';
import 'package:capital_care/views/screens/leads/leads_screen.dart';
import 'package:capital_care/views/screens/task/task_assigned_by_me.dart';
import 'package:capital_care/views/screens/task_management/task_management_screen.dart';
import 'package:capital_care/views/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';

class AppScaffold extends StatelessWidget {
  final appBar;
  final Widget body;
  final floatingActionButtonIcon;
  final floatingActionButtonOnTap;
  final isFloatingActionButton;
  final backgroundColor;

  const AppScaffold({
    super.key,
    required this.appBar,
    required this.body,
    this.floatingActionButtonIcon,
    this.floatingActionButtonOnTap,
    required this.isFloatingActionButton,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: appBar,
      drawer: _homeDrawer(context),
      body: body,

      floatingActionButton:
          isFloatingActionButton
              ? FloatingActionButton(
                backgroundColor: AppColors.primaryColor,
                foregroundColor: AppColors.appBarForegroundColor,
                onPressed: () {
                  floatingActionButtonOnTap();
                },
                child: floatingActionButtonIcon,
              )
              : null,
    );
  }

  Widget _homeDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(color: AppColors.primaryColor),
            child: Column(
              children: const [
                SizedBox(height: 10),
                CircleAvatar(radius: 45, child: Text("U")),
                SizedBox(height: 5),
                Text(
                  "User",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          ...[
            _drawerItem(
              Icons.dashboard,
              "Dashboard",
              onTap:
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DashboardScreen()),
                  ),
            ),
            _drawerItem(
              Icons.phone_in_talk_rounded,
              "AutoCall Dashboard",
              onTap:
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AutoCallDashboard(),
                    ),
                  ),
            ),
            _drawerItem(
              Icons.man,
              "Leads",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LeadsScreen()),
                );
              },
            ),
            _drawerItem(
              Icons.add_to_photos,
              "Add Task",
              section: "Task Management",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TasksAssignedByMeScreen(),
                  ),
                );
              },
            ),
            _drawerItem(
              Icons.note,
              "Task Management",
              onTap:
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TaskManagementScreen(),
                    ),
                  ),
            ),
            _drawerItem(
              Icons.history,
              "Call Logs",
              onTap:
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CallLogsScreen()),
                  ),
            ),
            _drawerItem(
              Icons.error_outline,
              "Performance Report",
              section: "Custom Menu",
            ),
            _drawerItem(
              Icons.view_headline,
              "Create CheckList",
              section: "Check List",
            ),
            _drawerItem(Icons.playlist_add, "Fill CheckList"),
            _drawerItem(Icons.playlist_add_check, "CheckList Report"),
            _drawerItem(Icons.security, "App Permission", section: "Policies"),
            _drawerItem(Icons.private_connectivity, "Privacy Policy"),
            _drawerItem(Icons.settings, "Settings"),
            _drawerItem(Icons.arrow_circle_left_outlined, "Sign Out"),
          ],
        ],
      ),
    );
  }

  Widget _drawerItem(
    IconData icon,
    String title, {
    String? section,
    VoidCallback? onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (section != null) ...[
          const Divider(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4),
            child: Text(section, style: const TextStyle(color: Colors.grey)),
          ),
        ],
        ListTile(
          onTap: onTap,
          tileColor: Colors.black12,
          leading: Icon(icon),
          title: Text(title),
        ),
        const Divider(height: 0, thickness: 0.5, color: Colors.grey),
      ],
    );
  }
}
