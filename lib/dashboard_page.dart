import 'package:flutter/material.dart';
import 'login_page.dart';

class DashboardPage extends StatefulWidget {
  final UserModel user;
  const DashboardPage({super.key, required this.user});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int currentIndex = 0;

  // === admin change password ===
  String selectedUser = 'user1';
  final passC = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard ${widget.user.role.toUpperCase()}'),
        centerTitle: true,
      ),
      body: IndexedStack(
        index: currentIndex,
        children: [
          absenTab(),
          riwayatTab(),
          profilTab(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: (i) {
          setState(() => currentIndex = i);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.fingerprint),
            label: 'Absen',
          ),
          NavigationDestination(
            icon: Icon(Icons.history),
            label: 'Riwayat',
          ),
          NavigationDestination(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }

  // ================= TAB 1 : ABSEN =================
  Widget absenTab() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Card(
            elevation: 6,
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const Icon(Icons.fingerprint,
                      size: 80, color: Colors.indigo),
                  const SizedBox(height: 20),
                  Text(
                    widget.user.username,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 25),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.login),
                          label: const Text('Absen Masuk'),
                          onPressed: () {
                            showSnack('Absen masuk berhasil');
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: OutlinedButton.icon(
                          icon: const Icon(Icons.logout),
                          label: const Text('Absen Pulang'),
                          onPressed: () {
                            showSnack('Absen pulang berhasil');
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ================= TAB 2 : RIWAYAT =================
  Widget riwayatTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: const [
        ListTile(
          leading: Icon(Icons.check_circle, color: Colors.green),
          title: Text('Absen Masuk'),
          subtitle: Text('20 Jan 2026 • 08:01'),
        ),
        ListTile(
          leading: Icon(Icons.exit_to_app, color: Colors.red),
          title: Text('Absen Pulang'),
          subtitle: Text('20 Jan 2026 • 17:02'),
        ),
      ],
    );
  }

  // ================= TAB 3 : PROFIL =================
  Widget profilTab() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          CircleAvatar(
            radius: 45,
            backgroundColor: Colors.indigo,
            child: Text(
              widget.user.username[0].toUpperCase(),
              style: const TextStyle(
                  fontSize: 32,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 15),
          Text(
            widget.user.username,
            style: const TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Text(
            widget.user.role.toUpperCase(),
            style: const TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 30),

          // ===== UBAH PASSWORD =====
          Card(
            elevation: 4,
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Ubah Password',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 15),

                  if (widget.user.role == 'admin')
                    DropdownButton<String>(
                      value: selectedUser,
                      items: users
                          .map(
                            (u) => DropdownMenuItem(
                          value: u.username,
                          child: Text(u.username),
                        ),
                      )
                          .toList(),
                      onChanged: (v) =>
                          setState(() => selectedUser = v!),
                    ),

                  TextField(
                    controller: passC,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Password Baru',
                      prefixIcon: Icon(Icons.lock),
                    ),
                  ),
                  const SizedBox(height: 15),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (widget.user.role == 'admin') {
                          users
                              .firstWhere(
                                  (u) => u.username == selectedUser)
                              .password = passC.text;
                        } else {
                          widget.user.password = passC.text;
                        }

                        showSnack('Password berhasil diubah');
                        passC.clear();
                      },
                      child: const Text('SIMPAN'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void showSnack(String text) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(text)));
  }
}
