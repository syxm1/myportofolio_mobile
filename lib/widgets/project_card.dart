import 'package:flutter/material.dart';
import 'package:myportofolio_mobile/screens/menu.dart';
import 'package:myportofolio_mobile/services/api_client.dart';
import 'package:myportofolio_mobile/services/auth_state.dart';
import 'package:myportofolio_mobile/widgets/auth_guard.dart';
import 'package:provider/provider.dart';

class ItemCard extends StatelessWidget {
  final ItemHomepage item;

  const ItemCard(this.item, {super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: item.color,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        // Area responsif terhadap sentuhan
        onTap: () async {
          if (item.name == 'Logout') {
            final messenger = ScaffoldMessenger.of(context);
            final auth = context.read<AuthState>();
            if (!auth.isLoggedIn) {
              messenger.showSnackBar(
                const SnackBar(content: Text('You are not logged in.')),
              );
              return;
            }
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
            return;
          }
          if (item.name.startsWith('Tambah ') &&
              !await ensureLoggedIn(context)) {
            return;
          }
          if (!context.mounted) return;
          if (item.destination != null) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: item.destination!),
            );
            return;
          }
          // Memunculkan SnackBar ketika diklik
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text("Kamu telah menekan tombol ${item.name}!"),
              ),
            );
        },
        child: Container(
          padding: const EdgeInsets.all(8),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(item.icon, color: Colors.white, size: 30.0),
                const Padding(padding: EdgeInsets.all(3)),
                Text(
                  item.name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
