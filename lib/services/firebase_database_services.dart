import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../constant/constant.dart';
import '../model/models.dart';
import '../screens/screens.dart';
import '../utils/utils.dart';

class FirebaseDatabaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final User? currentUser = FirebaseAuth.instance.currentUser;

  static final CollectionReference customerCollectionReference =
      FirebaseFirestore.instance
          .collection(FirebaseConstant.COLLECTION_FOR_CUSTOMERS);
  static final CollectionReference productCollectionReference =
      FirebaseFirestore.instance
          .collection(FirebaseConstant.COLLECTION_FOR_PRODUCTS);

  Future<void> authenticationUser(
      BuildContext context, String email, String password) async {
    try {
      HelperUtils.showCircularProgressDialog(context);
      var result = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      onAuthenticationSuccess(context, result.user!);
    } catch (e) {
      onAuthenticationFailure(context, e);
    }
  }

  void onAuthenticationSuccess(BuildContext context, User user) {
    log('Authentication successful');

    HelperUtils.showSnackBar(
      context: context,
      isSuccess: true,
      title: "Authentication Successful",
      message: "Welcome Home ${user.email}",
    );
    Future.delayed(
        const Duration(seconds: FirebaseConstant.RESPONSE_DELAY_TIME), () {
      Navigator.pop(context); // Dismiss the progress dialog
      TextEditingControllers.email.clear();
      TextEditingControllers.password.clear();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) => const DashboardScreen(),
        ),
        (route) => false,
      );
    });
  }

  void onAuthenticationFailure(BuildContext context, e) {
    Future.delayed(
        const Duration(seconds: FirebaseConstant.RESPONSE_DELAY_TIME), () {
      Navigator.pop(context);
      if (e.code == 'user-not-found') {
        log('No user found for that email.');
        HelperUtils.showSnackBar(
          context: context,
          isSuccess: false,
          title: "Authentication Failed",
          message: 'No user found for that email.',
        );
      } else if (e.code == 'wrong-password') {
        log('Wrong password provided for that user.');
        HelperUtils.showSnackBar(
          context: context,
          isSuccess: false,
          title: "Authentication Failed",
          message: 'Wrong password provided for that user.',
        );
      }
    });
  }

  Future<void> registrationUser(BuildContext context, String name, String phone,
      String email, String password) async {
    try {
      HelperUtils.showCircularProgressDialog(context);
      var result = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      onRegistrationSuccess(context, result.user!, name, phone, password);
    } catch (e) {
      onRegistrationFailure(context, e);
    }
  }

  void onRegistrationSuccess(BuildContext context, User user, String name,
      String phone, String password) {
    log('Authentication successful');

    UserModel userModel = UserModel(
        id: user.uid,
        name: name,
        phone: phone,
        email: user.email.toString(),
        password: password,
        token: "Not Available",
        active: false,
        lastSeen: DateTime.now(),
        createdAt: DateTime.now());
    Map<String, dynamic> userMap = userModel.toMap();
    log("UserData: $userMap");

    try {
      customerCollectionReference.doc(user.uid).set(userMap);
      Future.delayed(
        const Duration(seconds: FirebaseConstant.RESPONSE_DELAY_TIME),
        () {
          Navigator.pop(context); // Dismiss the progress dialog
          TextEditingControllers.name.clear();
          TextEditingControllers.phone.clear();
          TextEditingControllers.email.clear();
          TextEditingControllers.password.clear();

          HelperUtils.showSnackBar(
            context: context,
            isSuccess: true,
            title: "Registration Successful",
            message: "Account created successfully",
          );
        },
      );
    } catch (error) {
      log("Failed to add user: $error");

      Navigator.pop(context);
      HelperUtils.showSnackBar(
        context: context,
        isSuccess: false,
        title: "Registration Failed",
        message: "Failed to register user!",
      );
    }
  }

  void onRegistrationFailure(BuildContext context, e) {
    Navigator.pop(context);

    if (e.code == 'weak-password') {
      log('weak-password.');
      HelperUtils.showSnackBar(
        context: context,
        isSuccess: false,
        title: "weak password",
        message: 'The password provided is too weak.',
      );
    } else if (e.code == 'email-already-in-use') {
      log('email-already-in-use.');
      HelperUtils.showSnackBar(
        context: context,
        isSuccess: false,
        title: "Email already in use",
        message: 'The account already exists for that email',
      );
    } else {
      log('Unknown Error: ${e.message}');
      HelperUtils.showSnackBar(
        context: context,
        isSuccess: false,
        title: "Registration Failed",
        message: "Failed to register user!",
      );
    }
  }

  Future<void> resetEmail(BuildContext context, String email) async {
    try {
      HelperUtils.showCircularProgressDialog(context);
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      onResetPasswordSuccess(context);
    } catch (e) {
      onResetPasswordFailure(context, e);
    }
  }

  void onResetPasswordSuccess(BuildContext context) {
    log('Authentication successful');

    Future.delayed(
        const Duration(seconds: FirebaseConstant.RESPONSE_DELAY_TIME), () {
      TextEditingControllers.email.clear();
      Navigator.pop(context); // Dismiss the progress dialog
      HelperUtils.showSnackBar(
        context: context,
        isSuccess: true,
        seconds: 5,
        title: "Password reset request sent",
        message:
            "You have received an email to update your password. Please review it.",
      );
    });
  }

  void onResetPasswordFailure(BuildContext context, e) {
    Future.delayed(
        const Duration(seconds: FirebaseConstant.RESPONSE_DELAY_TIME), () {
      Navigator.pop(context);
      if (e.code == 'user-not-found') {
        log('No user found for that email.');
        HelperUtils.showSnackBar(
          context: context,
          isSuccess: false,
          title: "Authentication Failed",
          message: 'No user found for that email.',
        );
      } else if (e.code == 'wrong-password') {
        log('Wrong password provided for that user.');
        HelperUtils.showSnackBar(
          context: context,
          isSuccess: false,
          title: "Authentication Failed",
          message: 'Wrong password provided for that user.',
        );
      }
    });
  }

  void signOut(BuildContext context) {
    HelperUtils.showCircularProgressDialog(context);
    updateUser(context, false);
  
  }

  // Updates user data in Firestore
  void updateUser(BuildContext context, bool isActive) {
    // Define data to be updated
    Map<String, dynamic> updateData = {
      'active': isActive,
      'last_seen': DateTime.now(),
    };

    // Update document in collection reference
    customerCollectionReference
        .doc(currentUser!.uid)
        .update(updateData)
        .then((value) async => {
       
              log("User Updated"),
              // If isActive is false, sign out user and navigate to login screen
              if (isActive == false)
                {
                  log("User Logout"),
                  HelperUtils.showSnackBar(
                    context: context,
                    isSuccess: true,
                    title: "Signing out",
                    message: "See you soon!",
                  ),

                  await _auth.signOut(),
                  Future.delayed(
                      const Duration(
                          seconds: FirebaseConstant.RESPONSE_DELAY_TIME), () {
                    Navigator.pop(context); // Dismiss the progress dialog

                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginScreen()),
                      (route) => false,
                    );
                  }),
                }
            })
        .catchError((error) => log("Failed to update user: $error"));
  }

  addProductToFireStore(BuildContext context, String productName,
      String productDetail, String productPrice, String productPicture) {
            HelperUtils.showCircularProgressDialog(context);

    ProductModel productModel = ProductModel(
        id: HelperUtils.generateUniqueId(),
        name: productName,
        details: productDetail,
        price: productPrice,
        pictureLink: (productPicture.isEmpty)
            ? FirebaseConstant.DUMMY_EMPTY_IMAGE_URL
            : productPicture,
        createdAt: DateTime.now());

    Map<String, dynamic> productMap = productModel.toMap();
    log("ProductData $productMap");

    try {
      productCollectionReference.doc(productModel.id).set(productMap);
      Future.delayed(
        const Duration(seconds: FirebaseConstant.RESPONSE_DELAY_TIME),
        () {
          Navigator.pop(context);
          TextEditingControllers.productName.clear();
          TextEditingControllers.productDetails.clear();
          TextEditingControllers.productPrice.clear();
          TextEditingControllers.productPicture.clear();

          HelperUtils.showSnackBar(
            context: context,
            isSuccess: true,
            title: "Success",
            message: "Product Added Successful",
          );
        },
      );
    } catch (error) {
      log("Failed to add products: $error");

      Navigator.pop(context);
      HelperUtils.showSnackBar(
        context: context,
        isSuccess: false,
        title: "Failed",
        message: "Product Creation Failed. Try Again.",
      );
    }
  }
}
