class AddLeads {
  final String person_id;
  final String name;
  final String number;
  final String email;
  final String owner;
  final String branch;
  final String source;
  final String priority;
  final String status;
  final String next_meeting;
  final String refrence;
  var description;
  var address;
  final String loanType;

  AddLeads({
    required this.person_id,
    required this.name,
    required this.number,
    required this.email,
    required this.owner,
    required this.branch,
    required this.source,
    required this.priority,
    required this.status,
    required this.next_meeting,
    required this.refrence,
    this.description,
    this.address,
    required this.loanType,
  });

  Map<String, dynamic> toJson() => {
    "person_id": person_id,
    "name": name,
    "number": number,
    "email": email,
    "owner": owner,
    "branch": branch,
    "source": source,
    "priority": priority,
    "status": status,
    "next_meeting": next_meeting,
    "refrence": refrence,
    "description": description,
    "address": address,
    "loan_type": loanType,
  };
}
