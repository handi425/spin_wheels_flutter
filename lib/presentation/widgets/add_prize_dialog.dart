import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spin_wheels/data/models/prize_model.dart';
import 'package:spin_wheels/presentation/providers/prize_provider.dart';

/// Dialog untuk menambah atau mengedit hadiah
class AddPrizeDialog extends StatefulWidget {
  /// Prize yang akan diedit, null jika menambah prize baru
  final Prize? prize;

  const AddPrizeDialog({super.key, this.prize});

  @override
  State<AddPrizeDialog> createState() => _AddPrizeDialogState();
}

class _AddPrizeDialogState extends State<AddPrizeDialog> {
  final formKey = GlobalKey<FormState>();
  late final TextEditingController nameController;
  late final TextEditingController descriptionController;
  late final TextEditingController valueController;
  late final TextEditingController availableCountController;
  late final TextEditingController probabilityController;
  late Color selectedColor;

  bool get isEditing => widget.prize != null;

  @override
  void initState() {
    super.initState();

    // Inisialisasi controller dengan data prize jika mode edit
    nameController = TextEditingController(text: widget.prize?.name ?? '');
    descriptionController = TextEditingController(
      text: widget.prize?.description ?? '',
    );
    valueController = TextEditingController(
      text: widget.prize?.value?.toString() ?? '',
    );
    availableCountController = TextEditingController(
      text: widget.prize?.availableCount.toString() ?? '',
    );
    probabilityController = TextEditingController(
      text: widget.prize?.probability?.toString() ?? '',
    );
    selectedColor = widget.prize?.color ?? Colors.red;
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    valueController.dispose();
    availableCountController.dispose();
    probabilityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(isEditing ? 'Edit Hadiah' : 'Tambah Hadiah'),
      content: SizedBox(
        width: double.infinity,
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Nama Hadiah',
                    prefixIcon: Icon(Icons.card_giftcard),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Nama hadiah tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Deskripsi',
                    prefixIcon: Icon(Icons.description),
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 2,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: valueController,
                  decoration: const InputDecoration(
                    labelText: 'Nilai (Rp)',
                    prefixIcon: Icon(Icons.attach_money),
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: availableCountController,
                  decoration: const InputDecoration(
                    labelText: 'Jumlah yang Tersedia',
                    prefixIcon: Icon(Icons.inventory_2),
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Jumlah tidak boleh kosong';
                    }
                    if (int.tryParse(value) == null || int.parse(value) < 0) {
                      return 'Jumlah harus angka positif';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: probabilityController,
                  decoration: const InputDecoration(
                    labelText: 'Probabilitas (0-1)',
                    prefixIcon: Icon(Icons.percent),
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  validator: (value) {
                    if (value != null && value.isNotEmpty) {
                      final double? prob = double.tryParse(value);
                      if (prob == null || prob < 0 || prob > 1) {
                        return 'Probabilitas harus antara 0 dan 1';
                      }
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                Text('Warna', style: Theme.of(context).textTheme.bodyLarge),
                const SizedBox(height: 8),
                // Pilihan warna menggunakan Wrap
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children:
                      [
                        Colors.red,
                        Colors.pink,
                        Colors.purple,
                        Colors.deepPurple,
                        Colors.indigo,
                        Colors.blue,
                        Colors.lightBlue,
                        Colors.cyan,
                        Colors.teal,
                        Colors.green,
                        Colors.lightGreen,
                        Colors.lime,
                        Colors.yellow,
                        Colors.amber,
                        Colors.orange,
                        Colors.deepOrange,
                      ].map((color) {
                        return InkWell(
                          onTap: () {
                            setState(() {
                              selectedColor = color;
                            });
                          },
                          child: CircleAvatar(
                            radius: 18,
                            backgroundColor: color,
                            child:
                                selectedColor == color
                                    ? const Icon(
                                      Icons.check,
                                      color: Colors.white,
                                      size: 20,
                                    )
                                    : null,
                          ),
                        );
                      }).toList(),
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
        ElevatedButton(onPressed: _savePrize, child: const Text('Simpan')),
      ],
    );
  }

  /// Menyimpan data hadiah ke database
  void _savePrize() {
    if (formKey.currentState!.validate()) {
      final prizeProvider = Provider.of<PrizeProvider>(context, listen: false);

      // Buat hadiah baru atau update yang sudah ada
      final prize =
          isEditing
              ? widget.prize!.copyWith(
                name: nameController.text,
                description:
                    descriptionController.text.isEmpty
                        ? null
                        : descriptionController.text,
                value:
                    valueController.text.isEmpty
                        ? null
                        : double.parse(valueController.text),
                color: selectedColor,
                probability:
                    probabilityController.text.isEmpty
                        ? null
                        : double.parse(probabilityController.text),
                availableCount: int.parse(availableCountController.text),
              )
              : Prize(
                name: nameController.text,
                description:
                    descriptionController.text.isEmpty
                        ? null
                        : descriptionController.text,
                value:
                    valueController.text.isEmpty
                        ? null
                        : double.parse(valueController.text),
                color: selectedColor,
                probability:
                    probabilityController.text.isEmpty
                        ? null
                        : double.parse(probabilityController.text),
                availableCount: int.parse(availableCountController.text),
              );

      // Simpan hadiah
      prizeProvider.savePrize(prize).then((success) {
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                isEditing
                    ? 'Hadiah berhasil diperbarui'
                    : 'Hadiah berhasil ditambahkan',
              ),
              backgroundColor: Colors.green,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                prizeProvider.error ??
                    'Gagal ${isEditing ? 'memperbarui' : 'menambahkan'} hadiah',
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

/// Fungsi helper untuk menampilkan dialog tambah/edit hadiah
void showAddEditPrizeDialog({required BuildContext context, Prize? prize}) {
  showDialog(
    context: context,
    builder: (context) => AddPrizeDialog(prize: prize),
  );
}
