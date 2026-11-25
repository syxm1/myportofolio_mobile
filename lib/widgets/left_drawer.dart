import 'package:flutter/material.dart';
import 'package:myportofolio_mobile/screens/certification_form.dart';
import 'package:myportofolio_mobile/screens/education_form.dart';
import 'package:myportofolio_mobile/screens/experience_form.dart';
import 'package:myportofolio_mobile/screens/project_form.dart';
import 'package:myportofolio_mobile/screens/project_list_screen.dart';
import 'package:myportofolio_mobile/screens/login_screen.dart';
import 'package:myportofolio_mobile/services/api_client.dart';
import 'package:myportofolio_mobile/services/auth_state.dart';
import 'package:myportofolio_mobile/widgets/auth_guard.dart';
import 'package:provider/provider.dart';

class LeftDrawer extends StatelessWidget {
  const LeftDrawer({super.key});

  void _openForm(BuildContext context, WidgetBuilder builder) {
    final navigator = Navigator.of(context);
    navigator.pop(); // Close the drawer before opening the form.
    navigator.push(MaterialPageRoute(builder: builder));
  }

  Future<void> _openProtected(
    BuildContext context,
    WidgetBuilder builder,
  ) async {
    final navigator = Navigator.of(context);
    navigator.pop();
    if (!await ensureLoggedIn(navigator.context) || !navigator.mounted) return;
    navigator.push(MaterialPageRoute(builder: builder));
  }

  @override
  Widget build(BuildContext context) {
    final isLoggedIn = context.watch<AuthState>().isLoggedIn;
    return Drawer(
      child: ListView(
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Colors.indigo),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'My Portfolio',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Explore personal projects and experiences!',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 14, color: Colors.white),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home_outlined),
            title: const Text('Home'),
            // Navigasi ke halaman utama portofolio
            onTap: () {
              final navigator = Navigator.of(context);
              final isHome = ModalRoute.of(context)?.isFirst ?? false;
              navigator.pop(); // Close the drawer.
              if (!isHome) {
                navigator.popUntil((route) => route.isFirst);
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.folder_outlined),
            title: const Text('Projects'),
            onTap: () =>
                _openForm(context, (context) => const ProjectListScreen()),
          ),
          ListTile(
            leading: const Icon(Icons.add_circle_outline),
            title: const Text('Add Project'),
            // Navigasi ke halaman tambah proyek
            onTap: () =>
                _openProtected(context, (context) => const ProjectFormPage()),
          ),
          ListTile(
            leading: const Icon(Icons.school_outlined),
            title: const Text('Add Education'),
            onTap: () =>
                _openProtected(context, (context) => const EducationFormPage()),
          ),
          ListTile(
            leading: const Icon(Icons.work_outline),
            title: const Text('Add Experience'),
            onTap: () => _openProtected(
              context,
              (context) => const ExperienceFormPage(),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.verified_outlined),
            title: const Text('Add Certification'),
            onTap: () => _openProtected(
              context,
              (context) => const CertificationFormPage(),
            ),
          ),
          if (!isLoggedIn)
            ListTile(
              leading: const Icon(Icons.login),
              title: const Text('Login'),
              onTap: () {
                final navigator = Navigator.of(context);
                navigator.pop();
                navigator.push(
                  MaterialPageRoute<bool>(builder: (_) => const LoginScreen()),
                );
              },
            )
          else
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () async {
                final navigator = Navigator.of(context);
                final messenger = ScaffoldMessenger.of(context);
                final auth = context.read<AuthState>();
                navigator.pop();
                try {
                  await auth.logout();
                  messenger.showSnackBar(
                    const SnackBar(content: Text('Logged out successfully.')),
                  );
                } on ApiException catch (error) {
                  messenger.showSnackBar(
                    SnackBar(
                      content: Text(
                        'Logged out locally (HTTP ${error.statusCode}).',
                      ),
                    ),
                  );
                } on Exception {
                  messenger.showSnackBar(
                    const SnackBar(content: Text('Logged out locally.')),
                  );
                }
              },
            ),
        ],
      ),
    );
  }
}
