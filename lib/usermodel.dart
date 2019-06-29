class User {
  Map<String, dynamic> data;
  String compatibility;
  User({this.data, this.compatibility});
  
  // factory constructor for User to create it from JSON
  factory User.fromJson(Map<String, dynamic> json) => User(
        data: json,
        compatibility: json['compatibilty'].toString(),
      );
}
