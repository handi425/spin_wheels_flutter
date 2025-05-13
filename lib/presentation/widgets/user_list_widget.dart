import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:spin_wheels/core/utils.dart';
import 'package:spin_wheels/data/models/user_model.dart';
import 'package:spin_wheels/presentation/providers/user_provider.dart';
import 'package:spin_wheels/presentation/widgets/add_user_dialog.dart';

/// Widget untuk menampilkan daftar pengguna
class UserListWidget extends StatelessWidget {
  final Function(User) onUserTap;
  final bool isSelectable;

  const UserListWidget({
    super.key,
    required this.onUserTap,
    this.isSelectable = true,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        if (userProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (userProvider.users.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.person_off, size: 64, color: Colors.grey),
                const SizedBox(height: 16),
                Text(
                  'Belum ada pengguna',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                ElevatedButton.icon(
                  onPressed: () => _showAddUserDialog(context),
                  icon: const Icon(Icons.add),
                  label: const Text('Tambah Pengguna'),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          itemCount: userProvider.users.length,
          itemBuilder: (context, index) {
            final user = userProvider.users[index];
            return Slidable(
              key: ValueKey(user.id),
              enabled: !isSelectable,
              endActionPane: ActionPane(
                motion: const ScrollMotion(),
                children: [
                  SlidableAction(
                    onPressed: (context) => _showEditUserDialog(context, user),
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    icon: Icons.edit,
                    label: 'Edit',
                  ),
                  SlidableAction(
                    onPressed: (context) => _confirmDeleteUser(context, user),
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    icon: Icons.delete,
                    label: 'Hapus',
                  ),
                ],
              ),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Utils.getColorFromString(user.name),
                  child: Text(
                    Utils.getInitials(user.name),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                title: Text(user.name),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (user.email != null) Text("Email: ${user.email!}"),
                    if (user.phone != null) Text("Telp: ${user.phone!}"),
                    if (user.address != null) Text("Alamat: ${user.address!}"),
                    if (user.invoice != null) Text("Invoice: ${user.invoice!}"),
                  ],
                ),
                isThreeLine: true,
                trailing:
                    isSelectable
                        ? const Icon(Icons.arrow_forward_ios, size: 16)
                        : null,
                onTap: isSelectable ? () => onUserTap(user) : null,
              ),
            );
          },
        );
      },
    );
  }

  // Menampilkan dialog konfirmasi hapus pengguna
  void _confirmDeleteUser(BuildContext context, User user) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Hapus Pengguna'),
            content: Text('Apakah Anda yakin ingin menghapus ${user.name}?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Batal'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);

                  // Hapus pengguna
                  final userProvider = Provider.of<UserProvider>(
                    context,
                    listen: false,
                  );
                  userProvider.deleteUser(user.id!).then((success) {
                    if (success) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Pengguna berhasil dihapus'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            userProvider.error ?? 'Gagal menghapus pengguna',
                          ),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  });
                },
                child: const Text('Hapus', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
    );
  }

  // Menampilkan dialog tambah pengguna
  void _showAddUserDialog(BuildContext context) {
    showAddEditUserDialog(context: context);
  }

  // Menampilkan dialog edit pengguna
  void _showEditUserDialog(BuildContext context, User user) {
    showAddEditUserDialog(context: context, user: user);
  }
}
