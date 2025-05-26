import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:krit_app/services/auth_service.dart';
import '../screens/login/login_screen.dart';
import '../screens/admin/admin_screen.dart';

class SideMenu extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;

  const SideMenu({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: theme.appBarTheme.backgroundColor,
            ),
            child: Center(
              child: ClipRRect(
                child: Image.asset(
                  'assets/images/KRiT2025_logo.png',
                  height: 100,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Expanded(
            child: Consumer<AuthProvider>(
              builder: (context, authProvider, child) {
                return ListView(
                  children: [
                    if (authProvider.role == 'admin') ...[
                      ListTile(
                        leading: Icon(Icons.admin_panel_settings, color: theme.iconTheme.color),
                        title: Text(
                          'Panel Administracyjny',
                          style: theme.textTheme.bodyMedium,
                        ),
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => AdminScreen()),
                          );
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.logout, color: theme.iconTheme.color),
                        title: Text(
                          'Wyloguj',
                          style: theme.textTheme.bodyMedium,
                        ),
                        onTap: () {
                          authProvider.logout();
                          Navigator.pop(context);
                        },
                      ),
                    ] else ...[
                      ListTile(
                        leading: Icon(Icons.login, color: theme.iconTheme.color),
                        title: Text(
                          'Logowanie',
                          style: theme.textTheme.bodyMedium,
                        ),
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => LoginScreen()),
                          );
                        },
                      ),
                    ],
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
