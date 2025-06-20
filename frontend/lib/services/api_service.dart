import 'dart:convert';

import 'package:capital_care/constants/server_url.dart';
import 'package:capital_care/models/calls_model.dart';
import 'package:capital_care/models/history_model.dart';
import 'package:capital_care/models/leads_model.dart';
import 'package:capital_care/models/employee_model.dart';
import 'package:capital_care/models/task_model.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static String baseUrl = ServerUrl;

  static final FlutterSecureStorage secureStorage = FlutterSecureStorage();

  static Future<Employee> getUserById(String userId) async {
    final url = Uri.parse("$baseUrl/employees/$userId");

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return Employee.fromJson(data);
    } else {
      throw Exception('Failed to fetch User : ${response.body}');
    }
  }

  static Future<bool> updateUser(String userId, Employee employee) async {
    final url = Uri.parse("$baseUrl/update_employee/$userId");
    final response = await http.put(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(employee.toJson()),
    );
    if (response.statusCode == 200) {
      print("employee updated: ${response.body}");
      return true;
    } else {
      print(
        "Update failed =================================================>>>>>>>>>>>>>>>: ${response.body}",
      );
      return false;
    }
  }

  static Future<Employee> login(String username, String password) async {
    final url = Uri.parse('$baseUrl/login');
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({'username': username, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      final token = data['token'];
      final userJson = data['employee'];

      await secureStorage.write(key: "auth_token", value: token);
      await secureStorage.write(
        key: "userId",
        value: Employee.fromJson(userJson).empId,
      );
      await secureStorage.write(
        key: "loginTime",
        value: DateTime.now().toIso8601String(),
      );

      return Employee.fromJson(userJson);
    } else {
      throw Exception('Login failed: ${response.body}');
    }
  }

  static Future<List<Leads>> fetchLeads() async {
    final emp_id = await secureStorage.read(key: "userId");
    final url = Uri.parse("$baseUrl/leads/$emp_id");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      List jsonData = jsonDecode(response.body);
      return jsonData.map((e) => Leads.fromJson(e)).toList();
    } else {
      throw Exception("failed to load employees");
    }
  }

  static Future<bool> addLead(Leads lead) async {
    final url = Uri.parse("$baseUrl/submit-lead");
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(lead.toJson()),
    );

    if (response.statusCode == 200) {
      print("lead added : ${response.body}");
      return true;
    } else {
      print("failed : ${response.body}");
      return false;
    }
  }

  static Future<bool> updateLead(int id, Leads lead) async {
    final url = Uri.parse(
      "$baseUrl/leads/$id",
    ); // assuming backend uses /leads/:id
    final response = await http.put(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(lead.toJson()),
    );

    if (response.statusCode == 200) {
      print("Lead updated: ${response.body}");
      return true;
    } else {
      print(
        "Update failed =================================================>>>>>>>>>>>>>>>: ${response.body}",
      );
      return false;
    }
  }

  static Future<bool> addHistory(History history) async {
    final url = Uri.parse("$baseUrl/histories");
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(history.toJson()),
    );
    if (response.statusCode == 200) {
      print("history added : ${response.body}");
      return true;
    } else {
      print("failed : ${response.body}");
      return false;
    }
  }

  static Future<List<History>> getHistory(int id) async {
    final url = Uri.parse("$baseUrl/histories/$id");

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = jsonDecode(response.body);

      final List historyList =
          jsonData['history']; // Extract the 'history' list
      // print(historyList[5]);

      return historyList.map((e) => History.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load history");
    }
  }

  static Future<bool> addCalls(Calls call) async {
    final url = Uri.parse("$baseUrl/calls");
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(call.toJson()),
    );
    if (response.statusCode == 200) {
      print("call added : ${response.body}");
      return true;
    } else {
      print("failed : ${response.body}");
      return false;
    }
  }

  static Future<List<Calls>> getCalls(String id) async {
    final url = Uri.parse("$baseUrl/calls/$id");
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = jsonDecode(response.body);

      final List callList = jsonData['calls'];
      return callList.map((e) => Calls.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load Calls");
    }
  }

  static Future<bool> updateCall(Calls call, int callId) async {
    final url = Uri.parse("$baseUrl/updateCall/$callId");
    final response = await http.put(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(call.toJson()),
    );
    if (response.statusCode == 200) {
      print("Call updated: ${response.body}");
      return true;
    } else {
      print(
        "Update failed =================================================>>>>>>>>>>>>>>>: ${response.body}",
      );
      return false;
    }
  }

  static Future<bool> addTask(Task task) async {
    final url = Uri.parse("$baseUrl/add_task");
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(task.toJson()),
    );
    if (response.statusCode == 200) {
      print("Task added successfull: ${response.body}");
      return true;
    } else {
      print(
        "Update failed =================================================>>>>>>>>>>>>>>>: ${response.body}",
      );
      return false;
    }
  }

  static Future<List<Task>> getTasks(String emp_id) async {
    final url = Uri.parse("$baseUrl/task/$emp_id");
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = jsonDecode(response.body);
      final List taskList = jsonData['tasks'];
      return taskList.map((e) => Task.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load Tasks");
    }
  }

  static Future<List<Task>> getTasksByLeadId(int lead_id) async {
    final url = Uri.parse("$baseUrl/task_by_lead_id/$lead_id");
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = jsonDecode(response.body);
      final List taskList = jsonData['tasks'];
      print("===============> tasks fetched + $taskList");
      return taskList.map((e) => Task.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load Tasks");
    }
  }
}
