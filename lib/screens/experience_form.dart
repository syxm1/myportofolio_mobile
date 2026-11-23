import 'package:flutter/material.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';
import 'package:myportofolio_mobile/widgets/portfolio_date_field.dart';

class ExperienceFormPage extends StatefulWidget {
  const ExperienceFormPage({super.key});

  @override
  State<ExperienceFormPage> createState() => _ExperienceFormPageState();
}

class _ExperienceFormPageState extends State<ExperienceFormPage> {
  final _formKey = GlobalKey<FormState>();
  String _company = '';
  String _role = '';
  String _description = '';
  DateTime? _startDate;
  DateTime? _endDate;

  String? _requiredText(String? value, String label) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) return '$label wajib diisi';
    if (trimmed.length > 100) return '$label maksimal 100 karakter';
    return null;
  }

  String _dateText(DateTime date) => '${date.day}/${date.month}/${date.year}';

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Ringkasan Pengalaman'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Perusahaan/Organisasi: $_company'),
              Text('Jabatan: $_role'),
              Text('Deskripsi: $_description'),
              Text('Mulai: ${_dateText(_startDate!)}'),
              Text('Selesai: ${_dateText(_endDate!)}'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Pengalaman'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      drawer: const LeftDrawer(),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Perusahaan/Organisasi',
                    border: OutlineInputBorder(),
                  ),
                  maxLength: 100,
                  validator: (value) =>
                      _requiredText(value, 'Perusahaan/Organisasi'),
                  onChanged: (value) => _company = value.trim(),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Jabatan',
                    border: OutlineInputBorder(),
                  ),
                  maxLength: 100,
                  validator: (value) => _requiredText(value, 'Jabatan'),
                  onChanged: (value) => _role = value.trim(),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Deskripsi Pekerjaan',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                  maxLength: 1000,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Deskripsi pekerjaan wajib diisi';
                    }
                    if (value.trim().length < 10) {
                      return 'Deskripsi minimal 10 karakter';
                    }
                    return null;
                  },
                  onChanged: (value) => _description = value.trim(),
                ),
                const SizedBox(height: 12),
                PortfolioDateField(
                  label: 'Tanggal Mulai',
                  onChanged: (date) => setState(() => _startDate = date),
                  validator: (date) =>
                      date == null ? 'Tanggal mulai wajib diisi' : null,
                ),
                const SizedBox(height: 20),
                PortfolioDateField(
                  label: 'Tanggal Selesai',
                  onChanged: (date) => setState(() => _endDate = date),
                  validator: (date) {
                    if (date == null) return 'Tanggal selesai wajib diisi';
                    if (_startDate != null && date.isBefore(_startDate!)) {
                      return 'Tanggal selesai harus setelah tanggal mulai';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                ElevatedButton(onPressed: _save, child: const Text('Simpan')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
