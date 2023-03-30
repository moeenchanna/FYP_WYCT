import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../constant/constant.dart';
import '../services/services.dart';
import '../utils/utils.dart';
import '../widgets/widgets.dart';
import 'screens.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
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

  final CollectionReference collectionReference = FirebaseFirestore.instance
      .collection(FirebaseConstant.COLLECTION_FOR_PRODUCTS);
  Stream<QuerySnapshot> getStream() => collectionReference.snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      drawer: const CustomDrawer(),
      appBar: CustomAppBar(title: (isAdmin) ? "ADMIN BOARD" : "DASHBOARD"),
      body: StreamBuilder<QuerySnapshot>(
        stream: getStream(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text('Loading...');
          }

          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data() as Map<String, dynamic>;

              // return a ListTile for each document in the collection
              return Padding(
                padding: const EdgeInsets.only(left: 10, right: 10, top: 8),
                child: Card(
                  color: AppColors.primaryDark,
                  elevation: 2,
                  child: ListTile(
                    title: Text(
                      data['name'],
                      style: const TextStyle(
                          color: AppColors.textColor,
                          fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      "Details: ${data['details']}",
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.textColor,
                      ),
                    ),
                    trailing: Text(
                      "Rs: ${data['price']}",
                      style: const TextStyle(
                          color: AppColors.textColor,
                          fontWeight: FontWeight.bold),
                    ),
                    leading: CircleAvatar(
                      radius: 35.0, // Image radius
                      backgroundImage: NetworkImage(data['pictureLink']),
                      backgroundColor: AppColors.white,
                    ),
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
      floatingActionButton: CustomFloatingActionButton(
        label: (isAdmin) ? "Add Product" : "Special Order",
        iconData:
            (isAdmin) ? Icons.dashboard_customize_outlined : Icons.diamond,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => (isAdmin)
                  ? const AddProductScreen()
                  : const SpecialOrderScreen(),
            ),
          );
        },
      ),
    );
  }
}
