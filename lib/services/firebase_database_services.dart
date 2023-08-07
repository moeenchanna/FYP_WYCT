import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../constant/constant.dart';
import '../model/models.dart';
import '../screens/screens.dart';
import '../utils/utils.dart';
import 'package:http/http.dart' as http;

class FirebaseDatabaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final User? currentUser = FirebaseAuth.instance.currentUser;

  static final CollectionReference customerCollectionReference =
  FirebaseFirestore.instance
      .collection(FirebaseConstant.COLLECTION_FOR_CUSTOMERS);
  static final CollectionReference productCollectionReference =
  FirebaseFirestore.instance
      .collection(FirebaseConstant.COLLECTION_FOR_PRODUCTS);
  static final CollectionReference specialOrderCollectionReference =
  FirebaseFirestore.instance
      .collection(FirebaseConstant.COLLECTION_FOR_SPECIAL_ORDERS);
  static final CollectionReference orderCollectionReference = FirebaseFirestore
      .instance
      .collection(FirebaseConstant.COLLECTION_FOR_ORDERS);

  Future<void> authenticationUser(BuildContext context, String email,
      String password) async {
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

  Future<void> onAuthenticationSuccess(BuildContext context, User user) async {
    log('Authentication successful');
    // Define data to be updated
    Map<String, dynamic> updateData = {
      'customerFcmToken': await NotificationHelper().token(),
    };

    // Update document in collection reference
    customerCollectionReference
        .doc(user.uid)
        .update(updateData)
        .then((value) => {log("Token Updated: $updateData")})
        .catchError((error) => log("Failed to update user: $error"));

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
      String email, String password, String address) async {
    try {
      HelperUtils.showCircularProgressDialog(context);
      var result = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      onRegistrationSuccess(
          context, result.user!, name, phone, password, address);
    } catch (e) {
      onRegistrationFailure(context, e);
    }
  }

  Future<void> onRegistrationSuccess(BuildContext context, User user, String name,
      String phone, String password, String address) async {
    log('Authentication successful');

    UserModel userModel = UserModel(
        id: user.uid,
        name: name,
        phone: phone,
        email: user.email.toString(),
        password: password,
        address: address,
        token: await NotificationHelper().token(),
        active: false,
        lastSeen: DateTime.now(),
        createdAt: DateTime.now()
    );
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
          TextEditingControllers.orderAddress.clear();

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
      TextEditingControllers.name.clear();
      TextEditingControllers.phone.clear();
      TextEditingControllers.email.clear();
      TextEditingControllers.password.clear();
      TextEditingControllers.orderAddress.clear();

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
        .then((value) async =>
    {
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

      TextEditingControllers.productName.clear();
      TextEditingControllers.productDetails.clear();
      TextEditingControllers.productPrice.clear();
      TextEditingControllers.productPicture.clear();

      HelperUtils.showSnackBar(
        context: context,
        isSuccess: false,
        title: "Failed",
        message: "Product Creation Failed. Try Again.",
      );
    }
  }

  addSpecialOrderToFireStore(BuildContext context,
      String name,
      String phone,
      String email,
      String orderName,
      String orderDetails,
      String orderAddress,
      String numberOfPersons) {
    HelperUtils.showCircularProgressDialog(context);

    SpecialOrderModel specialOrderModel = SpecialOrderModel(
        specialOrderId: HelperUtils.generateUniqueId(),
        customerName: name,
        customerPhone: phone,
        customerEmail: email,
        orderName: orderName,
        orderDetails: orderDetails,
        orderAddress: orderAddress,
        numberOfPersons: numberOfPersons,
        createdAt: DateTime.now());

    Map<String, dynamic> specialOrderMap = specialOrderModel.toMap();
    log("Special Order Data $specialOrderMap");

    try {
      specialOrderCollectionReference
          .doc(specialOrderModel.specialOrderId)
          .set(specialOrderMap);
      Future.delayed(
        const Duration(seconds: FirebaseConstant.RESPONSE_DELAY_TIME),
            () {
          Navigator.pop(context);
          TextEditingControllers.name.clear();
          TextEditingControllers.phone.clear();
          TextEditingControllers.email.clear();
          TextEditingControllers.orderName.clear();
          TextEditingControllers.orderDetails.clear();
          TextEditingControllers.orderAddress.clear();
          TextEditingControllers.numberOfPersons.clear();

          HelperUtils.showSnackBar(
            context: context,
            isSuccess: true,
            title: "Success",
            message: "Special Order Created Successfully",
          );
        },
      );
    } catch (error) {
      log("Failed to create special orders: $error");

      Navigator.pop(context);

      TextEditingControllers.name.clear();
      TextEditingControllers.phone.clear();
      TextEditingControllers.email.clear();
      TextEditingControllers.orderName.clear();
      TextEditingControllers.orderDetails.clear();
      TextEditingControllers.orderAddress.clear();
      TextEditingControllers.numberOfPersons.clear();

      HelperUtils.showSnackBar(
        context: context,
        isSuccess: false,
        title: "Failed",
        message: "Special Order Creation Failed. Try Again.",
      );
    }
  }

  addOrderToFireStore(BuildContext context,
      String productName,
      String productDetail,
      String productPrice,
      String productPicture,
      String orderPrice,
      String numberOfPersons,) async {
    HelperUtils.showCircularProgressDialog(context);

    customerCollectionReference.doc(currentUser!.uid).get().then(
          (DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.exists) {
          log('Document data: ${documentSnapshot.data()}');
          //Navigator.pop(context);
          OrderModel orderModel = OrderModel(
              orderId: HelperUtils.generateUniqueId(),
              customerId: currentUser!.uid,
              customerName: documentSnapshot.get("name"),
              customerPhone: documentSnapshot.get("phone"),
              customerEmail: documentSnapshot.get("email"),
              customerAddress: documentSnapshot.get("address"),
              customerFcmToken: documentSnapshot.get("token"),
              orderPrice: orderPrice,
              productName: productName,
              productDetails: productDetail,
              productPrice: productPrice,
              productPicture: productPicture,
              numberOfPersons: numberOfPersons,
              orderStatus: "Processing",
              createdAt: DateTime.now());

          Map<String, dynamic> orderMap = orderModel.toMap();
          log("Order Data $orderMap");

          try {
            orderCollectionReference.doc(orderModel.orderId).set(orderMap);
            Future.delayed(
              const Duration(seconds: FirebaseConstant.RESPONSE_DELAY_TIME),
                  () {
                Navigator.pop(context);

                HelperUtils.showSnackBar(
                  context: context,
                  isSuccess: true,
                  title: "Success",
                  message: "Order Submitted Successfully",
                );
              },
            );
          } catch (error) {
            log("Failed to create order: $error");

            Navigator.pop(context);

            HelperUtils.showSnackBar(
              context: context,
              isSuccess: false,
              title: "Failed",
              message: "Order Submit Failed. Try Again.",
            );
          }
        } else {
          print('Document does not exist on the database');
        }
      },
    );
  }

  updateOrderStatusByAdmin(BuildContext context, String orderId,
      String status,String customerFcmToken,String productName) {
    // Define data to be updated
    Map<String, dynamic> updateData = {
      'orderStatus': status,
      'createdAt': DateTime.now(),
    };
    orderCollectionReference
        .doc(orderId)
        .update(updateData)
        .then((value) async =>
    {
   await pushNotificationsSpecificDevice(
    token: customerFcmToken,
    title: "Order Alert",
    body: "Your Order $productName has been $status"),

      log("Status Updated"),
      Navigator.pop(context),
      if (status.contains("Rejected"))
        {
          HelperUtils.showSnackBar(
            context: context,
            isSuccess: false,
            title: "Order Reject",
            message: "Order Rejected Successfully",
          ),

        }
      else
        if (status.contains("Delivered"))
          {
            HelperUtils.showSnackBar(
              context: context,
              isSuccess: true,
              title: "Order Deliverer",
              message: "Order is ready to go",
            ),
          }
        else
          {
            HelperUtils.showSnackBar(
              context: context,
              isSuccess: true,
              title: "Order Accepted",
              message: "Order Accepted Successfully",
            ),
          }
    })
        .catchError((error) => log("Failed to update user: $error"));
  }


  Future<bool> pushNotificationsSpecificDevice({
    required String? token,
    required String? title,
    required String? body,
  }) async {
    String dataNotifications = '{ "to" : "$token",'
        ' "notification" : {'
        ' "title":"$title",'
        '"body":"$body"'
        ' }'
        ' }';

    try {
      final response = await http.post(
        Uri.parse(FirebaseConstant.fcmBaseUrl),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'key= ${FirebaseConstant.serverKey}',
        },
        body: dataNotifications,
      );

      log('FCM Response Status Code: ${response.statusCode}');
      log('FCM Response Body: ${response.body}');

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      log('Error sending push notification: $e');
      return false;
    }
  }
}
