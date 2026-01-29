class UserModel {
  String username;
  String password;
  String role; // admin / user

  UserModel({
    required this.username,
    required this.password,
    required this.role,
  });
}

/// Dummy users (sementara, nanti bisa Firebase)
List<UserModel> users = [
  UserModel(username: 'admin', password: 'admin123', role: 'admin'),
  UserModel(username: 'user1', password: 'user123', role: 'user'),
  UserModel(username: 'user2', password: 'user123', role: 'user'),
];
