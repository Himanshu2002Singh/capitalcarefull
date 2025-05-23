class GetLead {
  final int lead_id;
  final String name;
  final String owner;
  final String number;
  final String description;
  final String source;
  final String priority;
  final String status;
  final String next_meeting;
  final String createdAt;

  GetLead({
    required this.lead_id,
    required this.name,
    required this.owner,
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
      lead_id: json['lead_id'],
      name: json['name'] ?? "",
      number: json['number'] ?? "1",
      owner: json['owner'] ?? "",
      source: json['source'] ?? "",
      createdAt: json['createdAt'] ?? "",
      priority: json['priority'] ?? "",
      status: json['status'] ?? "Fresh lead",
      description: json['description'] ?? "",
      next_meeting: json['next_meeting'] ?? "",
    );
  }
}
