class SpecialOrderModel {
  String specialOrderId;
  String customerName;
  String customerPhone;
  String customerEmail;
  String orderName;
  String orderDetails;
  String orderAddress;
  String numberOfPersons;
  DateTime createdAt;

  SpecialOrderModel({
    required this.specialOrderId,
    required this.customerName,
    required this.customerPhone,
    required this.customerEmail,
    required this.orderName,
    required this.orderDetails,
    required this.orderAddress,
    required this.numberOfPersons,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'specialOrderId': specialOrderId,
      'customerName': customerName,
      'customerPhone': customerPhone,
      'customerEmail': customerEmail,
      'orderName': orderName,
      'orderDetails': orderDetails,
      'orderAddress': orderAddress,
      'numberOfPersons': numberOfPersons,
      'createdAt': createdAt,
    };
  }

  factory SpecialOrderModel.fromMap(Map<String, dynamic> map) {
    return SpecialOrderModel(
      specialOrderId: map['id'],
      customerName: map['customerName'],
      customerPhone: map['customerPhone'],
      customerEmail: map['customerEmail'],
      orderName: map['orderName'],
      orderDetails: map['orderDetails'],
      orderAddress: map['orderAddress'],
      numberOfPersons: map['numberOfPersons'],
      createdAt: DateTime.parse(map['createdAt']),
    );
  }
}
