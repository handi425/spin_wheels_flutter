import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spin_wheels/config/app_config.dart';
import 'package:spin_wheels/presentation/providers/theme_provider.dart';

/// Layar pengaturan
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pengaturan'),
        centerTitle: true,
      ),
      body: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Tema',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 16),
                      SwitchListTile(
                        title: const Text('Gunakan tema sistem'),
                        subtitle: const Text('Mengikuti tema perangkat'),
                        value: themeProvider.useSystemTheme,
                        onChanged: (value) {
                          themeProvider.setUseSystemTheme(value);
                        },
                      ),
                      const Divider(),
                      SwitchListTile(
                        title: const Text('Mode gelap'),
                        subtitle: const Text('Menggunakan tema gelap'),
                        value: themeProvider.isDarkMode,
                        onChanged: themeProvider.useSystemTheme
                            ? null
                            : (value) {
                                themeProvider.setDarkMode(value);
                              },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Suara',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 16),
                      SwitchListTile(
                        title: const Text('Efek suara'),
                        subtitle: const Text('Aktifkan efek suara'),
                        value: themeProvider.playSounds,
                        onChanged: (value) {
                          themeProvider.setPlaySounds(value);
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Animasi',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 16),
                      ListTile(
                        title: const Text('Kecepatan Putar'),
                        subtitle: Text('${themeProvider.spinSpeed.toStringAsFixed(1)} detik'),
                      ),
                      Slider(
                        value: themeProvider.spinSpeed,
                        min: 1.0,
                        max: 10.0,
                        divisions: 18,
                        label: '${themeProvider.spinSpeed.toStringAsFixed(1)} detik',
                        onChanged: (value) {
                          themeProvider.setSpinSpeed(value);
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Tentang Aplikasi',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 16),
                      ListTile(
                        title: const Text('Nama Aplikasi'),
                        subtitle: const Text(AppConfig.appName),
                      ),
                      const Divider(),
                      ListTile(
                        title: const Text('Versi'),
                        subtitle: const Text(AppConfig.appVersion),
                      ),
                      const Divider(),
                      const ListTile(
                        title: Text('Pengembang'),
                        subtitle: Text('Dibuat dengan Flutter'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
