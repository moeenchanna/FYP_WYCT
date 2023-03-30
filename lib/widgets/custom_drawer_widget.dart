import 'package:flutter/material.dart';
import '../screens/screens.dart';
import '../utils/utils.dart';
import '../services/services.dart';
import 'widgets.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.primary,
      elevation: 0,
      child: ListView(
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 10),
        children: [
          DrawerListTiles(
            title: "Order History",
            icon: Icons.history,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const OrderHistoryScreen()),
            ),
          ),
          DrawerListTiles(
            title: "Sign Out",
            icon: Icons.logout,
            onTap: () {
             FirebaseDatabaseService().signOut(context);
            },
          ),
        ],
      ),
    );
  }
}
