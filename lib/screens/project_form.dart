import 'package:flutter/material.dart';
import 'package:myportofolio_mobile/models/project.dart';
import 'package:myportofolio_mobile/services/api_client.dart';
import 'package:myportofolio_mobile/services/auth_state.dart';
import 'package:myportofolio_mobile/widgets/auth_guard.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';
import 'package:provider/provider.dart';

class ProjectFormPage extends StatefulWidget {
  const ProjectFormPage({super.key});

  @override
  State<ProjectFormPage> createState() => _ProjectFormPageState();
}

class _ProjectFormPageState extends State<ProjectFormPage> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _description = '';
  String _techStack = '';
  String _projectUrl = '';
  String _projectImageUrl = '';
  bool _isSubmitting = false;

  String? _required(String? value, String label) =>
      value == null || value.trim().isEmpty ? '$label wajib diisi' : null;

  String? _url(String? value, String label, {bool optional = false}) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return optional ? null : '$label wajib diisi';
    final uri = Uri.tryParse(text);
    if (uri == null ||
        !['http', 'https'].contains(uri.scheme) ||
        uri.host.isEmpty) {
      return 'Masukkan URL http atau https yang valid';
    }
    return null;
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (!await ensureLoggedIn(context) || !mounted) return;
    final auth = context.read<AuthState>();
    final token = auth.token;
    if (token == null) return;

    setState(() => _isSubmitting = true);
    try {
      await context.read<ApiClient>().createProject(
        Project(
          id: null,
          title: _title.trim(),
          description: _description.trim(),
          techStack: _techStack.trim(),
          projectUrl: _projectUrl.trim(),
          projectImageUrl: _projectImageUrl.trim(),
        ),
        token: token,
      );
      if (!mounted) return;
      await showDialog<void>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: const Text('Proyek berhasil ditambahkan!'),
          content: Text(_title.trim()),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('OK'),
            ),
          ],
        ),
      );
      if (mounted) Navigator.pop(context, true);
    } on ApiException catch (error) {
      if (!mounted) return;
      if (error.statusCode == 401) {
        try {
          await auth.logout();
        } on Exception {
          // The local token is cleared even if revocation fails.
        }
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Sesi berakhir. Silakan login ulang.')),
        );
        await ensureLoggedIn(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal menyimpan proyek (HTTP ${error.statusCode}).'),
          ),
        );
      }
    } on Exception {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal terhubung ke server. Coba lagi.')),
      );
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Project Form'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      drawer: const LeftDrawer(),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) => _title = value,
                validator: (value) => _required(value, 'Title'),
              ),
              const SizedBox(height: 12),
              TextFormField(
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) => _description = value,
                validator: (value) => _required(value, 'Description'),
              ),
              const SizedBox(height: 12),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Tech Stack',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) => _techStack = value,
                validator: (value) => _required(value, 'Tech Stack'),
              ),
              const SizedBox(height: 12),
              TextFormField(
                keyboardType: TextInputType.url,
                decoration: const InputDecoration(
                  labelText: 'Project URL',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) => _projectUrl = value,
                validator: (value) => _url(value, 'Project URL'),
              ),
              const SizedBox(height: 12),
              TextFormField(
                keyboardType: TextInputType.url,
                decoration: const InputDecoration(
                  labelText: 'Project Image URL (optional)',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) => _projectImageUrl = value,
                validator: (value) =>
                    _url(value, 'Project Image URL', optional: true),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isSubmitting ? null : _submit,
                child: _isSubmitting
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
