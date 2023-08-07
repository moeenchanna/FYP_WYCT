import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../constant/constant.dart';
import '../services/firebase_database_services.dart';
import '../utils/utils.dart';
import '../widgets/widgets.dart';

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({Key? key}) : super(key: key);

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {

  CollectionReference collectionReferenceForOrders = FirebaseFirestore.instance
      .collection(FirebaseConstant.COLLECTION_FOR_ORDERS);


  var currentUserId;
  @override
  void initState() {
    // TODO: implement initState
    currentUserId = FirebaseDatabaseService().currentUser!.uid;
    log("currentUserId $currentUserId");
    super.initState();
  }

  Stream<QuerySnapshot> getStreamForOrders() => collectionReferenceForOrders
      .where("customerId", isEqualTo: currentUserId)
      .snapshots();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: "ORDER HISTORY"),
      body: StreamBuilder<QuerySnapshot>(
        stream: getStreamForOrders(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: const TextStyle(
                    color: AppColors.errorColor, fontWeight: FontWeight.bold),
              ),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: Text('Loading...',
                    style: TextStyle(
                        color: AppColors.primaryDark,
                        fontWeight: FontWeight.bold)));
          }

          // Check if the snapshot has no data (stream is empty)
          if (snapshot.data == null || snapshot.data!.size == 0) {
            return const Center(
              child: Text(
                'No Orders Found',
                style: TextStyle(
                  color: AppColors.textColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            );
          }

          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data() as Map<String, dynamic>;

              log("data $data");

              return Padding(
                padding: const EdgeInsets.all(2.0),
                child: Card(
                  color: HelperUtils.getOrderStatusColor(data["orderStatus"]),
                  elevation: 2,
                  child: ListTile(
                    title: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Order Id: ${data["orderId"]}',
                            style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.textColor,
                                fontWeight: FontWeight.w800),
                          ),
                          Text(
                            'Customer Name: ${data["customerName"]}',
                            style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.textColor,
                                fontWeight: FontWeight.w800),
                          ),
                          Text(
                            'Total Amount of Rs: ${data["orderPrice"]}',
                            style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.textColor,
                                fontWeight: FontWeight.w800),
                          ),
                        ],
                      ),
                    ),
                    trailing: (data["orderStatus"]
                            .toString()
                            .contains("Processing"))
                        ? const Icon(Icons.timelapse_rounded,
                            color: AppColors.white)
                        : (data["orderStatus"].toString().contains("Rejected"))
                            ? const Icon(Icons.cancel, color: AppColors.white)
                            : (data["orderStatus"]
                                    .toString()
                                    .contains("Delivered"))
                                ? const Icon(Icons.delivery_dining_sharp,
                                    color: AppColors.white)
                                : const Icon(Icons.done_all_outlined,
                                    color: AppColors.white),
                    leading: CircleAvatar(
                      radius: 32.0,
                      // Image radius
                      backgroundImage: NetworkImage(data['productPicture']),
                      backgroundColor: AppColors.white,
                    ),
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
