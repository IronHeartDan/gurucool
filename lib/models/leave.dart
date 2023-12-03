class Leave {
  String id;
  int userId;
  String start;
  String end;
  String reason;
  int status;
  String name;
  int role;

  Leave(this.id, this.userId, this.start, this.end, this.reason,
      this.status, this.name, this.role);

  factory Leave.fromJson(Map<String, dynamic> json) {
    return Leave(
        json["_id"],
        json["userId"],
        json["start"],
        json["end"],
        json["reason"],
        json["status"],
        json["name"],
        json["role"]);
  }
}
