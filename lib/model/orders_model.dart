class OrderModel {
  String orderId;
  String customerId;
  String customerName;
  String customerPhone;
  String customerEmail;
  String customerAddress;
  String customerFcmToken;
  String orderPrice;
  String productName;
  String productDetails;
  String productPrice;
  String productPicture;
  String numberOfPersons;
  String orderStatus;
  DateTime createdAt;

  OrderModel({
    required this.orderId,
    required this.customerId,
    required this.customerName,
    required this.customerPhone,
    required this.customerEmail,
    required this.customerAddress,
    required this.customerFcmToken,
    required this.orderPrice,
    required this.productName,
    required this.productDetails,
    required this.productPrice,
    required this.productPicture,
    required this.numberOfPersons,
    required this.orderStatus,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'orderId': orderId,
      'customerId': customerId,
      'customerName': customerName,
      'customerPhone': customerPhone,
      'customerEmail': customerEmail,
      'customerAddress': customerAddress,
      'customerFcmToken': customerFcmToken,
      'orderPrice': orderPrice,
      'productName': productName,
      'productDetails': productDetails,
      'productPrice': productPrice,
      'productPicture': productPicture,
      'numberOfPersons': numberOfPersons,
      'orderStatus': orderStatus,
      'createdAt': createdAt,
    };
  }

  factory OrderModel.fromMap(Map<String, dynamic> map) {
    return OrderModel(
      orderId: map['orderId'],
      customerId: map['customerId'],
      customerName: map['customerName'],
      customerPhone: map['customerPhone'],
      customerEmail: map['customerEmail'],
      customerAddress: map['customerAddress'],
      customerFcmToken: map['customerFcmToken'],
      orderPrice: map['orderPrice'],
      productName: map['productName'],
      productDetails: map['productDetails'],
      productPrice: map['productPrice'],
      productPicture: map['productPicture'],
      numberOfPersons: map['numberOfPersons'],
      orderStatus: map['orderStatus'],
      createdAt: DateTime.parse(map['createdAt']),
    );
  }
}
