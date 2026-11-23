import 'package:flutter/material.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';
import 'package:myportofolio_mobile/widgets/portfolio_date_field.dart';

class EducationFormPage extends StatefulWidget {
  const EducationFormPage({super.key});

  @override
  State<EducationFormPage> createState() => _EducationFormPageState();
}

class _EducationFormPageState extends State<EducationFormPage> {
  final _formKey = GlobalKey<FormState>();
  String _institution = '';
  String _degree = '';
  String _fieldOfStudy = '';
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
        title: const Text('Ringkasan Edukasi'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Institusi: $_institution'),
              Text('Gelar/Jenjang: $_degree'),
              Text('Bidang Studi: $_fieldOfStudy'),
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
        title: const Text('Tambah Edukasi'),
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
                    labelText: 'Institusi',
                    border: OutlineInputBorder(),
                  ),
                  maxLength: 100,
                  validator: (value) => _requiredText(value, 'Institusi'),
                  onChanged: (value) => _institution = value.trim(),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Gelar/Jenjang',
                    border: OutlineInputBorder(),
                  ),
                  maxLength: 100,
                  validator: (value) => _requiredText(value, 'Gelar/Jenjang'),
                  onChanged: (value) => _degree = value.trim(),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Bidang Studi',
                    border: OutlineInputBorder(),
                  ),
                  maxLength: 100,
                  validator: (value) => _requiredText(value, 'Bidang Studi'),
                  onChanged: (value) => _fieldOfStudy = value.trim(),
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
