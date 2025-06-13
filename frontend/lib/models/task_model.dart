class Task {
  final emp_id;
  final title;
  final choose_lead;
  final lead_id;
  final start_date;
  final end_date;
  final priority;
  final is_active;
  final description;

  Task({
    this.emp_id,
    this.title,
    this.choose_lead,
    this.lead_id,
    this.start_date,
    this.end_date,
    this.priority,
    this.is_active,
    this.description,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {};
    if (emp_id != null) json["emp_id"] = emp_id;
    if (title != null) json["title"] = title;
    if (choose_lead != null) json["choose_lead"] = choose_lead;
    if (lead_id != null) json["lead_id"] = lead_id;
    if (start_date != null) json["start_date"] = start_date;
    if (end_date != null) json["end_date"] = end_date;
    if (priority != null) json["priority"] = priority;
    if (is_active != null) json["is_active"] = is_active;
    if (description != null) json["description"] = description;

    return json;
  }

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      emp_id: json["emp_id"] ?? "",
      title: json["title"] ?? "",
      choose_lead: json["choose_lead"] ?? "",
      lead_id: json["lead_id"] ?? "",
      start_date: json["start_date"] ?? "",
      end_date: json["end_date"] ?? "",
      priority: json["priority"] ?? "",
      is_active: json["is_active"] ?? "",
      description: json["description"] ?? "",
    );
  }
}
