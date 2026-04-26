import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/theme_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDark;

    return Scaffold(
      appBar: AppBar(title: const Text("Settings")),

      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDark
                    ? [Colors.black, Colors.grey.shade900]
                    : [Colors.blue, Colors.purple],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: const [
                Icon(Icons.settings, color: Colors.white, size: 30),
                SizedBox(width: 10),
                Text(
                  "App Settings",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                )
              ],
            ),
            child: SwitchListTile(
              value: isDark,
              onChanged: (val) {
                themeProvider.toggleTheme(val);
              },
              title: const Text("Dark Mode"),
              subtitle: const Text("Enable dark theme"),
              secondary: Icon(
                isDark ? Icons.dark_mode : Icons.light_mode,
                color: Colors.blue,
              ),
            ),
          ),

          const SizedBox(height: 12),
          buildTile(
            context,
            icon: Icons.info,
            title: "About App",
            onTap: () {
              showAboutDialog(
                context: context,
                applicationName: "Event App",
                applicationVersion: "1.0",
              );
            },
          ),

          const SizedBox(height: 12),
          buildTile(
            context,
            icon: Icons.logout,
            title: "Logout",
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Logged out (UI only)")),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget buildTile(BuildContext context,
      {required IconData icon,
        required String title,
        required VoidCallback onTap}) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.blue),
        title: Text(title),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}