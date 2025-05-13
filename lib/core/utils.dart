import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

/// Kelas utilitas untuk fungsi-fungsi umum yang digunakan di seluruh aplikasi
class Utils {
  /// Format tanggal ke string dengan format tertentu
  static String formatDate(
    DateTime date, {
    String format = 'dd/MM/yyyy HH:mm',
  }) {
    final formatter = DateFormat(format);
    return formatter.format(date);
  }

  /// Parse string tanggal ke DateTime
  static DateTime? parseDate(
    String date, {
    String format = 'dd/MM/yyyy HH:mm',
  }) {
    try {
      final formatter = DateFormat(format);
      return formatter.parse(date);
    } catch (e) {
      return null;
    }
  }

  /// Format nilai currency
  static String formatCurrency(double value) {
    final formatter = NumberFormat.currency(
      locale: 'id',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    return formatter.format(value);
  }

  /// Mengambil nama dari inisial
  static String getInitials(String name) {
    List<String> nameParts = name.split(' ');
    if (nameParts.length > 1) {
      return nameParts[0][0].toUpperCase() + nameParts[1][0].toUpperCase();
    } else if (name.isNotEmpty) {
      return name[0].toUpperCase();
    }
    return '?';
  }

  /// Menghasilkan warna dari string
  static Color getColorFromString(String seed) {
    final colors = [
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
    ];

    int hashCode = seed.hashCode;
    return colors[hashCode.abs() % colors.length];
  }

  /// Menampilkan snackbar
  static void showSnackBar(
    BuildContext context,
    String message, {
    bool isError = false,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  /// Menampilkan dialog konfirmasi
  static Future<bool> showConfirmDialog(
    BuildContext context, {
    required String title,
    required String message,
    String confirmText = 'Ya',
    String cancelText = 'Batal',
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(title),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text(cancelText),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text(confirmText),
              ),
            ],
          ),
    );
    return result ?? false;
  }

  /// Validasi email
  static bool isValidEmail(String email) {
    final emailRegExp = RegExp(r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+');
    return emailRegExp.hasMatch(email);
  }

  /// Validasi nomor telepon
  static bool isValidPhone(String phone) {
    final phoneRegExp = RegExp(r'^\+?[0-9]{10,13}$');
    return phoneRegExp.hasMatch(phone);
  }

  /// Membuka aplikasi WhatsApp dengan nomor dan pesan tertentu
  static void openWhatsapp({
    required String phone,
    required String message,
  }) async {
    // Format nomor telepon (hapus karakter '+' jika ada)
    String formattedPhone = phone;
    if (formattedPhone.startsWith('+')) {
      formattedPhone = formattedPhone.substring(1);
    }

    // Encode pesan untuk URL
    final encodedMessage = Uri.encodeComponent(message);

    // Buat URL WhatsApp
    final whatsappUrl = 'https://wa.me/$formattedPhone?text=$encodedMessage';

    // Gunakan url_launcher untuk membuka URL
    try {
      final Uri url = Uri.parse(whatsappUrl);

      // Buka WhatsApp
      await launchUrl(url, mode: LaunchMode.externalApplication);

      debugPrint('Membuka WhatsApp URL: $whatsappUrl');
    } catch (e) {
      debugPrint('Error membuka WhatsApp: $e');
    }
  }
}
