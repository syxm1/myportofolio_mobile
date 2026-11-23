import 'package:flutter/material.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';
import 'package:myportofolio_mobile/widgets/portfolio_date_field.dart';

class CertificationFormPage extends StatefulWidget {
  const CertificationFormPage({super.key});

  @override
  State<CertificationFormPage> createState() => _CertificationFormPageState();
}

class _CertificationFormPageState extends State<CertificationFormPage> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _issuer = '';
  String _credentialId = '';
  String _credentialUrl = '';
  DateTime? _issueDate;

  String? _requiredText(String? value, String label) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) return '$label wajib diisi';
    if (trimmed.length > 100) return '$label maksimal 100 karakter';
    return null;
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Ringkasan Sertifikasi'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Sertifikasi: $_name'),
              Text('Penerbit: $_issuer'),
              Text('ID Kredensial: $_credentialId'),
              Text(
                'URL Kredensial: ${_credentialUrl.isEmpty ? "-" : _credentialUrl}',
              ),
              Text(
                'Tanggal Terbit: ${_issueDate!.day}/${_issueDate!.month}/${_issueDate!.year}',
              ),
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
        title: const Text('Tambah Sertifikasi'),
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
                    labelText: 'Nama Sertifikasi',
                    border: OutlineInputBorder(),
                  ),
                  maxLength: 100,
                  validator: (value) =>
                      _requiredText(value, 'Nama sertifikasi'),
                  onChanged: (value) => _name = value.trim(),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Penerbit',
                    border: OutlineInputBorder(),
                  ),
                  maxLength: 100,
                  validator: (value) => _requiredText(value, 'Penerbit'),
                  onChanged: (value) => _issuer = value.trim(),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'ID Kredensial',
                    border: OutlineInputBorder(),
                  ),
                  maxLength: 100,
                  validator: (value) => _requiredText(value, 'ID kredensial'),
                  onChanged: (value) => _credentialId = value.trim(),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'URL Kredensial (opsional)',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.url,
                  validator: (value) {
                    final text = value?.trim() ?? '';
                    if (text.isEmpty) return null;
                    final uri = Uri.tryParse(text);
                    if (uri == null ||
                        !['http', 'https'].contains(uri.scheme) ||
                        uri.host.isEmpty) {
                      return 'Masukkan URL http atau https yang valid';
                    }
                    return null;
                  },
                  onChanged: (value) => _credentialUrl = value.trim(),
                ),
                const SizedBox(height: 12),
                PortfolioDateField(
                  label: 'Tanggal Terbit',
                  onChanged: (date) => setState(() => _issueDate = date),
                  validator: (date) =>
                      date == null ? 'Tanggal terbit wajib diisi' : null,
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
