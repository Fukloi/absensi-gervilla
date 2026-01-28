import 'package:flutter/material.dart';
import 'dashboard_page.dart';

// ===== USER MODEL =====
class UserModel {
  String username;
  String password;
  String role;

  UserModel(this.username, this.password, this.role);
}

// ===== DUMMY USERS =====
List<UserModel> users = [
  UserModel('admin', 'admin123', 'admin'),
  UserModel('user1', 'user123', 'user'),
  UserModel('user2', 'user123', 'user'),
];

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final userC = TextEditingController();
  final passC = TextEditingController();

  void login() {
    try {
      final user = users.firstWhere(
            (u) => u.username == userC.text && u.password == passC.text,
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => DashboardPage(user: user),
        ),
      );
    } catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login gagal')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo.shade50,
      body: Center(
        child: Card(
          elevation: 8,
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: SizedBox(
              width: 330,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.lock, size: 60, color: Colors.indigo),
                  const SizedBox(height: 20),
                  TextField(
                    controller: userC,
                    decoration: const InputDecoration(
                        labelText: 'Username'),
                  ),
                  const SizedBox(height: 15),
                  TextField(
                    controller: passC,
                    obscureText: true,
                    decoration: const InputDecoration(
                        labelText: 'Password'),
                  ),
                  const SizedBox(height: 25),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: login,
                      child: const Text('LOGIN'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
