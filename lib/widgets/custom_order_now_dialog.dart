import 'dart:developer';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:fyp_what_you_cook_today/services/firebase_database_services.dart';
import 'package:fyp_what_you_cook_today/utils/utils.dart';
import 'package:fyp_what_you_cook_today/widgets/widgets.dart';

class CustomOrderNowDialog extends StatelessWidget {
  final String productId;
  final String productName;
  final String productDetail;
  final String productPrice;
  final String productPicture;

  const CustomOrderNowDialog({
    Key? key,
    required this.productId,
    required this.productName,
    required this.productDetail,
    required this.productPrice,
    required this.productPicture,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<int> items = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
    String? selectedPersonsValue;
    int updatedPrice = int.parse(productPrice);

    return Dialog(
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Image.network(
              productPicture,
              height: 250,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 10),
            Text(
              productName,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              productDetail,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 10),
            Center(
              child: DropdownButtonHideUnderline(
                child: DropdownButton2(
                  hint: const Text(
                    'Select No Of Persons',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryDark,
                    ),
                  ),
                  items: items
                      .map((item) => DropdownMenuItem<String>(
                            value: "$item",
                            child: Text(
                              "$item",
                              style: const TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          ))
                      .toList(),
                  value: selectedPersonsValue,
                  onChanged: (value) {
                    selectedPersonsValue = value as String;
                    updatedPrice = int.parse(selectedPersonsValue!) *
                        int.parse(productPrice);
                    log("updated Price $updatedPrice");
                  },
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Rs: $productPrice",
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 10),
            CustomButton(
                onPressed: () {
                  if (selectedPersonsValue == null) {
                    HelperUtils.showSnackBar(
                        context: context,
                        isSuccess: false,
                        title: "Order Failed",
                        message: "Please select no of persons.");
                  } else {
                    showAlertDialog(
                        context, updatedPrice, selectedPersonsValue!);
                  }
                },
                label: 'Order Now'),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  showAlertDialog(
      BuildContext context, int updatedPrice, String selectedPersonsValue) {
    // set up the buttons
    Widget cancelButton = CustomButton(
        onPressed: () {
          Navigator.pop(context);
        },
        label: "Cancel");
    Widget continueButton = CustomButton(
        onPressed: () {
          FirebaseDatabaseService().addOrderToFireStore(
              context,
              productName,
              productDetail,
              productPrice,
              productPicture,
              updatedPrice.toString(),
              selectedPersonsValue);
          Navigator.pop(context);
          Navigator.pop(context);
        },
        label: "Continue");

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("The total cost of your order is Rs: $updatedPrice"),
      content: const Text(
          "Before proceeding, may I confirm whether you would like to submit this order or adjust the number of persons included in the order?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
