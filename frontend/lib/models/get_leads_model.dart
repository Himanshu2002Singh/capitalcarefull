class GetLead {
  final int id;
  final String name;
  final String ename;
  final String number;
  final String description;
  final String source;
  final String priority;
  final String status;
  final String next_meeting;
  final String createdAt;

  GetLead({
    required this.id,
    required this.name,
    required this.ename,
    required this.source,
    required this.createdAt,
    required this.priority,
    required this.number,
    required this.status,
    required this.description,
    required this.next_meeting,
  });

  factory GetLead.fromJson(Map<String, dynamic> json) {
    return GetLead(
      id: json['id'],
      name: json['name'] ?? "",
      ename: json['ename'] ?? "",
      source: json['source'] ?? "",
      createdAt: json['createdAt'] ?? "",
      priority: json['priority'] ?? "",
      number: json['number'] ?? "1",
      status: json['status'] ?? "Fresh lead",
      description: json['description'] ?? "",
      next_meeting: json['next_meeting'] ?? "",
    );
  }
}
