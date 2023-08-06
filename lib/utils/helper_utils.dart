import 'dart:math';

import 'package:flutter/material.dart';
import 'package:another_flushbar/flushbar.dart';

import 'utils.dart';

class HelperUtils {
  static void showSnackBar(
      {required BuildContext context,
      required bool isSuccess,
      required String title,
      required String message,
      int seconds = 3}) {
    Flushbar(
      backgroundColor: isSuccess
          ? AppColors.successSnackbarColor
          : AppColors.errorSnackbarColor,
      titleColor: AppColors.textColor,
      messageColor: AppColors.textColor,
      flushbarStyle: FlushbarStyle.FLOATING,
      flushbarPosition: FlushbarPosition.TOP,
      margin: const EdgeInsets.all(8),
      borderRadius: BorderRadius.circular(10),
      title: title,
      message: message,
      duration: Duration(seconds: seconds),
    ).show(context);
  }

  static void showCircularProgressDialog(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return const Center(
          child: CircularProgressIndicator(
            color: AppColors.primary,
          ),
        );
      },
    );
  }

  static String generateUniqueId() {
    DateTime now = DateTime.now();
    String uniqueID = now.microsecondsSinceEpoch.toString();
    return uniqueID;
  }

  static Color getOrderStatusColor(String orderStatus) {
    switch (orderStatus) {
      case "Processing":
        return AppColors.processing;
      case "Accepted":
        return AppColors.accepted;
      case "Delivered":
        return AppColors.delivered;
      case "Rejected":
        return AppColors.rejected;
      default:
        return AppColors.primaryDark;
    }
  }

  int generateRandomId() {
    return Random().nextInt(100);
  }
}
