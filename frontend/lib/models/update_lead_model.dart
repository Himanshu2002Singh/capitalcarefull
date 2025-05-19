class UpdateLead {
  final String status;
  final String priority;
  final String nextMeeting;
  final String estBudget;
  final String remark;

  UpdateLead({
    required this.status,
    required this.priority,
    required this.nextMeeting,
    required this.estBudget,
    required this.remark,
  });

  Map<String, dynamic> toJson() => {
    "status": status,
    "priority": priority,
    "next_meeting": nextMeeting,
    "est_budget": estBudget,
    "remark": remark,
  };
}
