class AddLeads {
  final int person_id;
  final String name;
  final String number;
  final String owner;
  final String branch;
  final String source;
  final String level;
  final String status;
  final String next_meeting;
  final String refrence;
  final String description;

  AddLeads({
    required this.person_id,
    required this.name,
    required this.number,
    required this.owner,
    required this.branch,
    required this.source,
    required this.level,
    required this.status,
    required this.next_meeting,
    required this.refrence,
    required this.description,
  });

  Map<String, dynamic> toJson() => {
    "person_id" : person_id,
    "name" : name,
    "number" : number,
    "owner" : owner,
    "branch" : branch,
    "source" : source,
    "level" : level,
    "status" : status,
    "next_meeting" : next_meeting,
    "refrence" : refrence,
    "description" : description
  };
}
