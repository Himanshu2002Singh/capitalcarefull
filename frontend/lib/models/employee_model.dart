class Employee {
  final String empId;
  final String username;
  final String email;
  final String ename;
  final String? password;

  Employee({
    required this.empId,
    required this.username,
    required this.email,
    required this.ename,
    this.password
  });

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      empId: json['emp_id'].toString(),
      username: json['username'],
      email: json['email'],
      ename: json['ename'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'username': username, 'password': password};
  }
}
