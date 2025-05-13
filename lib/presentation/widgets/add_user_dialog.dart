import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spin_wheels/core/utils.dart';
import 'package:spin_wheels/data/models/user_model.dart';
import 'package:spin_wheels/presentation/providers/user_provider.dart';

/// Dialog untuk menambah atau mengedit pengguna
class AddUserDialog extends StatefulWidget {
  /// User yang akan diedit, null jika menambah user baru
  final User? user;

  const AddUserDialog({super.key, this.user});

  @override
  State<AddUserDialog> createState() => _AddUserDialogState();
}

class _AddUserDialogState extends State<AddUserDialog> {
  final formKey = GlobalKey<FormState>();
  late final TextEditingController nameController;
  late final TextEditingController emailController;
  late final TextEditingController phoneController;
  late final TextEditingController addressController;
  late final TextEditingController invoiceController;
  late final TextEditingController trackingNumberController;

  bool get isEditing => widget.user != null;

  @override
  void initState() {
    super.initState();

    // Inisialisasi controller dengan data user jika mode edit    
    nameController = TextEditingController(text: widget.user?.name ?? '');
    emailController = TextEditingController(text: widget.user?.email ?? '');
    phoneController = TextEditingController(text: widget.user?.phone ?? '');
    addressController = TextEditingController(text: widget.user?.address ?? '');
    invoiceController = TextEditingController(text: widget.user?.invoice ?? '');
    trackingNumberController = TextEditingController(
      text: widget.user?.trackingNumber ?? '',
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    addressController.dispose();
    invoiceController.dispose();
    trackingNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(isEditing ? 'Edit Pengguna' : 'Tambah Pengguna'),
      content: SizedBox(
        width: double.maxFinite,
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Nama',
                    prefixIcon: Icon(Icons.person),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Nama tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email),
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value != null &&
                        value.isNotEmpty &&
                        !Utils.isValidEmail(value)) {
                      return 'Email tidak valid';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: phoneController,
                  decoration: const InputDecoration(
                    labelText: 'Nomor Telepon',
                    prefixIcon: Icon(Icons.phone),
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value != null &&
                        value.isNotEmpty &&
                        !Utils.isValidPhone(value)) {
                      return 'Nomor telepon tidak valid';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: addressController,
                  decoration: const InputDecoration(
                    labelText: 'Alamat',
                    prefixIcon: Icon(Icons.home),
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 2,
                  keyboardType: TextInputType.streetAddress,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: invoiceController,
                  decoration: const InputDecoration(
                    labelText: 'No. Invoice',
                    prefixIcon: Icon(Icons.receipt),
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.text,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: trackingNumberController,
                  decoration: const InputDecoration(
                    labelText: 'Nomor Resi Pengiriman',
                    prefixIcon: Icon(Icons.local_shipping),
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.text,
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Batal'),
        ),
        ElevatedButton(onPressed: _saveUser, child: const Text('Simpan')),
      ],
    );
  }

  /// Menyimpan data pengguna ke database
  void _saveUser() {
    if (formKey.currentState!.validate()) {
      final userProvider = Provider.of<UserProvider>(
        context,
        listen: false,
      ); // Buat pengguna baru atau update yang sudah ada
      final user =
          isEditing
              ? widget.user!.copyWith(
                name: nameController.text,
                email:
                    emailController.text.isEmpty ? null : emailController.text,
                phone:
                    phoneController.text.isEmpty ? null : phoneController.text,
                address:
                    addressController.text.isEmpty
                        ? null
                        : addressController.text,
                invoice:
                    invoiceController.text.isEmpty
                        ? null
                        : invoiceController.text,
                trackingNumber:
                    trackingNumberController.text.isEmpty
                        ? null
                        : trackingNumberController.text,
              )
              : User(
                name: nameController.text,
                email:
                    emailController.text.isEmpty ? null : emailController.text,
                phone:
                    phoneController.text.isEmpty ? null : phoneController.text,
                address:
                    addressController.text.isEmpty
                        ? null
                        : addressController.text,
                invoice:
                    invoiceController.text.isEmpty
                        ? null
                        : invoiceController.text,
                trackingNumber:
                    trackingNumberController.text.isEmpty
                        ? null
                        : trackingNumberController.text,
              );

      // Simpan pengguna
      userProvider.saveUser(user).then((success) {
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                isEditing
                    ? 'Pengguna berhasil diperbarui'
                    : 'Pengguna berhasil ditambahkan',
              ),
              backgroundColor: Colors.green,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                userProvider.error ??
                    'Gagal ${isEditing ? 'memperbarui' : 'menambahkan'} pengguna',
              ),
              backgroundColor: Colors.red,
            ),
          );
        }
      });

      Navigator.pop(context);
    }
  }
}

/// Fungsi helper untuk menampilkan dialog tambah/edit pengguna
void showAddEditUserDialog({required BuildContext context, User? user}) {
  showDialog(context: context, builder: (context) => AddUserDialog(user: user));
}
