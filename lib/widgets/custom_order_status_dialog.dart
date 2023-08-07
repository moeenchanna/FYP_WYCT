import 'package:flutter/material.dart';
import 'package:fyp_what_you_cook_today/services/firebase_database_services.dart';
import 'package:fyp_what_you_cook_today/utils/utils.dart';

class CustomOrderStatusDialog extends StatelessWidget {
  final Map<String, dynamic> data;

  const CustomOrderStatusDialog({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SizedBox(
        height: 560,
        child: Card(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              const Text(
                "Order Details",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Image.network(
                data["productPicture"],
                height: 150,
                width: double.infinity,
                fit: BoxFit.fill,
              ),
              Padding(
                padding: const EdgeInsets.all(11.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Order Id: ${data["orderId"]}",
                      style: const TextStyle(
                          fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "Customer Name: ${data["customerName"]}",
                      style: const TextStyle(
                          fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "Customer Phone No#: ${data["customerPhone"]}",
                      style: const TextStyle(
                          fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "Customer Email: ${data["customerEmail"]}",
                      style: const TextStyle(
                          fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "Customer Address: ${data["customerAddress"]}",
                      style: const TextStyle(
                          fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "Number of Persons: ${data["numberOfPersons"]}",
                      style: const TextStyle(
                          fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "Total Order Amount Rs: ${data["orderPrice"]}",
                      style: const TextStyle(
                          fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "Product Name: ${data["productName"]}",
                      style: const TextStyle(
                          fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "Product Price: ${data["productPrice"]}",
                      style: const TextStyle(
                          fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "Product Details: ${data["productDetails"]}",
                      style: const TextStyle(
                          fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "Order Status: ${data["orderStatus"]}",
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: (data["orderStatus"]
                                  .toString()
                                  .contains("Processing"))
                              ? AppColors.processing
                              : (data["orderStatus"]
                                      .toString()
                                      .contains("Rejected"))
                                  ? AppColors.rejected
                                  : (data["orderStatus"]
                                          .toString()
                                          .contains("Delivered"))
                                      ? AppColors.delivered
                                      : AppColors.accepted),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () {
                            FirebaseDatabaseService().updateOrderStatusByAdmin(
                                context,
                                data["orderId"],
                                "Rejected",
                                data["customerFcmToken"],
                                data["productName"]);
                          },
                          icon: const Icon(
                            Icons.cancel_outlined,
                            size: 40,
                          ),
                          color: AppColors.rejected,
                        ),
                        IconButton(
                          onPressed: () {
                            FirebaseDatabaseService().updateOrderStatusByAdmin(
                                context,
                                data["orderId"],
                                "Accepted",
                                data["customerFcmToken"],
                                data["productName"]);
                          },
                          icon: const Icon(
                            Icons.done_outline_outlined,
                            size: 40,
                          ),
                          color: AppColors.accepted,
                        ),
                        IconButton(
                          onPressed: () {
                            FirebaseDatabaseService().updateOrderStatusByAdmin(
                                context,
                                data["orderId"],
                                "Delivered",
                                data["customerFcmToken"],
                                data["productName"]);
                          },
                          icon: const Icon(
                            Icons.delivery_dining_rounded,
                            size: 40,
                          ),
                          color: AppColors.delivered,
                        )
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
