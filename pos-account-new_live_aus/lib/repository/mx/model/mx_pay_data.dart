class MxPayData {
  final double totalAmount;
  final double surAmount;
  final double tipAmount;
  final MxPayType mxPayType;
  final String? orderId;

  MxPayData({
    required this.totalAmount,
    this.surAmount = 0.00,
    this.tipAmount = 0.00,
    required this.mxPayType,
    required this.orderId,
  });
}

enum MxPayType { Purchase, Refund, None }
