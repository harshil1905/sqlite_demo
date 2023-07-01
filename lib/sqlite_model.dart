class User {
  int? id;
  String? userName;

  User({this.id, this.userName});
  factory User.fromJson(Map<String, dynamic> json) =>
      User(id: json['id'], userName: json['userName']);

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = {};

    if (userName != null) {
      data['userName'] = userName;
    }
    if (id != null) {
      data['id'] = id;
    }
    return data;
  }
}
