import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../constant/constant.dart';
import '../screens/screens.dart';
import '../utils/utils.dart';
import '../services/services.dart';
import 'widgets.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}
class _CustomDrawerState extends State<CustomDrawer> {

  bool isAdmin = false;


  @override
  void initState() {
    isAdmin = FirebaseDatabaseService()
        .currentUser!
        .email
        ?.contains(FirebaseConstant.GET_ADMIN) ??
        false;
    FirebaseDatabaseService().updateUser(context, true);

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.primary,
      elevation: 0,
      child: ListView(
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 10),
        children: [
          if (!isAdmin)
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
