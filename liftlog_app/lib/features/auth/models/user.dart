class User {
  final int id;
  final String name;
  final String email;

  const User({required this.id, required this.name, required this.email});

  factory User.fromJson(Map<String, dynamic> j) =>
      User(id: j['id'], name: j['name'], email: j['email']);
}