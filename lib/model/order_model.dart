class OrderModel {
  String orderId;
  String marketplace;
  String sellerName;
  String trackingStatus;
  String orderDate;
  String expectedDispatchDate;
  String actualDeliveryDate;
  String customerName;
  String buyerContactNo;
  String deliveryImageFilePath;

  // --- New Fields for Challan/Address ---
  String sellerGSTIN;
  String challanNo;
  String buyerAddressDetails;
  // -------------------------------------

  OrderModel({
    required this.orderId,
    required this.marketplace,
    required this.sellerName,
    required this.trackingStatus,
    required this.orderDate,
    required this.expectedDispatchDate,
    required this.actualDeliveryDate,
    required this.customerName,
    required this.buyerContactNo,
    this.deliveryImageFilePath = '',
    // Initialize new fields
    this.sellerGSTIN = '',
    this.challanNo = '',
    this.buyerAddressDetails = '',
  });

  Map<String, dynamic> toMap() {
    return {
      'orderId': orderId,
      'marketplace': marketplace,
      'sellerName': sellerName,
      'trackingStatus': trackingStatus,
      'orderDate': orderDate,
      'expectedDispatchDate': expectedDispatchDate,
      'actualDeliveryDate': actualDeliveryDate,
      'customerName': customerName,
      'buyerContactNo': buyerContactNo,
      'deliveryImageFilePath': deliveryImageFilePath,
      // Map new fields
      'sellerGSTIN': sellerGSTIN,
      'challanNo': challanNo,
      'buyerAddressDetails': buyerAddressDetails,
    };
  }

  factory OrderModel.fromMap(Map<String, dynamic> map) {
    return OrderModel(
      orderId: map['orderId'] ?? '',
      marketplace: map['marketplace'] ?? '',
      sellerName: map['sellerName'] ?? '',
      trackingStatus: map['trackingStatus'] ?? '',
      orderDate: map['orderDate'] ?? '',
      expectedDispatchDate: map['expectedDispatchDate'] ?? '',
      actualDeliveryDate: map['actualDeliveryDate'] ?? '',
      customerName: map['customerName'] ?? '',
      buyerContactNo: map['buyerContactNo'] ?? '',
      deliveryImageFilePath: map['deliveryImageFilePath'] ?? '',
      // Read new fields (provide default empty string if null)
      sellerGSTIN: map['sellerGSTIN'] ?? '',
      challanNo: map['challanNo'] ?? '',
      buyerAddressDetails: map['buyerAddressDetails'] ?? '',
    );
  }
}