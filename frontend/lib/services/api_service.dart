import 'dart:convert';

import 'package:capital_care/constants/server_url.dart';
import 'package:capital_care/models/add_leads_model.dart';
import 'package:capital_care/models/employee_model.dart';
import 'package:capital_care/models/get_leads_model.dart';
import 'package:capital_care/models/update_lead_model.dart';
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

      return Employee.fromJson(userJson);
    } else {
      throw Exception('Login failed: ${response.body}');
    }
  }

  static Future<List<GetLead>> fetchLeads() async {
    final url = Uri.parse("$baseUrl/leads");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      List jsonData = jsonDecode(response.body);
      return jsonData.map((e) => GetLead.fromJson(e)).toList();
    } else {
      throw Exception("failed to load employees");
    }
  }

  static Future<bool> addLead(AddLeads lead) async {
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

  static Future<bool> updateLead(int id, UpdateLead lead) async {
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
      print("Update failed: ${response.body}");
      return false;
    }
  }
}
