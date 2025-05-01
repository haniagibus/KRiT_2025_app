import 'package:flutter/material.dart';

import '../screens/login/login_screen.dart';

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
            child: ListView(
              children: [
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
            ),
          ),
        ],
      ),
    );
  }
}
