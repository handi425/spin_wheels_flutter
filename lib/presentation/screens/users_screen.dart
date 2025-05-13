import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spin_wheels/presentation/providers/user_provider.dart';
import 'package:spin_wheels/presentation/widgets/add_user_dialog.dart';
import 'package:spin_wheels/presentation/widgets/user_list_widget.dart';

/// Layar pengguna
class UsersScreen extends StatefulWidget {
  const UsersScreen({super.key});

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // Memuat data pengguna
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<UserProvider>(context, listen: false).loadUsers();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Mencari pengguna
  void _searchUsers(String query) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    userProvider.searchUsers(query);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pengguna'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              final userProvider = Provider.of<UserProvider>(
                context,
                listen: false,
              );
              userProvider.loadUsers();
            },
            tooltip: 'Muat Ulang',
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Cari Pengguna',
                prefixIcon: const Icon(Icons.search),
                suffix: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    _searchUsers('');
                  },
                ),
                border: const OutlineInputBorder(),
              ),
              onChanged: _searchUsers,
            ),
          ),
          Expanded(
            child: UserListWidget(
              onUserTap: (user) {
                // Tidak melakukan apa-apa untuk saat ini
              },
              isSelectable: false,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showAddEditUserDialog(context: context),
        tooltip: 'Tambah Pengguna',
        child: const Icon(Icons.add),
      ),
    );
  }
}
