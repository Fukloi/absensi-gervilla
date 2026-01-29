import 'package:flutter/material.dart';
import 'login_page.dart';
import 'user_model.dart';

class DashboardPage extends StatefulWidget {
  final UserModel user;
  const DashboardPage({super.key, required this.user});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int currentIndex = 0;

  late String selectedUser;
  final passC = TextEditingController();

  @override
  void initState() {
    super.initState();

    final userList =
    users.where((u) => u.role == 'user').toList();

    selectedUser =
    userList.isNotEmpty ? userList.first.username : '';
  }

  @override
  Widget build(BuildContext context) {
    final isAdmin = widget.user.role == 'admin';

    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard ${widget.user.role.toUpperCase()}'),
        centerTitle: true,
        backgroundColor: Colors.indigo,
      ),
      body: IndexedStack(
        index: currentIndex,
        children: [
          absenTab(),
          riwayatTab(),
          profilTab(isAdmin),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: (i) {
          setState(() => currentIndex = i);
        },
        destinations: const [
          NavigationDestination(
              icon: Icon(Icons.fingerprint), label: 'Absen'),
          NavigationDestination(
              icon: Icon(Icons.history), label: 'Riwayat'),
          NavigationDestination(
              icon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
    );
  }

  // ================= TAB ABSEN =================
  Widget absenTab() {
    return Center(
      child: Card(
        elevation: 6,
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        margin: const EdgeInsets.all(24),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.fingerprint,
                  size: 80, color: Colors.indigo),
              const SizedBox(height: 16),
              Text(widget.user.username,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.login),
                      label: const Text('Absen Masuk'),
                      onPressed: () =>
                          showSnack('Absen masuk berhasil'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.logout),
                      label: const Text('Absen Pulang'),
                      onPressed: () =>
                          showSnack('Absen pulang berhasil'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ================= TAB RIWAYAT =================
  Widget riwayatTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: const [
        ListTile(
          leading: Icon(Icons.login, color: Colors.green),
          title: Text('Absen Masuk'),
          subtitle: Text('20 Jan 2026 • 08:01'),
        ),
        ListTile(
          leading: Icon(Icons.logout, color: Colors.red),
          title: Text('Absen Pulang'),
          subtitle: Text('20 Jan 2026 • 17:02'),
        ),
      ],
    );
  }

  // ================= TAB PROFIL =================
  Widget profilTab(bool isAdmin) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          CircleAvatar(
            radius: 48,
            backgroundColor: Colors.indigo,
            child: Text(
              widget.user.username[0].toUpperCase(),
              style: const TextStyle(
                  fontSize: 34,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 16),
          Text(widget.user.username,
              style:
              const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Chip(label: Text(widget.user.role.toUpperCase())),
          const SizedBox(height: 24),
          if (isAdmin)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.admin_panel_settings),
                label: const Text('Kelola User'),
                onPressed: showKelolaUser,
              ),
            ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.logout),
              label: const Text('LOGOUT'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
              ),
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const LoginPage()),
                      (_) => false,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // ================= ADMIN =================
  void showKelolaUser() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) {
        return Padding(
          padding: EdgeInsets.fromLTRB(
              24, 24, 24, MediaQuery.of(context).viewInsets.bottom + 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                value: selectedUser,
                items: users
                    .where((u) => u.role == 'user')
                    .map((u) => DropdownMenuItem(
                  value: u.username,
                  child: Text(u.username),
                ))
                    .toList(),
                onChanged: (v) => setState(() => selectedUser = v!),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: passC,
                obscureText: true,
                decoration:
                const InputDecoration(labelText: 'Password Baru'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  users
                      .firstWhere((u) => u.username == selectedUser)
                      .password = passC.text;
                  passC.clear();
                  Navigator.pop(context);
                  showSnack('Password berhasil diubah');
                },
                child: const Text('SIMPAN'),
              ),
            ],
          ),
        );
      },
    );
  }

  void showSnack(String text) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(text)));
  }
}
